# Operator Images Validator

A CLI tool to validate OpenShift operator images availability in container registries. Essential for air-gapped/disconnected environments.

## Features

- **Catalog Discovery** - List operators, channels, and versions from operator catalogs
- **Image Validation** - Validate images exist in source or mirror registries
- **IDMS Support** - Use ImageDigestMirrorSet files for mirror mappings
- **Dependency Resolution** - Automatically include images from dependent operators
- **Remediation** - Generate `skopeo copy` commands for missing images
- **Channel Validation** - Exit with error if specified channel doesn't exist

## Requirements

- `oc` - OpenShift CLI
- `podman` - Container runtime
- `jq` - JSON processor
- `skopeo` - Container image utility
- `yq` - YAML processor (for IDMS support)

## Quick Start

```bash
# Make script executable
chmod +x operator-images-validator.sh

# List operators in a catalog
./operator-images-validator.sh list \
  --catalog registry.redhat.io/redhat/redhat-operator-index:v4.20

# Validate GA release (checks source registry directly)
./operator-images-validator.sh validate \
  --catalog registry.redhat.io/redhat/redhat-operator-index:v4.20 \
  --operators odf-operator:stable-4.20

# Validate PreGA with IDMS (operator:channel format)
./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.22 \
  --idms prega-idms-4.22.yaml \
  --operators odf-operator:stable-4.22

# Validate CloudRAN operators for Telco deployments
./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.22 \
  --idms prega-idms-4.22.yaml \
  --operators ptp-operator:stable,local-storage-operator:stable,sriov-network-operator:stable,cluster-logging:stable-6.2,lifecycle-agent:stable,redhat-oadp-operator:stable
```

## Commands

### `list`
List all operators available in an operator catalog.

```bash
./operator-images-validator.sh list --catalog <catalog-image> [--filter <pattern>]
```

### `versions`
Show available channels and versions for a specific operator.

```bash
./operator-images-validator.sh versions --catalog <catalog-image> --operator <name>
```

### `validate`
Validate that operator images are available in the target registry.

```bash
# GA release - validate against source registry
./operator-images-validator.sh validate \
  --catalog registry.redhat.io/redhat/redhat-operator-index:v4.20 \
  --operators odf-operator:stable-4.20

# Disconnected - validate using IDMS mirror mappings
./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.22 \
  --idms imagedigestmirrorset.yaml \
  --operators odf-operator:stable-4.22

# Disconnected - validate against target registry
./operator-images-validator.sh validate \
  --catalog registry.redhat.io/redhat/redhat-operator-index:v4.20 \
  --target-registry mirror.example.com:5000 \
  --operators odf-operator:stable-4.20
```

### `idms-validate`
Validate that all mirrors defined in an IDMS file are accessible.

```bash
./operator-images-validator.sh idms-validate --idms imagedigestmirrorset.yaml
```

## Options

| Option | Description |
|--------|-------------|
| `--catalog <image>` | Operator catalog image (required) |
| `--operators <list>` | Comma-separated operators (format: `op1:channel,op2`) |
| `--idms <file>` | IDMS YAML file for mirror mappings |
| `--target-registry <reg>` | Target registry URL |
| `--channel <name>` | Default channel for operators without specified channel |
| `--version <ver>` | Use specific version |
| `--no-deps` | Skip dependency resolution |
| `--output-format <fmt>` | Output format: table, json, yaml, remediation |
| `-v, --verbose` | Show detailed progress |
| `-h, --help` | Show help message |

### Operator Format

Operators can be specified with or without channels:
- `odf-operator` - uses default channel
- `odf-operator:stable-4.22` - uses specified channel
- `odf-operator:stable-4.22,ptp-operator,cluster-logging:stable-6.2` - mixed

**Note:** If a specified channel doesn't exist, the tool exits with an error showing available channels:
```
[ERROR] Channel 'stable-4.17' not found for operator 'odf-operator'
[ERROR] Available channels: stable-4.19,stable-4.20
```

## Dependency Resolution

The tool automatically includes images from dependent operators:

| Operator | Dependencies |
|----------|--------------|
| `odf-operator` | ocs-operator, mcg-operator, rook-ceph-operator, cephcsi-operator, etc. |
| `advanced-cluster-management` | multicluster-engine |
| `cluster-logging` | loki-operator, elasticsearch-operator |

Use `--no-deps` to disable automatic dependency resolution.

## Common Operator Groups

### CloudRAN / Telco Operators
For CloudRAN and Telco deployments, commonly validated operators include:

