#!/bin/bash
#
# operator-images-validator.sh
# 
# A tool to validate that all required container images for OpenShift operators
# are available in a target container registry.
#
# Usage:
#   ./operator-images-validator.sh list --catalog <catalog-image>
#   ./operator-images-validator.sh versions --catalog <catalog-image> --operator <operator-name>
#   ./operator-images-validator.sh validate --catalog <catalog-image> --operators <op1:ch1,op2,...>
#   ./operator-images-validator.sh idms-validate --idms <idms-file>
#

set -euo pipefail

# Colors for output (using $'...' for proper escape sequence handling)
# Basic colors
RED=$'\033[0;31m'
GREEN=$'\033[0;32m'
YELLOW=$'\033[0;33m'
BLUE=$'\033[0;34m'
MAGENTA=$'\033[0;35m'
CYAN=$'\033[0;36m'
WHITE=$'\033[0;37m'

# Bright/Bold colors
BRED=$'\033[1;31m'
BGREEN=$'\033[1;32m'
BYELLOW=$'\033[1;33m'
BBLUE=$'\033[1;34m'
BMAGENTA=$'\033[1;35m'
BCYAN=$'\033[1;36m'
BWHITE=$'\033[1;37m'

# Dim colors (for less important info)
DIM=$'\033[2m'

# Text styles
BOLD=$'\033[1m'
UNDERLINE=$'\033[4m'
NC=$'\033[0m' # Reset

# Semantic colors
INFO="${BCYAN}"        # Bright cyan for info
SUCCESS="${BGREEN}"    # Bright green for success
WARNING="${BYELLOW}"   # Bright yellow for warnings
ERROR="${BRED}"        # Bright red for errors
DEBUG="${DIM}${CYAN}"  # Dim cyan for debug
HEADER="${BMAGENTA}"   # Bright magenta for headers
ACCENT="${BBLUE}"      # Bright blue for accents
MUTED="${DIM}${WHITE}" # Dim white for muted text

# Default values
INDEX_IMAGE=""
TARGET_REGISTRY=""
OPERATORS=""
OPERATOR=""
CHANNEL=""
VERSION=""
AUTH_FILE=""
OUTPUT_FORMAT="table"
WORK_DIR=""
PARALLEL_JOBS=10
FILTER=""
DEBUG=false
VERBOSE=false

# Script version
VERSION_STRING="1.0.0"

# Known operator dependencies (meta-operators that install other operators)
# Format: "parent_operator:dep1,dep2,dep3"
declare -A OPERATOR_DEPENDENCIES=(
    # ODF (OpenShift Data Foundation) and its dependent operators
    ["odf-operator"]="ocs-operator,mcg-operator,odf-csi-addons-operator,rook-ceph-operator,odf-prometheus-operator,cephcsi-operator"
    
    # ACM (Advanced Cluster Management) depends on MCE
    ["advanced-cluster-management"]="multicluster-engine"
    
    # OpenShift Logging (cluster-logging) depends on these
    ["cluster-logging"]="loki-operator,elasticsearch-operator"
    
    # OpenShift Serverless
    ["serverless-operator"]="knative-serving,knative-eventing"
    
    # OpenShift Service Mesh
    ["servicemeshoperator"]="kiali-ossm,jaeger-product"
)

# Flag to include dependencies
INCLUDE_DEPS="true"

# IDMS file path
IDMS_FILE=""

# Associative array to store IDMS mappings (source -> mirror)
declare -A IDMS_MAPPINGS
IDMS_MAPPING_COUNT=0

# Associative array to store operator channels (operator -> channel)
declare -A OPERATOR_CHANNELS

#######################################
# Print usage information
#######################################
usage() {
    cat << EOF

${HEADER}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}
  ${BWHITE}${BOLD}operator-images-validator${NC}  ${MUTED}v${VERSION_STRING}${NC}
  ${MUTED}Validate OpenShift operator images availability in target registries${NC}
${HEADER}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}

${BWHITE}USAGE${NC}
    ${ACCENT}$0${NC} ${MUTED}<command>${NC} [options]

${BWHITE}COMMANDS${NC}
    ${BCYAN}list${NC}                List all operators available in an index
    ${BCYAN}versions${NC}            List versions/channels for a specific operator
    ${BCYAN}validate${NC}            Validate images exist in target registry
    ${BCYAN}idms-validate${NC}       Validate all mirrors in IDMS file are accessible

${BWHITE}GLOBAL OPTIONS${NC}
    ${BGREEN}--catalog${NC} ${MUTED}<image>${NC}       Operator catalog image (required)
                            ${DIM}Example: registry.redhat.io/redhat/redhat-operator-index:v4.22${NC}
    ${BGREEN}--auth-file${NC} ${MUTED}<path>${NC}      Path to pull secret JSON file
    ${BGREEN}-v, --verbose${NC}           Show detailed progress information
    ${BGREEN}-h, --help${NC}              Show this help message

${BWHITE}LIST OPTIONS${NC}
    ${BGREEN}--filter${NC} ${MUTED}<pattern>${NC}      Filter operators by regex pattern

${BWHITE}VERSIONS OPTIONS${NC}
    ${BGREEN}--operator${NC} ${MUTED}<name>${NC}       Operator name (required)
    ${BGREEN}--channel${NC} ${MUTED}<channel>${NC}     Show versions for specific channel

${BWHITE}VALIDATE OPTIONS${NC}
    ${BGREEN}--operators${NC} ${MUTED}<list>${NC}      Comma-separated list of operators ${DIM}(format: op1:channel,op2)${NC}
    ${BGREEN}--target-registry${NC} ${MUTED}<reg>${NC} Target registry to validate against ${DIM}(optional)${NC}
    ${BGREEN}--idms${NC} ${MUTED}<file>${NC}           IDMS (ImageDigestMirrorSet) YAML file for mirror mappings ${DIM}(optional)${NC}
    ${BGREEN}--channel${NC} ${MUTED}<channel>${NC}     Default channel for operators without specified channel
    ${BGREEN}--version${NC} ${MUTED}<version>${NC}     Use specific version
    ${BGREEN}--output-format${NC} ${MUTED}<fmt>${NC}   Output format: table, json, yaml, remediation ${DIM}(default: table)${NC}
    ${BGREEN}--parallel${NC} ${MUTED}<n>${NC}          Number of parallel image checks ${DIM}(default: 10)${NC}
    ${BGREEN}--no-deps${NC}               Skip automatic dependency resolution
    
    ${INFO}▸${NC}  For ${SUCCESS}GA releases${NC}, omit both options to validate at source registry.
    ${INFO}▸${NC}  For ${WARNING}disconnected${NC} environments, use ${BGREEN}--idms${NC} or ${BGREEN}--target-registry${NC}.

${BWHITE}DEPENDENCY RESOLUTION${NC}
    ${MUTED}By default, the tool automatically includes images from dependent operators:${NC}
    ${ACCENT}•${NC} odf-operator ${MUTED}→${NC} ocs-operator, mcg-operator, rook-ceph-operator, etc.
    ${ACCENT}•${NC} advanced-cluster-management ${MUTED}→${NC} multicluster-engine
    ${ACCENT}•${NC} cluster-logging ${MUTED}→${NC} loki-operator, elasticsearch-operator
    ${MUTED}Use ${BGREEN}--no-deps${NC}${MUTED} to disable this behavior.${NC}

${BWHITE}EXAMPLES${NC}
    ${DIM}# List all operators in a catalog${NC}
    ${ACCENT}\$${NC} $0 list --catalog registry.redhat.io/redhat/redhat-operator-index:v4.22

    ${DIM}# List versions for ODF operator${NC}
    ${ACCENT}\$${NC} $0 versions --catalog registry.redhat.io/redhat/redhat-operator-index:v4.22 \\
        --operator odf-operator

    ${DIM}# Validate images in target registry${NC}
    ${ACCENT}\$${NC} $0 validate --catalog registry.redhat.io/redhat/redhat-operator-index:v4.22 \\
        --operators odf-operator:stable-4.22,cluster-logging:stable \\
        --target-registry mirror.example.com:5000

    ${DIM}# Validate using IDMS file for mirror mappings${NC}
    ${ACCENT}\$${NC} $0 validate --catalog registry.redhat.io/redhat/redhat-operator-index:v4.22 \\
        --operators odf-operator:stable-4.22,ptp-operator \\
        --idms /path/to/imagedigestmirrorset.yaml

    ${DIM}# Validate all mirrors in IDMS file are accessible${NC}
    ${ACCENT}\$${NC} $0 idms-validate --idms /path/to/imagedigestmirrorset.yaml

EOF
}

#######################################
# Log functions
#######################################
log_info() {
    if [[ "${VERBOSE:-false}" == "true" ]]; then
        echo -e "${INFO}▸${NC} $1" >&2
    fi
}

log_success() {
    echo -e "${SUCCESS}[OK]${NC} $1" >&2
}

log_warn() {
    echo -e "${WARNING}⚠${NC} ${YELLOW}$1${NC}" >&2
}

log_error() {
    echo -e "${ERROR}[ERROR]${NC} ${RED}$1${NC}" >&2
}

log_debug() {
    if [[ "${DEBUG:-false}" == "true" ]]; then
        echo -e "${DEBUG}⋯ $1${NC}" >&2
    fi
}

# New: log for processing steps (verbose only)
log_step() {
    if [[ "${VERBOSE:-false}" == "true" ]]; then
        echo -e "${ACCENT}→${NC} $1" >&2
    fi
}

# New: log for section headers
log_header() {
    echo -e "\n${HEADER}━━━ $1 ━━━${NC}" >&2
}

#######################################
# Parse operator:channel format
# Input: "operator:channel" or "operator"
# Output: Sets PARSED_OPERATOR and PARSED_CHANNEL variables
#######################################
parse_operator_channel() {
    local input="$1"
    if [[ "$input" == *:* ]]; then
        PARSED_OPERATOR="${input%%:*}"
        PARSED_CHANNEL="${input#*:}"
    else
        PARSED_OPERATOR="$input"
        PARSED_CHANNEL=""
    fi
}

#######################################
# Get operator names only from operator:channel list
# Input: "op1:ch1,op2,op3:ch3"
# Output: "op1,op2,op3"
#######################################
get_operator_names() {
    local input="$1"
    local result=""
    IFS=',' read -ra items <<< "$input"
    for item in "${items[@]}"; do
        item=$(echo "$item" | xargs)
        parse_operator_channel "$item"
        if [[ -n "$result" ]]; then
            result="$result,$PARSED_OPERATOR"
        else
            result="$PARSED_OPERATOR"
        fi
    done
    echo "$result"
}

#######################################
# Validate operator exists in catalog
# Returns: 0 if exists, 1 if not
#######################################
validate_operator_exists() {
    local operator="$1"
    local configs_dir="$WORK_DIR/index/configs"
    local pkg_dir="$configs_dir/$operator"
    
    # Check single-file FBC
    local single_file=""
    if [[ -f "$configs_dir/index.json" ]]; then
        single_file="$configs_dir/index.json"
    elif [[ -f "$configs_dir/catalog.json" ]]; then
        single_file="$configs_dir/catalog.json"
    fi
    
    if [[ -n "$single_file" ]]; then
        local found
        found=$(jq -r --arg pkg "$operator" 'select(.schema == "olm.package" and .name == $pkg) | .name' "$single_file" 2>/dev/null | head -1)
        [[ -n "$found" ]]
    else
        [[ -d "$pkg_dir" ]]
    fi
}

#######################################
# Validate channel exists for operator
# Returns: 0 if exists, 1 if not
#######################################
validate_channel_exists() {
    local operator="$1"
    local channel="$2"
    local configs_dir="$WORK_DIR/index/configs"
    local pkg_dir="$configs_dir/$operator"
    
    # Check single-file FBC
    local single_file=""
    if [[ -f "$configs_dir/index.json" ]]; then
        single_file="$configs_dir/index.json"
    elif [[ -f "$configs_dir/catalog.json" ]]; then
        single_file="$configs_dir/catalog.json"
    fi
    
    if [[ -n "$single_file" ]]; then
        local found
        found=$(jq -r --arg pkg "$operator" --arg ch "$channel" 'select(.schema == "olm.channel" and .package == $pkg and .name == $ch) | .name' "$single_file" 2>/dev/null | head -1)
        [[ -n "$found" ]]
    else
        # Split FBC format - check multiple possible structures
        local channels_dir="$pkg_dir/channels"
        if [[ -d "$channels_dir" ]]; then
            # Hierarchical FBC: check for channel file
            [[ -f "$channels_dir/${channel}.json" ]]
        elif [[ -f "$pkg_dir/channels.json" ]]; then
            # Flat split FBC with channels.json (NDJSON format)
            local found
            found=$(jq -r --arg ch "$channel" 'select(.schema == "olm.channel" and .name == $ch) | .name' "$pkg_dir/channels.json" 2>/dev/null | head -1)
            [[ -n "$found" ]]
        elif [[ -f "$pkg_dir/catalog.json" ]]; then
            # Flat split FBC with catalog.json
            local found
            found=$(jq -r --arg ch "$channel" 'select(.schema == "olm.channel" and .name == $ch) | .name' "$pkg_dir/catalog.json" 2>/dev/null | head -1)
            [[ -n "$found" ]]
        else
            return 1
        fi
    fi
}