```bash
./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.22 \
  --idms prega-idms.yaml \
  --operators ptp-operator:stable,local-storage-operator:stable,sriov-network-operator:stable,cluster-logging:stable-6.2,lifecycle-agent:stable,redhat-oadp-operator:stable
```

| Operator | Purpose |
|----------|---------|
| `ptp-operator` | Precision Time Protocol for 5G timing |
| `local-storage-operator` | Local storage management |
| `sriov-network-operator` | SR-IOV network configuration |
| `cluster-logging` | OpenShift logging stack |
| `lifecycle-agent` | Image-based cluster upgrades (LCA) |
| `redhat-oadp-operator` | OpenShift API for Data Protection (backup/restore) |

## Validation Modes

### 1. GA Release Mode (Source Registry)
For GA releases, omit `--idms` and `--target-registry` to validate images directly at their source registry.

```bash
./operator-images-validator.sh validate \
  --catalog registry.redhat.io/redhat/redhat-operator-index:v4.20 \
  --operators odf-operator:stable-4.20
```

### 2. IDMS Mode (Disconnected with Mirror Mapping)
Use an ImageDigestMirrorSet file to map source images to mirror locations.

```bash
./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.22 \
  --idms prega-idms.yaml \
  --operators odf-operator:stable-4.22
```

### 3. Target Registry Mode (Disconnected)
Specify a target registry where all images should be mirrored.

```bash
./operator-images-validator.sh validate \
  --catalog registry.redhat.io/redhat/redhat-operator-index:v4.20 \
  --target-registry mirror.example.com:5000 \
  --operators odf-operator:stable-4.20
```

## Output Examples

### GA Release (All Images Available)

```bash
./operator-images-validator.sh validate \
  --catalog registry.redhat.io/redhat/redhat-operator-index:v4.20 \
  --operators odf-operator:stable-4.20
```

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  📋 Operator Image Validation Report
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  📦 Catalog:   registry.redhat.io/redhat/redhat-operator-index:v4.20
  🔄 Mode:      Source Registry (GA Release)
  🔧 Operators: odf-operator(stable-4.20)
  📅 Date:      2026-02-01 03:55:28 UTC

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ✅ Status: PASSED

  📊 Summary:
     Total Images:     28
     ✓ Available:      28 (100.0%)
     ✗ Missing:        0 (0.0%)

  ████████████████████████████████████████████████████████████ 100.0%

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ✅ All images are available!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### PreGA Release (Missing Images)

```bash
./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.22-20260121T101531 \
  --idms prega-idms.yaml \
  --operators odf-operator:stable-4.22
```

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  📋 Operator Image Validation Report
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  📦 Catalog:   quay.io/prega/prega-operator-index:v4.22-20260121T101531
  🔄 Mode:      IDMS Mirror Mapping
  📄 IDMS:      prega-idms.yaml (450 mappings)
  🔧 Operators: odf-operator(stable-4.22)
  📅 Date:      2026-02-01 03:57:56 UTC

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ❌ Status: FAILED

  📊 Summary:
     Total Images:     31
     ✓ Available:      22 (71.0%)
     ✗ Missing:        9 (29.0%)

  ████████████████████████████████████████████░░░░░░░░░░░░░░░░ 71.0%

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ❌ Missing Images (9):

     • registry.redhat.io/odf4/ocs-devicefinder-rhel9@sha256:560d018ce0b7cd211a00f1727029a2a6a726f106f426dd5a7a5b561e7a430a5e
     • registry.redhat.io/openshift4/ose-kube-rbac-proxy-rhel9@sha256:883be225980cafa658d73b7d87ac99a39dce0fa8fb7754158ec28dc218bc903d
     • ...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  💡 Tip: Run with --output-format=remediation to generate mirror commands.
```

The report shows each operator with its channel in parentheses (e.g., `odf-operator(stable-4.22)`).

## Remediation

Generate `skopeo copy` commands for missing images:

```bash
./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.22 \
  --idms prega-idms.yaml \
  --operators odf-operator:stable-4.22 \
  --output-format=remediation
```

Output:
```bash
# Copy missing images to mirror registry
skopeo copy docker://registry.redhat.io/odf4/image@sha256:... docker://mirror.example.com/odf4/image@sha256:...
```

## Supported Catalog Formats

- **File-Based Catalog (FBC)** - Modern format with JSON files
  - Split format: `configs/<operator>/catalog.json`
  - Hierarchical format: `configs/<operator>/channels/*.json`, `configs/<operator>/bundles/*.json`
  - Flat format with channels: `configs/<operator>/channels.json` (NDJSON)
  - Single file: `configs/index.json` or `configs/catalog.json`

## Version

Current version: **1.0.0**

## License

Apache License 2.0