#######################################
# Get available channels for operator
#######################################
get_operator_channels() {
    local operator="$1"
    local configs_dir="$WORK_DIR/index/configs"
    local pkg_dir="$configs_dir/$operator"
    
    # Check single-file FBC
    local single_file=""
    if [[ -f "$configs_dir/index.json" ]]; then
        single_file="$configs_dir/index.json"
    elif [[ -f "$configs_dir/catalog.json" ]]; then
        single_file="$configs_dir/catalog.json"
    fi
    
    if [[ -n "$single_file" ]]; then
        jq -r --arg pkg "$operator" 'select(.schema == "olm.channel" and .package == $pkg) | .name' "$single_file" 2>/dev/null | sort -u | paste -sd ',' -
    else
        # Split FBC format - check multiple possible structures
        local channels_dir="$pkg_dir/channels"
        if [[ -d "$channels_dir" ]]; then
            # Hierarchical FBC: list channel files
            ls "$channels_dir"/*.json 2>/dev/null | xargs -I{} basename {} .json | sort -u | paste -sd ',' -
        elif [[ -f "$pkg_dir/channels.json" ]]; then
            # Flat split FBC with channels.json (NDJSON format)
            jq -r 'select(.schema == "olm.channel") | .name' "$pkg_dir/channels.json" 2>/dev/null | sort -u | paste -sd ',' -
        elif [[ -f "$pkg_dir/catalog.json" ]]; then
            # Flat split FBC with catalog.json
            jq -r 'select(.schema == "olm.channel") | .name' "$pkg_dir/catalog.json" 2>/dev/null | sort -u | paste -sd ',' -
        fi
    fi
}

#######################################
# Check required tools
#######################################
check_requirements() {
    local missing=()
    
    for cmd in oc podman jq skopeo; do
        if ! command -v "$cmd" &> /dev/null; then
            missing+=("$cmd")
        fi
    done
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        log_error "Missing required tools: ${missing[*]}"
        log_info "Please install the missing tools and try again."
        exit 1
    fi
    
    # Check if opm is available (optional but recommended)
    if ! command -v opm &> /dev/null; then
        log_warn "opm not found - some features may be limited"
        log_info "Install opm from: https://github.com/operator-framework/operator-registry"
    fi
}

#######################################
# Setup working directory
#######################################
setup_workdir() {
    WORK_DIR=$(mktemp -d -t prega-validator-XXXXXX)
    log_debug "Working directory: $WORK_DIR"
    
    # Cleanup on exit
    trap cleanup EXIT
}

cleanup() {
    if [[ -n "${WORK_DIR:-}" && -d "$WORK_DIR" ]]; then
        log_debug "Cleaning up working directory: $WORK_DIR"
        rm -rf "$WORK_DIR"
    fi
}

#######################################
# Parse IDMS file and build source->mirror mappings
#######################################
parse_idms_file() {
    local idms_file="$1"
    
    if [[ ! -f "$idms_file" ]]; then
        log_error "IDMS file not found: $idms_file"
        exit 1
    fi
    
    log_info "Parsing IDMS file: $idms_file"
    
    # Parse IDMS YAML and extract source -> mirror mappings
    # Format: source: registry.redhat.io/foo, mirrors: [quay.io/bar, quay.io/baz]
    # Store all mirrors separated by semicolon for fallback support
    local count=0
    
    while IFS='|' read -r source mirrors; do
        [[ -z "$source" || -z "$mirrors" ]] && continue
        
        # Remove any digest from source for matching
        local source_base="${source%@*}"
        
        # Only keep the first mapping for each source (don't overwrite)
        if [[ -z "${IDMS_MAPPINGS[$source_base]:-}" ]]; then
            IDMS_MAPPINGS["$source_base"]="$mirrors"
            ((count++)) || true
            log_debug "IDMS mapping: $source_base -> $mirrors"
        fi
    done < <(yq -r '.spec.imageDigestMirrors[] | (.source + "|" + (.mirrors | join(";")))' "$idms_file" 2>/dev/null)
    
    IDMS_MAPPING_COUNT=$count
    log_info "Loaded $IDMS_MAPPING_COUNT IDMS mappings"
}

#######################################
# Resolve image to mirror using IDMS mappings
# Returns semicolon-separated list of mirror URLs to try
#######################################
resolve_image_mirror() {
    local source_image="$1"
    
    # Extract image without tag/digest for matching
    local image_base="${source_image%@*}"
    image_base="${image_base%:*}"
    local digest=""
    if [[ "$source_image" == *"@"* ]]; then
        digest="${source_image#*@}"
    fi
    
    # Try exact match first
    if [[ -n "${IDMS_MAPPINGS[$image_base]:-}" ]]; then
        local mirrors="${IDMS_MAPPINGS[$image_base]}"
        local result=""
        # Process each mirror (semicolon-separated)
        IFS=';' read -ra mirror_array <<< "$mirrors"
        for mirror_base in "${mirror_array[@]}"; do
            if [[ -n "$digest" ]]; then
                [[ -n "$result" ]] && result+=";"
                result+="${mirror_base}@${digest}"
            else
                [[ -n "$result" ]] && result+=";"
                result+="$mirror_base"
            fi
        done
        echo "$result"
        return 0
    fi
    
    # Try prefix matching (for namespace-level IDMS mappings)
    # This allows mappings like: registry.redhat.io/multicluster-engine -> quay.io/prega/test/multicluster-engine
    # to match images like: registry.redhat.io/multicluster-engine/addon-manager-rhel9@sha256:...
    for source_key in "${!IDMS_MAPPINGS[@]}"; do
        if [[ "$image_base" == "$source_key"* ]]; then
            local mirrors="${IDMS_MAPPINGS[$source_key]}"
            # Calculate the path suffix (part after the source_key)
            local path_suffix="${image_base#$source_key}"
            local result=""
            # Process each mirror (semicolon-separated)
            IFS=';' read -ra mirror_array <<< "$mirrors"
            for mirror_base in "${mirror_array[@]}"; do
                if [[ -n "$digest" ]]; then
                    [[ -n "$result" ]] && result+=";"
                    result+="${mirror_base}${path_suffix}@${digest}"
                else
                    [[ -n "$result" ]] && result+=";"
                    result+="${mirror_base}${path_suffix}"
                fi
            done
            echo "$result"
            return 0
        fi
    done
    
    # No mapping found
    return 1
}

#######################################
# Setup authentication
#######################################
setup_auth() {
    if [[ -n "$AUTH_FILE" && -f "$AUTH_FILE" ]]; then
        export REGISTRY_AUTH_FILE="$AUTH_FILE"
        log_debug "Using auth file: $AUTH_FILE"
    elif [[ -f "$HOME/.docker/config.json" ]]; then
        export REGISTRY_AUTH_FILE="$HOME/.docker/config.json"
        log_debug "Using default docker auth"
    elif [[ -f "${XDG_RUNTIME_DIR:-}/containers/auth.json" ]]; then
        export REGISTRY_AUTH_FILE="${XDG_RUNTIME_DIR}/containers/auth.json"
        log_debug "Using podman auth"
    fi
}

#######################################
# Pull and extract operator index
#######################################
extract_index() {
    local index_image="$1"
    local extract_dir="$WORK_DIR/index"
    
    log_info "Pulling operator index: $index_image"
    
    mkdir -p "$extract_dir"
    
    # Try to extract using oc or podman
    if command -v oc &> /dev/null; then
        # Use oc image extract for OCI images
        oc image extract "$index_image" --path /configs:"$extract_dir/configs" 2>/dev/null || true
        oc image extract "$index_image" --path /database:"$extract_dir/database" 2>/dev/null || true
    fi
    
    # If oc didn't work or didn't extract anything, try podman
    if [[ ! -d "$extract_dir/configs" && ! -f "$extract_dir/database/index.db" ]]; then
        log_debug "Trying podman to extract index..."
        
        local container_id
        container_id=$(podman create "$index_image" 2>/dev/null) || {
            log_error "Failed to pull index image: $index_image"
            exit 1
        }
        
        # Try to copy FBC configs
        podman cp "$container_id:/configs" "$extract_dir/configs" 2>/dev/null || true
        
        # Try to copy SQLite database (legacy)
        podman cp "$container_id:/database" "$extract_dir/database" 2>/dev/null || true
        
        podman rm "$container_id" &>/dev/null || true
    fi
    
    # Detect catalog type
    if [[ -d "$extract_dir/configs" ]]; then
        log_info "Detected File-Based Catalog (FBC)"
        echo "fbc"
    elif [[ -f "$extract_dir/database/index.db" ]]; then
        log_info "Detected SQLite-based catalog"
        echo "sqlite"
    else
        log_error "Could not extract catalog from index image"
        log_error "Index directory contents:"
        ls -la "$extract_dir" >&2
        exit 1
    fi
}

#######################################
# Get combined catalog data for an operator (handles split FBC files)
#######################################
get_catalog_data() {
    local pkg_dir="$1"
    local schema_filter="$2"  # e.g., "olm.package", "olm.channel", "olm.bundle"
    
    # Combine all JSON files from root dir AND subdirectories (channels/, bundles/, etc.)
    # and filter by schema
    find "$pkg_dir" -name "*.json" -exec cat {} + 2>/dev/null | jq -c "select(.schema == \"$schema_filter\")" 2>/dev/null
}

#######################################
# Check if operator exists in index
# Handles both split and single-file FBC formats
#######################################
operator_exists_in_index() {
    local operator="$1"
    local configs_dir="$2"
    
    # Check for single-file FBC
    local single_file=""
    if [[ -f "$configs_dir/index.json" ]]; then
        single_file="$configs_dir/index.json"
    elif [[ -f "$configs_dir/catalog.json" ]]; then
        single_file="$configs_dir/catalog.json"
    fi
    
    if [[ -n "$single_file" ]]; then
        # Single file FBC - check if package exists
        local found
        found=$(jq -r --arg pkg "$operator" 'select(.schema == "olm.package" and .name == $pkg) | .name' "$single_file" 2>/dev/null | head -1)
        [[ -n "$found" && "$found" == "$operator" ]]
        return $?
    else
        # Split FBC - check if directory exists
        [[ -d "$configs_dir/$operator" ]]
        return $?
    fi
}

#######################################
# Resolve operator dependencies
# Returns a list of all operators including dependencies
# Input format: "op1:ch1,op2,op3:ch3"
# Output format: "op1:ch1,op2,op3:ch3,dep1,dep2" (deps use default channels)
#######################################
resolve_dependencies() {
    local operators="$1"
    local configs_dir="$2"
    local resolved=()
    local seen_ops=()  # Track operator names only (without channels)
    
    IFS=',' read -ra operator_list <<< "$operators"
    
    for op_entry in "${operator_list[@]}"; do
        op_entry=$(echo "$op_entry" | xargs)  # trim whitespace
        
        # Parse operator:channel format
        parse_operator_channel "$op_entry"
        local op_name="$PARSED_OPERATOR"
        
        # Skip if already seen
        if [[ " ${seen_ops[*]} " =~ " ${op_name} " ]]; then
            continue
        fi
        seen_ops+=("$op_name")
        resolved+=("$op_entry")  # Keep original format with channel
        
        # Check if this operator has known dependencies
        if [[ -n "${OPERATOR_DEPENDENCIES[$op_name]:-}" ]]; then
            IFS=',' read -ra deps <<< "${OPERATOR_DEPENDENCIES[$op_name]}"
            for dep in "${deps[@]}"; do
                dep=$(echo "$dep" | xargs)
                
                # Only add if the dependency exists in the index
                if operator_exists_in_index "$dep" "$configs_dir"; then
                    if [[ ! " ${seen_ops[*]} " =~ " ${dep} " ]]; then
                        seen_ops+=("$dep")
                        resolved+=("$dep")  # Dependencies use default channel
                        log_info "  Including dependency: $dep (required by $op_name)"
                    fi
                else
                    log_debug "Dependency $dep not found in index (may be optional)"
                fi
            done
        fi
    done
    
    # Return comma-separated list
    printf '%s,' "${resolved[@]}" | sed 's/,$//'
}

#######################################
# List operators from FBC index
# Handles both:
# 1. Split FBC: configs/<operator>/<files>.json
# 2. Single file FBC: configs/index.json or configs/catalog.json
#######################################
list_operators_fbc() {
    local configs_dir="$WORK_DIR/index/configs"
    local filter="${1:-}"
    
    echo -e "\n${BOLD}OPERATOR                                  CHANNELS                              DEFAULT CHANNEL${NC}"
    echo "────────────────────────────────────────────────────────────────────────────────────────────────────"
    
    local count=0
    
    # Check if this is a single-file FBC (index.json or catalog.json at root)
    local single_file=""
    if [[ -f "$configs_dir/index.json" ]]; then
        single_file="$configs_dir/index.json"
    elif [[ -f "$configs_dir/catalog.json" ]]; then
        single_file="$configs_dir/catalog.json"
    fi
    
    if [[ -n "$single_file" ]]; then
        # Single file FBC format - parse packages from the single file
        log_debug "Using single-file FBC format: $single_file"
        
        while read -r pkg_name; do
            [[ -z "$pkg_name" ]] && continue
            
            # Apply filter if specified
            if [[ -n "$filter" ]] && ! echo "$pkg_name" | grep -qE "$filter"; then
                continue
            fi
            
            # Get default channel
            local default_channel
            default_channel=$(jq -r --arg pkg "$pkg_name" 'select(.schema == "olm.package" and .name == $pkg) | .defaultChannel // empty' "$single_file" 2>/dev/null | head -1)
            
            # Get channels for this package
            local channels
            channels=$(jq -r --arg pkg "$pkg_name" 'select(.schema == "olm.channel" and .package == $pkg) | .name // empty' "$single_file" 2>/dev/null | sort -u | tr '\n' ',' | sed 's/,$//')
            
            if [[ -z "$default_channel" ]]; then
                default_channel="-"
            fi
            if [[ -z "$channels" ]]; then
                channels="-"
            fi
            
            # Truncate long channel lists
            if [[ ${#channels} -gt 40 ]]; then
                channels="${channels:0:37}..."
            fi
            
            printf "%-40s %-40s %s\n" "$pkg_name" "$channels" "$default_channel"
            ((count++)) || true
        done < <(jq -r 'select(.schema == "olm.package") | .name // empty' "$single_file" 2>/dev/null | sort -u)
    else
        # Split FBC format - per-operator directories
        for pkg_dir in "$configs_dir"/*/; do
            [[ -d "$pkg_dir" ]] || continue
            
            local pkg_name
            pkg_name=$(basename "$pkg_dir")
            
            # Apply filter if specified
            if [[ -n "$filter" ]] && ! echo "$pkg_name" | grep -qE "$filter"; then
                continue
            fi
            
            # Check if any JSON files exist
            if ! ls "$pkg_dir"/*.json &>/dev/null; then
                continue
            fi
            
            # Parse package info - handles both single catalog.json and split files (package.json, channels.json, etc.)
            local default_channel=""
            local channels=""
            
            # Get default channel from olm.package schema (combines all JSON files)
            default_channel=$(get_catalog_data "$pkg_dir" "olm.package" | jq -r '.defaultChannel // empty' 2>/dev/null | head -1)
            
            # Get all channel names from olm.channel schema
            channels=$(get_catalog_data "$pkg_dir" "olm.channel" | jq -r '.name // empty' 2>/dev/null | sort -u | tr '\n' ',' | sed 's/,$//')
            
            # If we couldn't parse, just show the package name
            if [[ -z "$default_channel" ]]; then
                default_channel="-"
            fi
            if [[ -z "$channels" ]]; then
                channels="-"
            fi
            
            # Truncate long channel lists
            if [[ ${#channels} -gt 40 ]]; then
                channels="${channels:0:37}..."
            fi
            
            printf "%-40s %-40s %s\n" "$pkg_name" "$channels" "$default_channel"
            ((count++)) || true
        done
    fi
    
    echo ""
    echo -e "${BOLD}Total: $count operators${NC}"
}

#######################################
# List operators from SQLite index
#######################################
list_operators_sqlite() {
    local db_file="$WORK_DIR/index/database/index.db"
    local filter="${1:-}"
    
    if ! command -v sqlite3 &> /dev/null; then
        log_error "sqlite3 required for SQLite-based catalogs"
        exit 1
    fi
    
    echo -e "\n${BOLD}OPERATOR                                  CHANNELS                              DEFAULT CHANNEL${NC}"
    echo "────────────────────────────────────────────────────────────────────────────────────────────────────"
    
    local query="SELECT p.name, GROUP_CONCAT(DISTINCT c.name), p.default_channel 
                 FROM package p 
                 LEFT JOIN channel c ON p.name = c.package_name 
                 GROUP BY p.name"
    
    if [[ -n "$filter" ]]; then
        query="SELECT p.name, GROUP_CONCAT(DISTINCT c.name), p.default_channel 
               FROM package p 
               LEFT JOIN channel c ON p.name = c.package_name 
               WHERE p.name LIKE '%$filter%'
               GROUP BY p.name"
    fi
    
    local count=0
    while IFS='|' read -r pkg_name channels default_channel; do
        [[ -n "$pkg_name" ]] || continue
        
        # Truncate long channel lists
        if [[ ${#channels} -gt 40 ]]; then
            channels="${channels:0:37}..."
        fi
        
        printf "%-40s %-40s %s\n" "$pkg_name" "${channels:-'-'}" "${default_channel:-'-'}"
        ((count++))
    done < <(sqlite3 "$db_file" "$query" 2>/dev/null)
    
    echo ""
    echo -e "${BOLD}Total: $count operators${NC}"
}

#######################################
# List versions for an operator (FBC)
# Handles both split and single-file FBC formats
#######################################
list_versions_fbc() {
    local operator="$1"
    local channel="${2:-}"
    local configs_dir="$WORK_DIR/index/configs"
    local pkg_dir="$configs_dir/$operator"
    
    # Check if this is a single-file FBC
    local single_file=""
    if [[ -f "$configs_dir/index.json" ]]; then
        single_file="$configs_dir/index.json"
    elif [[ -f "$configs_dir/catalog.json" ]]; then
        single_file="$configs_dir/catalog.json"
    fi
    
    if [[ -n "$single_file" ]]; then
        # Single file FBC format
        log_debug "Using single-file FBC format: $single_file"
        
        # Check if operator exists
        local pkg_exists
        pkg_exists=$(jq -r --arg pkg "$operator" 'select(.schema == "olm.package" and .name == $pkg) | .name' "$single_file" 2>/dev/null | head -1)
        
        if [[ -z "$pkg_exists" ]]; then
            log_error "Operator not found: $operator"
            log_error "Available operators:"
            jq -r 'select(.schema == "olm.package") | .name' "$single_file" 2>/dev/null | head -20 >&2
            exit 1
        fi
        
        echo -e "\n${BOLD}OPERATOR: $operator${NC}"
        
        # Get default channel
        local default_channel
        default_channel=$(jq -r --arg pkg "$operator" 'select(.schema == "olm.package" and .name == $pkg) | .defaultChannel // empty' "$single_file" 2>/dev/null | head -1)
        
        if [[ -n "$default_channel" ]]; then
            echo -e "Default Channel: ${CYAN}$default_channel${NC}"
        fi
        
        echo ""
        
        # Get channels for this package
        local channels_json
        channels_json=$(jq -c --arg pkg "$operator" 'select(.schema == "olm.channel" and .package == $pkg)' "$single_file" 2>/dev/null)
    else
        # Split FBC format
        if [[ ! -d "$pkg_dir" ]]; then
            log_error "Operator not found: $operator"
            log_error "Available operators in: $configs_dir"
            ls "$configs_dir" 2>/dev/null | head -20 >&2
            exit 1
        fi
        
        # Check if any JSON files exist
        if ! ls "$pkg_dir"/*.json &>/dev/null; then
            log_error "No catalog files found for operator: $operator"
            log_error "Contents of $pkg_dir:"
            ls -la "$pkg_dir" >&2
            exit 1
        fi
        
        log_debug "Using catalog directory: $pkg_dir"
        log_debug "Files: $(ls "$pkg_dir"/*.json 2>/dev/null | xargs -n1 basename | tr '\n' ' ')"
        
        echo -e "\n${BOLD}OPERATOR: $operator${NC}"
        
        # Get default channel from olm.package schema (may be in package.json or catalog.json)
        local default_channel
        default_channel=$(get_catalog_data "$pkg_dir" "olm.package" | jq -r '.defaultChannel // empty' 2>/dev/null | head -1)
        
        if [[ -n "$default_channel" ]]; then
            echo -e "Default Channel: ${CYAN}$default_channel${NC}"
        fi
        
        echo ""
        
        # Get all channels (may be in channels.json or catalog.json)
        local channels_json
        channels_json=$(get_catalog_data "$pkg_dir" "olm.channel")
    fi
    
    if [[ -z "$channels_json" ]]; then
        log_warn "No channels found in catalog"
        return
    fi
    
    # List channels and their bundles
    if [[ -n "$channel" ]]; then
        echo -e "${BOLD}Channel: $channel${NC}"
        echo "Versions:"
        
        # Get entries for specific channel
        local entries
        entries=$(echo "$channels_json" | jq -r "select(.name == \"$channel\") | .entries[]?.name" 2>/dev/null | sort -V -r)
        
        local head_version
        head_version=$(echo "$entries" | head -1)
        
        echo "$entries" | while read -r version; do
            [[ -n "$version" ]] || continue
            if [[ "$version" == "$head_version" ]]; then
                echo -e "  • $version ${GREEN}(head)${NC}"
            else
                echo "  • $version"
            fi
        done
    else
        # List all channels
        local channel_names
        channel_names=$(echo "$channels_json" | jq -r '.name' 2>/dev/null | sort -u)
        
        echo "$channel_names" | while read -r ch; do
            [[ -n "$ch" ]] || continue
            
            if [[ "$ch" == "$default_channel" ]]; then
                echo -e "${BOLD}Channel: $ch (default)${NC}"
            else
                echo -e "${BOLD}Channel: $ch${NC}"
            fi
            
            echo "Versions:"
            
            # Get entries for this channel
            local entries
            entries=$(echo "$channels_json" | jq -r "select(.name == \"$ch\") | .entries[]?.name" 2>/dev/null | sort -V -r)
            
            local head_version
            head_version=$(echo "$entries" | head -1)
            local count=0
            
            echo "$entries" | while read -r version; do
                [[ -n "$version" ]] || continue
                ((count++)) || true
                if [[ $count -gt 10 ]]; then
                    echo "  ... (more versions available)"
                    break
                fi
                if [[ "$version" == "$head_version" ]]; then
                    echo -e "  • $version ${GREEN}(head)${NC}"
                else
                    echo "  • $version"
                fi
            done
            echo ""
        done
    fi
}

#######################################
# Get channel for an operator
# Returns the channel being used (specified or default)
#######################################
get_operator_channel_fbc() {
    local operator="$1"
    local channel="${2:-}"
    local configs_dir="$WORK_DIR/index/configs"
    local pkg_dir="$configs_dir/$operator"
    
    # If channel is specified, return it
    if [[ -n "$channel" ]]; then
        echo "$channel"
        return 0
    fi
    
    # Check if this is a single-file FBC
    local single_file=""
    if [[ -f "$configs_dir/index.json" ]]; then
        single_file="$configs_dir/index.json"
    elif [[ -f "$configs_dir/catalog.json" ]]; then
        single_file="$configs_dir/catalog.json"
    fi
    
    if [[ -n "$single_file" ]]; then
        # Single file FBC format - get default channel
        channel=$(jq -r --arg pkg "$operator" 'select(.schema == "olm.package" and .name == $pkg) | .defaultChannel // empty' "$single_file" 2>/dev/null | head -1)
    else
        # Split FBC format - get default channel
        if [[ -d "$pkg_dir" ]]; then
            channel=$(get_catalog_data "$pkg_dir" "olm.package" | jq -r '.defaultChannel // empty' 2>/dev/null | head -1)
        fi
    fi
    
    echo "${channel:-unknown}"
}

#######################################
# Get bundle image for operator version
# Handles both split and single-file FBC formats
#######################################
get_bundle_image_fbc() {
    local operator="$1"
    local version="${2:-}"
    local channel="${3:-}"
    local configs_dir="$WORK_DIR/index/configs"
    local pkg_dir="$configs_dir/$operator"
    
    # Check if this is a single-file FBC
    local single_file=""
    if [[ -f "$configs_dir/index.json" ]]; then
        single_file="$configs_dir/index.json"
    elif [[ -f "$configs_dir/catalog.json" ]]; then
        single_file="$configs_dir/catalog.json"
    fi
    
    if [[ -n "$single_file" ]]; then
        # Single file FBC format
        log_debug "Using single-file FBC for bundle lookup: $single_file"
        
        # If no version specified, get head of default/specified channel
        if [[ -z "$version" ]]; then
            if [[ -z "$channel" ]]; then
                channel=$(jq -r --arg pkg "$operator" 'select(.schema == "olm.package" and .name == $pkg) | .defaultChannel // empty' "$single_file" 2>/dev/null | head -1)
            fi
            
            if [[ -n "$channel" ]]; then
                # Get the last entry (head) of the channel - in OLM, the head is the last entry
                version=$(jq -r --arg pkg "$operator" --arg ch "$channel" 'select(.schema == "olm.channel" and .package == $pkg and .name == $ch) | .entries[-1]?.name // empty' "$single_file" 2>/dev/null | head -1)
            fi
        fi
        
        if [[ -z "$version" ]]; then
            log_debug "Could not determine version for operator: $operator"
            return 1
        fi
        
        log_debug "Looking for bundle: $version"
        
        # Get bundle image for version
        local bundle_image
        bundle_image=$(jq -r --arg ver "$version" 'select(.schema == "olm.bundle" and .name == $ver) | .image // empty' "$single_file" 2>/dev/null | head -1)
        
        if [[ -n "$bundle_image" ]]; then
            echo "$bundle_image"
        else
            log_debug "Bundle image not found for version: $version"
            return 1
        fi
    else
        # Split FBC format
        # Check if directory exists
        if [[ ! -d "$pkg_dir" ]]; then
            log_debug "Operator directory not found: $pkg_dir"
            return 1
        fi
        
        # Check if any JSON files exist
        if ! ls "$pkg_dir"/*.json &>/dev/null; then
            log_debug "No catalog files found for operator: $operator"
            return 1
        fi
        
        # If no version specified, get head of default/specified channel
        if [[ -z "$version" ]]; then
            if [[ -z "$channel" ]]; then
                channel=$(get_catalog_data "$pkg_dir" "olm.package" | jq -r '.defaultChannel // empty' 2>/dev/null | head -1)
            fi
            
            if [[ -n "$channel" ]]; then
                # Get the last entry (head) of the channel - in OLM, the head is the last entry
                version=$(get_catalog_data "$pkg_dir" "olm.channel" | jq -r "select(.name == \"$channel\") | .entries[-1]?.name // empty" 2>/dev/null | head -1)
            fi
        fi
        
        if [[ -z "$version" ]]; then
            log_debug "Could not determine version for operator: $operator"
            return 1
        fi
        
        log_debug "Looking for bundle: $version"
        
        # Get bundle image for version (may be in bundles.json or catalog.json)
        local bundle_image
        bundle_image=$(get_catalog_data "$pkg_dir" "olm.bundle" | jq -r "select(.name == \"$version\") | .image // empty" 2>/dev/null | head -1)
        
        if [[ -n "$bundle_image" ]]; then
            echo "$bundle_image"
        else
            log_debug "Bundle image not found for version: $version"
            return 1
        fi
    fi
}

#######################################
# Extract images from a bundle
#######################################
extract_images_from_bundle() {
    local bundle_image="$1"
    local bundle_dir="$WORK_DIR/bundle_$(echo "$bundle_image" | md5sum | cut -c1-8)"
    
    mkdir -p "$bundle_dir"
    
    log_debug "Extracting bundle: $bundle_image"
    
    # Extract bundle using podman (more reliable)
    local container_id
    container_id=$(podman create "$bundle_image" 2>/dev/null) || {
        log_warn "Could not create container for bundle: $bundle_image"
        return 1
    }
    
    # Copy manifests - podman cp copies the directory itself, so we copy to bundle_dir
    podman cp "$container_id:/manifests" "$bundle_dir/" 2>/dev/null || true
    podman rm "$container_id" &>/dev/null || true
    
    # Find the manifests directory (might be nested)
    local manifests_dir=""
    if [[ -d "$bundle_dir/manifests" ]]; then
        manifests_dir="$bundle_dir/manifests"
    fi
    
    if [[ -z "$manifests_dir" || ! -d "$manifests_dir" ]]; then
        log_warn "Could not extract bundle manifests: $bundle_image"
        log_debug "Bundle dir contents: $(ls -la "$bundle_dir" 2>&1)"
        return 1
    fi
    
    log_debug "Manifests dir: $manifests_dir"
    log_debug "Manifests contents: $(ls "$manifests_dir" 2>&1)"
    
    # Find CSV file (search recursively)
    local csv_file
    csv_file=$(find "$manifests_dir" -name "*.clusterserviceversion.yaml" -o -name "*.clusterserviceversion.yml" 2>/dev/null | head -1)
    
    if [[ -z "$csv_file" || ! -f "$csv_file" ]]; then
        log_warn "No CSV found in bundle: $bundle_image"
        log_debug "Searched in: $manifests_dir"
        return 1
    fi
    
    log_debug "Found CSV: $csv_file"
    
    # Extract images from CSV
    local images=()
    
    # 1. Extract from relatedImages (primary source)
    while IFS= read -r img; do
        [[ -n "$img" && "$img" != "null" ]] && images+=("$img")
    done < <(yq -r '.spec.relatedImages[].image' "$csv_file" 2>/dev/null)
    
    log_debug "Found ${#images[@]} images from relatedImages"
    
    # 2. Extract from deployments containers
    while IFS= read -r img; do
        [[ -n "$img" && "$img" != "null" ]] && images+=("$img")
    done < <(yq -r '.spec.install.spec.deployments[].spec.template.spec.containers[].image' "$csv_file" 2>/dev/null)
    
    # 3. Extract from init containers
    while IFS= read -r img; do
        [[ -n "$img" && "$img" != "null" ]] && images+=("$img")
    done < <(yq -r '.spec.install.spec.deployments[].spec.template.spec.initContainers[].image' "$csv_file" 2>/dev/null)
    
    # 4. Extract from environment variables that look like images
    while IFS= read -r img; do
        if [[ -n "$img" && "$img" != "null" && "$img" =~ ^[a-zA-Z0-9].*/.+[@:].* ]]; then
            images+=("$img")
        fi
    done < <(yq -r '.spec.install.spec.deployments[].spec.template.spec.containers[].env[].value' "$csv_file" 2>/dev/null)
    
    # Output unique images
    if [[ ${#images[@]} -gt 0 ]]; then
        printf '%s\n' "${images[@]}" | sort -u
    fi
}

#######################################
# Validate image exists in registry
#######################################
normalize_image_ref() {
    local img="$1"
    # If image has both tag and digest (tag@sha256:...), strip the tag
    # skopeo doesn't support references with both tag and digest
    if [[ "$img" =~ ^(.+):([^@]+)@(sha256:.+)$ ]]; then
        # Image has tag@digest format, use only digest
        echo "${BASH_REMATCH[1]}@${BASH_REMATCH[3]}"
    else
        echo "$img"
    fi
}

check_image_exists() {
    local source_image="$1"
    local target_registry="$2"
    local validation_mode="${3:-source}"
    local target_images=""
    
    case "$validation_mode" in
        source)
            # GA mode: validate directly at source registry
            target_images="$source_image"
            ;;
        idms)
            # IDMS mode: try to resolve using IDMS mappings
            # Returns semicolon-separated list of mirrors to try
            # Use ${var+x} syntax for set -u compatibility
            if [[ $IDMS_MAPPING_COUNT -gt 0 ]]; then
                target_images=$(resolve_image_mirror "$source_image" 2>/dev/null) || true
            fi
            if [[ -z "$target_images" ]]; then
                # No IDMS mapping found - this will fail in disconnected environments
                echo "no-mapping|$source_image|IDMS_MAPPING_REQUIRED"
                return
            fi
            ;;
        mirror)
            # Mirror mode: transform to target registry path
            local image_path
            image_path=$(echo "$source_image" | sed 's|^[^/]*/||')
            target_images="$target_registry/$image_path"
            ;;
    esac
    
    # Try each mirror in the list (semicolon-separated for IDMS fallback support)
    local mirrors_to_try
    IFS=';' read -ra mirrors_to_try <<< "$target_images"
    for target_image in "${mirrors_to_try[@]}"; do
        # Normalize image reference (strip tag if both tag and digest present)
        local check_image
        check_image=$(normalize_image_ref "$target_image")
        
        log_debug "Checking: $check_image"
        
        # Use skopeo to check if image exists
        if skopeo inspect --raw "docker://$check_image" &>/dev/null; then
            echo "available|$source_image|$target_image"
            return
        fi
    done
    
    # None of the mirrors worked - report first mirror as missing
    echo "missing|$source_image|${mirrors_to_try[0]}"
}

#######################################
# Validate images command
#######################################
cmd_validate() {
    if [[ -z "$INDEX_IMAGE" ]]; then
        log_error "--catalog is required"
        exit 1
    fi
    
    if [[ -z "$OPERATORS" ]]; then
        log_error "--operators is required"
        exit 1
    fi
    
    # For GA releases, neither --target-registry nor --idms is required
    # Images will be validated directly at their source registry
    local validation_mode="source"
    if [[ -n "$IDMS_FILE" ]]; then
        validation_mode="idms"
    elif [[ -n "$TARGET_REGISTRY" ]]; then
        validation_mode="mirror"
    fi
    
    setup_workdir
    setup_auth
    
    # Parse IDMS file if provided
    if [[ -n "$IDMS_FILE" ]]; then
        parse_idms_file "$IDMS_FILE"
    fi
    
    local catalog_type
    catalog_type=$(extract_index "$INDEX_IMAGE")
    
    local configs_dir="$WORK_DIR/index/configs"
    
    # Resolve dependencies if enabled
    local resolved_operators="$OPERATORS"
    if [[ "$INCLUDE_DEPS" == "true" ]]; then
        log_info "Resolving operator dependencies..."
        resolved_operators=$(resolve_dependencies "$OPERATORS" "$configs_dir")
        log_info "Will process operators: $resolved_operators"
    fi
    
    # Collect images per operator
    declare -A operator_images
    declare -A operator_versions
    local all_images=()
    
    IFS=',' read -ra operator_list <<< "$resolved_operators"
    for op_entry in "${operator_list[@]}"; do
        op_entry=$(echo "$op_entry" | xargs)
        
        # Parse operator:channel format
        parse_operator_channel "$op_entry"
        local operator="$PARSED_OPERATOR"
        local op_channel="$PARSED_CHANNEL"
        
        log_info "Processing operator: $operator"
        
        # Validate operator exists
        if ! validate_operator_exists "$operator"; then
            log_error "Operator '$operator' not found in catalog"
            log_error "Use 'list' command to see available operators"
            exit 1
        fi
        
        # Get the channel (use specified, or fall back to default)
        if [[ -z "$op_channel" ]]; then
            op_channel=$(get_operator_channel_fbc "$operator" "$CHANNEL" 2>/dev/null) || true
        fi
        
        # Validate channel exists
        if [[ -n "$op_channel" ]] && ! validate_channel_exists "$operator" "$op_channel"; then
            local available_channels
            available_channels=$(get_operator_channels "$operator")
            log_error "Channel '$op_channel' not found for operator '$operator'"
            log_error "Available channels: $available_channels"
            exit 1
        fi
        
        OPERATOR_CHANNELS[$operator]="$op_channel"
        
        local bundle_image
        bundle_image=$(get_bundle_image_fbc "$operator" "$VERSION" "$op_channel" 2>/dev/null) || true
        
        if [[ -z "$bundle_image" ]]; then
            log_error "Could not find bundle for operator: $operator (channel: $op_channel)"
            exit 1
        fi
        
        # Extract version from bundle name
        local version_name
        version_name=$(echo "$bundle_image" | grep -oE '[^/]+$' | sed 's/:/-/g') || true
        operator_versions[$operator]="$version_name"
        
        log_info "  Bundle: $bundle_image (channel: $op_channel)"
        
        local images
        images=$(extract_images_from_bundle "$bundle_image" 2>/dev/null) || true
        
        if [[ -n "$images" ]]; then
            operator_images[$operator]="$images"
            while IFS= read -r img; do
                all_images+=("$img")
            done <<< "$images"
        fi
    done
    
    # Deduplicate
    local unique_images
    unique_images=$(printf '%s\n' "${all_images[@]}" | sort -u)
    local total_count
    total_count=$(echo "$unique_images" | grep -c . || echo 0)
    
    # Display validation mode
    case "$validation_mode" in
        source)
            log_info "Validating $total_count unique images at source registry (GA mode)"
            ;;
        idms)
            log_info "Validating $total_count unique images using IDMS mappings"
            ;;
        mirror)
            log_info "Validating $total_count unique images against $TARGET_REGISTRY"
            ;;
    esac
    echo ""
    
    # Validate images
    local available=0
    local missing=0
    local missing_images=()
    local results_file="$WORK_DIR/results.txt"
    
    # Validate each image
    # Use a for loop instead of pipe to avoid subshell issues with set -e
    touch "$results_file"
    while IFS= read -r img; do
        [[ -n "$img" ]] || continue
        check_image_exists "$img" "$TARGET_REGISTRY" "$validation_mode" >> "$results_file" || true
    done <<< "$unique_images"
    
    # Count results (ensure numeric values)
    available=$(grep -c "^available|" "$results_file" 2>/dev/null || echo "0")
    missing=$(grep -c "^missing|" "$results_file" 2>/dev/null || echo "0")
    local no_mapping
    no_mapping=$(grep -c "^no-mapping|" "$results_file" 2>/dev/null || echo "0")
    
    # Ensure variables are numeric
    available=${available//[^0-9]/}
    missing=${missing//[^0-9]/}
    no_mapping=${no_mapping//[^0-9]/}
    [[ -z "$available" ]] && available=0
    [[ -z "$missing" ]] && missing=0
    [[ -z "$no_mapping" ]] && no_mapping=0
    
    # Add no-mapping to missing count (they will fail in disconnected environments)
    missing=$((missing + no_mapping))
    
    # Collect missing images (including no-mapping)
    local no_mapping_images=()
    while IFS='|' read -r status source target; do
        if [[ "$status" == "missing" ]]; then
            missing_images+=("$source")
        elif [[ "$status" == "no-mapping" ]]; then
            no_mapping_images+=("$source (NO IDMS MAPPING)")
            missing_images+=("$source")
        fi
    done < "$results_file"
    
    # Generate report
    case "$OUTPUT_FORMAT" in
        table)
            print_validation_report "$available" "$missing" "${missing_images[@]}"
            ;;
        json)
            print_validation_json "$available" "$missing" "${missing_images[@]}"
            ;;
        yaml)
            print_validation_yaml "$available" "$missing" "${missing_images[@]}"
            ;;
        remediation)
            print_remediation_script "${missing_images[@]}"
            ;;
    esac
    
    # Exit with appropriate code
    if [[ $missing -gt 0 ]]; then
        exit 1
    fi
}

#######################################
# Print validation report (table)
#######################################
print_validation_report() {
    local available=${1:-0}
    local missing=${2:-0}
    shift 2
    local missing_images=("$@")
    
    # Ensure numeric
    available=${available//[^0-9]/}
    missing=${missing//[^0-9]/}
    [[ -z "$available" ]] && available=0
    [[ -z "$missing" ]] && missing=0
    
    local total=$((available + missing))
    local available_pct=0
    local missing_pct=0
    
    if [[ $total -gt 0 ]]; then
        available_pct=$(awk "BEGIN {printf \"%.1f\", $available * 100 / $total}")
        missing_pct=$(awk "BEGIN {printf \"%.1f\", $missing * 100 / $total}")
    fi
    
    # Determine overall status
    local status_color="${SUCCESS}"
    local status_text="PASSED"
    if [[ $missing -gt 0 ]]; then
        if [[ $(awk "BEGIN {print ($missing_pct > 50) ? 1 : 0}") -eq 1 ]]; then
            status_color="${ERROR}"
        else
            status_color="${WARNING}"
        fi
        status_text="FAILED"
    fi
    
    # Print colorful report without table borders
    echo ""
    echo -e "${HEADER}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "  ${BOLD}${BWHITE}📋 Operator Image Validation Report${NC}"
    echo -e "${HEADER}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    
    # Index info
    echo -e "  ${ACCENT}📦 Catalog:${NC}   ${INDEX_IMAGE}"
    
    # Validation mode info
    if [[ -n "$IDMS_FILE" ]]; then
        echo -e "  ${ACCENT}🔄 Mode:${NC}      IDMS Mirror Mapping"
        echo -e "  ${ACCENT}📄 IDMS:${NC}      $(basename "$IDMS_FILE") ($IDMS_MAPPING_COUNT mappings)"
    elif [[ -n "$TARGET_REGISTRY" ]]; then
        echo -e "  ${ACCENT}🔄 Mode:${NC}      Target Registry Mirror"
        echo -e "  ${ACCENT}🎯 Target:${NC}    ${TARGET_REGISTRY}"
    else
        echo -e "  ${ACCENT}🔄 Mode:${NC}      ${SUCCESS}Source Registry (GA Release)${NC}"
    fi
    
    # Operators with channel info
    if [[ -n "$OPERATORS" ]]; then
        local first_op=true
        IFS=',' read -ra op_array <<< "$OPERATORS"
        for op_entry in "${op_array[@]}"; do
            op_entry=$(echo "$op_entry" | xargs)
            # Parse operator:channel format to get operator name
            parse_operator_channel "$op_entry"
            local op_name="$PARSED_OPERATOR"
            local ch="${OPERATOR_CHANNELS[$op_name]:-unknown}"
            if [[ "$first_op" == "true" ]]; then
                echo -e "  ${ACCENT}🔧 Operators:${NC} ${op_name}(${ch})"
                first_op=false
            else
                # 16 spaces to align with first operator (2 + emoji + space + "Operators:" + space)
                echo -e "                ${op_name}(${ch})"
            fi
        done
    fi
    
    # Date
    echo -e "  ${ACCENT}📅 Date:${NC}      $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
    
    echo ""
    echo -e "${HEADER}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    
    # Status with emoji
    local status_emoji="✅"
    if [[ $missing -gt 0 ]]; then
        status_emoji="❌"
    fi
    
    echo -e "  ${BOLD}${status_color}${status_emoji} Status: ${status_text}${NC}"
    echo ""
    echo -e "  ${BOLD}📊 Summary:${NC}"
    echo -e "     Total Images:     ${BOLD}${total}${NC}"
    echo -e "     ${SUCCESS}✓ Available:${NC}      ${BOLD}${available}${NC} (${available_pct}%)"
    echo -e "     ${ERROR}✗ Missing:${NC}        ${BOLD}${missing}${NC} (${missing_pct}%)"
    echo ""
    
    # Progress bar
    local bar_width=60
    local filled=$((available * bar_width / (total > 0 ? total : 1)))
    local empty_bar=$((bar_width - filled))
    local bar_filled=$(printf '%*s' "$filled" '' | tr ' ' '█')
    local bar_empty=$(printf '%*s' "$empty_bar" '' | tr ' ' '░')
    echo -e "  ${SUCCESS}${bar_filled}${NC}${DIM}${bar_empty}${NC} ${available_pct}%"
    
    echo ""
    echo -e "${HEADER}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    if [[ ${#missing_images[@]} -gt 0 ]]; then
        echo ""
        echo -e "  ${ERROR}${BOLD}❌ Missing Images (${missing}):${NC}"
        echo ""
        for img in "${missing_images[@]}"; do
            [[ -n "$img" ]] || continue
            echo -e "     ${RED}•${NC} ${img}"
        done
        echo ""
        echo -e "${HEADER}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo ""
        echo -e "  ${WARNING}💡 Tip:${NC} Run with ${ACCENT}--output-format=remediation${NC} to generate mirror commands."
    else
        echo ""
        echo -e "  ${SUCCESS}${BOLD}✅ All images are available!${NC}"
        echo ""
        echo -e "${HEADER}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    fi
    echo ""
}

#######################################
# Print validation JSON
#######################################
print_validation_json() {
    local available=${1:-0}
    local missing=${2:-0}
    shift 2
    local missing_images=("$@")
    
    available=${available//[^0-9]/}
    missing=${missing//[^0-9]/}
    [[ -z "$available" ]] && available=0
    [[ -z "$missing" ]] && missing=0
    
    local total=$((available + missing))
    
    cat << EOF
{
  "catalog": "$INDEX_IMAGE",
  "targetRegistry": "$TARGET_REGISTRY",
  "timestamp": "$(date -u '+%Y-%m-%dT%H:%M:%SZ')",
  "summary": {
    "total": $total,
    "available": $available,
    "missing": $missing
  },
  "missingImages": $(printf '%s\n' "${missing_images[@]}" | jq -R -s 'split("\n") | map(select(length > 0))')
}
EOF
}

#######################################
# Print validation YAML
#######################################
print_validation_yaml() {
    local available=$1
    local missing=$2
    shift 2
    local missing_images=("$@")
    
    local total=$((available + missing))
    
    cat << EOF
catalog: $INDEX_IMAGE
targetRegistry: $TARGET_REGISTRY
timestamp: $(date -u '+%Y-%m-%dT%H:%M:%SZ')
summary:
  total: $total
  available: $available
  missing: $missing
missingImages:
EOF
    for img in "${missing_images[@]}"; do
        [[ -n "$img" ]] && echo "  - $img"
    done
}

#######################################
# Print remediation script
#######################################
print_remediation_script() {
    local missing_images=("$@")
    
    cat << EOF
#!/bin/bash
# Auto-generated remediation script
# Generated: $(date -u '+%Y-%m-%d %H:%M:%S UTC')
# Catalog: $INDEX_IMAGE
# Target: $TARGET_REGISTRY

set -e

EOF
    
    for img in "${missing_images[@]}"; do
        [[ -n "$img" ]] || continue
        local image_path
        image_path=$(echo "$img" | sed 's|^[^/]*/||')
        local target_image="$TARGET_REGISTRY/$image_path"
        
        cat << EOF
echo "Mirroring: $img"
skopeo copy --all \\
  docker://$img \\
  docker://$target_image

EOF
    done
    
    echo 'echo "Done!"'
}

#######################################
# Command: idms validate - validate all mirrors in IDMS file
#######################################
cmd_idms_validate() {
    if [[ -z "$IDMS_FILE" ]]; then
        log_error "--idms is required"
        exit 1
    fi
    
    setup_auth
    parse_idms_file "$IDMS_FILE"
    
    if [[ $IDMS_MAPPING_COUNT -eq 0 ]]; then
        log_error "No mappings found in IDMS file"
        exit 1
    fi
    
    log_info "Validating $IDMS_MAPPING_COUNT IDMS mirror mappings..."
    echo ""
    
    local available=0
    local missing=0
    local missing_images=()
    local results_file
    results_file=$(mktemp)
    
    # Validate each mirror
    for source in "${!IDMS_MAPPINGS[@]}"; do
        local mirror="${IDMS_MAPPINGS[$source]}"
        
        log_debug "Checking mirror: $mirror"
        
        # Use skopeo to check if mirror exists (just check the repo, not specific digest)
        if skopeo inspect --raw "docker://$mirror" &>/dev/null; then
            echo "available|$source|$mirror" >> "$results_file"
            ((available++)) || true
        else
            echo "missing|$source|$mirror" >> "$results_file"
            missing_images+=("$source -> $mirror")
            ((missing++)) || true
        fi
    done
    
    # Generate report
    local total=$((available + missing))
    local available_pct=0
    local missing_pct=0
    
    if [[ $total -gt 0 ]]; then
        available_pct=$(awk "BEGIN {printf \"%.1f\", $available * 100 / $total}")
        missing_pct=$(awk "BEGIN {printf \"%.1f\", $missing * 100 / $total}")
    fi
    
    # Determine overall status
    local status_color="${SUCCESS}"
    local status_text="PASSED"
    if [[ $missing -gt 0 ]]; then
        if [[ $(awk "BEGIN {print ($missing_pct > 50) ? 1 : 0}") -eq 1 ]]; then
            status_color="${ERROR}"
        else
            status_color="${WARNING}"
        fi
        status_text="FAILED"
    fi
    
    # Print colorful report without table borders
    echo ""
    echo -e "${HEADER}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "  ${BOLD}${BWHITE}🔍 IDMS Mirror Validation Report${NC}"
    echo -e "${HEADER}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    
    echo -e "  ${ACCENT}📄 IDMS:${NC}      $(basename "$IDMS_FILE")"
    echo -e "  ${ACCENT}🔢 Total:${NC}     $IDMS_MAPPING_COUNT mappings"
    echo -e "  ${ACCENT}📅 Date:${NC}      $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
    
    echo ""
    echo -e "${HEADER}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    
    # Status with emoji
    local status_emoji="✅"
    if [[ $missing -gt 0 ]]; then
        status_emoji="❌"
    fi
    
    echo -e "  ${BOLD}${status_color}${status_emoji} Status: ${status_text}${NC}"
    echo ""
    echo -e "  ${BOLD}📊 Summary:${NC}"
    echo -e "     Total Mirrors:    ${BOLD}${total}${NC}"
    echo -e "     ${SUCCESS}✓ Available:${NC}      ${BOLD}${available}${NC} (${available_pct}%)"
    echo -e "     ${ERROR}✗ Missing:${NC}        ${BOLD}${missing}${NC} (${missing_pct}%)"
    echo ""
    
    # Progress bar
    local bar_width=60
    local filled=$((available * bar_width / (total > 0 ? total : 1)))
    local empty_bar=$((bar_width - filled))
    local bar_filled=$(printf '%*s' "$filled" '' | tr ' ' '█')
    local bar_empty=$(printf '%*s' "$empty_bar" '' | tr ' ' '░')
    echo -e "  ${SUCCESS}${bar_filled}${NC}${DIM}${bar_empty}${NC} ${available_pct}%"
    
    echo ""
    echo -e "${HEADER}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    if [[ ${#missing_images[@]} -gt 0 ]]; then
        echo ""
        echo -e "  ${ERROR}${BOLD}❌ Missing Mirrors (${missing}):${NC}"
        echo ""
        for mapping in "${missing_images[@]}"; do
            echo -e "     ${RED}•${NC} ${mapping}"
        done
        echo ""
        echo -e "${HEADER}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    else
        echo ""
        echo -e "  ${SUCCESS}${BOLD}✅ All mirrors are accessible!${NC}"
        echo ""
        echo -e "${HEADER}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    fi
    echo ""
    
    rm -f "$results_file"
    
    # Exit with appropriate code
    if [[ $missing -gt 0 ]]; then
        exit 1
    fi
}

#######################################
# Command: index list
#######################################
cmd_index_list() {
    if [[ -z "$INDEX_IMAGE" ]]; then
        log_error "--catalog is required"
        exit 1
    fi
    
    setup_workdir
    setup_auth
    
    local catalog_type
    catalog_type=$(extract_index "$INDEX_IMAGE")
    
    local filter="${FILTER:-}"
    
    case "$catalog_type" in
        fbc)
            list_operators_fbc "$filter"
            ;;
        sqlite)
            list_operators_sqlite "$filter"
            ;;
    esac
}

#######################################
# Command: index versions
#######################################
cmd_index_versions() {
    if [[ -z "$INDEX_IMAGE" ]]; then
        log_error "--catalog is required"
        exit 1
    fi
    
    if [[ -z "$OPERATOR" ]]; then
        log_error "--operator is required"
        exit 1
    fi
    
    setup_workdir
    setup_auth
    
    local catalog_type
    catalog_type=$(extract_index "$INDEX_IMAGE")
    
    case "$catalog_type" in
        fbc)
            list_versions_fbc "$OPERATOR" "$CHANNEL"
            ;;
        sqlite)
            log_error "SQLite version listing not yet implemented"
            exit 1
            ;;
    esac
}

#######################################
# Parse arguments
#######################################
parse_args() {
    local command=""
    
    while [[ $# -gt 0 ]]; do
        case "$1" in
            list|versions|validate|idms-validate)
                command="$1"
                shift
                ;;
            --catalog)
                INDEX_IMAGE="$2"
                shift 2
                ;;
            --target-registry)
                TARGET_REGISTRY="$2"
                shift 2
                ;;
            --operators)
                OPERATORS="$2"
                shift 2
                ;;
            --operator)
                OPERATOR="$2"
                shift 2
                ;;
            --channel)
                CHANNEL="$2"
                shift 2
                ;;
            --version)
                VERSION="$2"
                shift 2
                ;;
            --auth-file)
                AUTH_FILE="$2"
                shift 2
                ;;
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            --output-format)
                OUTPUT_FORMAT="$2"
                shift 2
                ;;
            --filter)
                FILTER="$2"
                shift 2
                ;;
            --parallel)
                PARALLEL_JOBS="$2"
                shift 2
                ;;
            --no-deps)
                INCLUDE_DEPS="false"
                shift
                ;;
            --idms)
                IDMS_FILE="$2"
                shift 2
                ;;
            --debug)
                DEBUG=true
                shift
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                usage
                exit 1
                ;;
        esac
    done
    
    # Route to appropriate command
    case "$command" in
        list)
            cmd_index_list
            ;;
        versions)
            cmd_index_versions
            ;;
        validate)
            cmd_validate
            ;;
        idms-validate)
            cmd_idms_validate
            ;;
        "")
            usage
            exit 0
            ;;
        *)
            log_error "Unknown command: $command"
            usage
            exit 1
            ;;
    esac
}

#######################################
# Main
#######################################
main() {
    check_requirements
    parse_args "$@"
}

main "$@"
