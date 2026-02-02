# Operator Images Validator - Test Reports

Generated: 2026-02-02 (v1.0.0)

## Summary

This document contains validation reports for OpenShift operator images using the `operator-images-validator.sh` tool with the new `operator:channel` format.

### Test Configuration

| Parameter | GA Tests | PreGA v4.21 | PreGA v4.22 |
|-----------|----------|-------------|-------------|
| Catalog | `registry.redhat.io/redhat/redhat-operator-index:v4.20` | `quay.io/prega/prega-operator-index:v4.21-20260202T055019` | `quay.io/prega/prega-operator-index:v4.22-20260202T095851` |
| Mode | Source Registry (GA Release) | Source Registry (PreGA) | Source Registry (PreGA) |
| IDMS File | N/A | N/A | N/A |

### Results Summary

| Test | Catalog Version | Operator:Channel | Mode | Total | Available | Missing | Status |
|------|----------------|------------------|------|-------|-----------|---------|--------|
| ODF (GA) | v4.20 | odf-operator:stable-4.19 | Source | 28 | 28 (100%) | 0 | 🟢 **PASSED** |
| ODF (GA) | v4.20 | odf-operator:stable-4.20 | Source | 28 | 28 (100%) | 0 | 🟢 **PASSED** |
| ACM (GA) | v4.20 | advanced-cluster-management:release-2.14 | Source | 96 | 96 (100%) | 0 | 🟢 **PASSED** |
| ACM (GA) | v4.20 | advanced-cluster-management:release-2.15 | Source | 104 | 104 (100%) | 0 | 🟢 **PASSED** |
| RAN (GA) | v4.20 | ptp-operator:stable | Source | 4 | 4 (100%) | 0 | 🟢 **PASSED** |
| | | local-storage-operator:stable | Source | 4 | 4 (100%) | 0 | 🟢 **PASSED** |
| | | sriov-network-operator:stable | Source | 7 | 7 (100%) | 0 | 🟢 **PASSED** |
| | | cluster-logging:stable-6.2 | Source | 3 | 3 (100%) | 0 | 🟢 **PASSED** |
| | | cluster-logging:stable-6.3 | Source | 3 | 3 (100%) | 0 | 🟢 **PASSED** |
| | | cluster-logging:stable-6.4 | Source | 12 | 12 (100%) | 0 | 🟢 **PASSED** |
| | | lifecycle-agent:stable | Source | 3 | 3 (100%) | 0 | 🟢 **PASSED** |
| | | redhat-oadp-operator:stable | Source | 7 | 7 (100%) | 0 | 🟢 **PASSED** |
| ODF (PreGA v4.21) | v4.21 | odf-operator:stable-4.21 | Source | 30 | 13 (43%) | 17 | 🔴 **FAILED** |
| ACM (PreGA v4.21) | v4.21 | advanced-cluster-management:release-2.16 | Source | 105 | 19 (18%) | 86 | 🔴 **FAILED** |
| RAN (PreGA v4.21) | v4.21 | ptp-operator:stable | Source | 5 | 0 (0%) | 5 | 🔴 **FAILED** |
| | | local-storage-operator:stable | Source | 4 | 0 (0%) | 4 | 🔴 **FAILED** |
| | | sriov-network-operator:stable | Source | 10 | 0 (0%) | 10 | 🔴 **FAILED** |
| | | cluster-logging:stable-6.4 | Source | 3 | 3 (100%) | 0 | 🟢 **PASSED** |
| | | lifecycle-agent:stable | Source | 2 | 0 (0%) | 2 | 🔴 **FAILED** |
| | | redhat-oadp-operator:stable | Source | 11 | 11 (100%) | 0 | 🟢 **PASSED** |
| ODF (PreGA v4.22) | v4.22 | odf-operator:stable-4.22 | Source | 30 | 14 (47%) | 16 | 🔴 **FAILED** |
| ACM (PreGA v4.22) | v4.22 | advanced-cluster-management:release-2.16 | Source | 105 | 19 (18%) | 86 | 🔴 **FAILED** |
| RAN (PreGA v4.22) | v4.22 | ptp-operator:stable | Source | 5 | 0 (0%) | 5 | 🔴 **FAILED** |
| | | local-storage-operator:stable | Source | 4 | 0 (0%) | 4 | 🔴 **FAILED** |
| | | sriov-network-operator:stable | Source | 10 | 0 (0%) | 10 | 🔴 **FAILED** |
| | | cluster-logging:stable-6.2 | Source | 3 | 0 (0%) | 3 | 🔴 **FAILED** |
| | | lifecycle-agent:stable | Source | 2 | 0 (0%) | 2 | 🔴 **FAILED** |
| | | redhat-oadp-operator:stable | Source | 11 | 11 (100%) | 0 | 🟢 **PASSED** |

> **Legend:** 🟢 100% available | 🟡 >90% available | 🔴 <90% available

---

## GA Release Tests (v4.20)

All GA tests passed with 100% image availability.

### 1. ODF Operator (GA)

**Command:**
```bash
./operator-images-validator.sh validate \
  --catalog registry.redhat.io/redhat/redhat-operator-index:v4.20 \
  --operators odf-operator:stable-4.20
```

**Result:**
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

**Dependencies included:** ocs-operator, mcg-operator, odf-csi-addons-operator, rook-ceph-operator, odf-prometheus-operator, cephcsi-operator

---

### 2. ACM Operator (GA)

**Command:**
```bash
./operator-images-validator.sh validate \
  --catalog registry.redhat.io/redhat/redhat-operator-index:v4.20 \
  --operators advanced-cluster-management:release-2.15
```

**Result:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  📋 Operator Image Validation Report
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  📦 Catalog:   registry.redhat.io/redhat/redhat-operator-index:v4.20
  🔄 Mode:      Source Registry (GA Release)
  🔧 Operators: advanced-cluster-management(release-2.15)
  📅 Date:      2026-02-01 03:57:29 UTC

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ✅ Status: PASSED

  📊 Summary:
     Total Images:     104
     ✓ Available:      104 (100.0%)
     ✗ Missing:        0 (0.0%)

  ████████████████████████████████████████████████████████████ 100.0%

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ✅ All images are available!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Dependencies included:** multicluster-engine

---

### 3. RAN Operators (GA)

> **Note:** RAN refers to a set of several Telco operators commonly used for Radio Access Network deployments, including: ptp-operator, local-storage-operator, sriov-network-operator, cluster-logging, lifecycle-agent, and redhat-oadp-operator.

**Command:**
```bash
./operator-images-validator.sh validate \
  --catalog registry.redhat.io/redhat/redhat-operator-index:v4.20 \
  --operators ptp-operator:stable,local-storage-operator:stable,sriov-network-operator:stable,cluster-logging:stable-6.4,lifecycle-agent:stable,redhat-oadp-operator:stable
```

**Result:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  📋 Operator Image Validation Report
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  📦 Catalog:   registry.redhat.io/redhat/redhat-operator-index:v4.20
  🔄 Mode:      Source Registry (GA Release)
  🔧 Operators: ptp-operator(stable)
                local-storage-operator(stable)
                sriov-network-operator(stable)
                cluster-logging(stable-6.4)
                lifecycle-agent(stable)
                redhat-oadp-operator(stable)
  📅 Date:      2026-02-01 16:23:27 UTC

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ✅ Status: PASSED

  📊 Summary:
     Total Images:     37
     ✓ Available:      37 (100.0%)
     ✗ Missing:        0 (0.0%)

  ████████████████████████████████████████████████████████████ 100.0%

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ✅ All images are available!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Operators included:** ptp-operator, local-storage-operator, sriov-network-operator, cluster-logging (with loki-operator), lifecycle-agent, redhat-oadp-operator

---

## PreGA Release Tests (v4.22)

PreGA tests validate images at the source registry (images not yet GA released).

### 1. ODF Operator (PreGA)

**Command:**
```bash
./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.22-20260202T095851 \
  --operators odf-operator:stable-4.22
```

**Result:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  📋 Operator Image Validation Report
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  📦 Catalog:   quay.io/prega/prega-operator-index:v4.22-20260202T095851
  🔄 Mode:      Source Registry (GA Release)
  🔧 Operators: odf-operator(stable-4.22)
  📅 Date:      2026-02-02 14:53:30 UTC

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ❌ Status: FAILED

  📊 Summary:
     Total Images:     30
     ✓ Available:      14 (46.7%)
     ✗ Missing:        16 (53.3%)

  ████████████████████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ 46.7%

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ❌ Missing Images (16):

     • registry.redhat.io/odf4/cephcsi-rhel9-operator@sha256:e01c09106fe6c5d5cf31deadebd1bb936a42b777db181983915a3a9a63dd7c1f
     • registry.redhat.io/odf4/cephcsi-rhel9@sha256:05ce8093020758a54d2d54a840d81c3b634f075210704e81e1e9b2fdf9623f51
     • registry.redhat.io/odf4/devicefinder-rhel9@sha256:a3cc3bdd92f79195ad5c006db0037ef1c5d2685133d24a3ac499d63ff5eb1198
     • ... (16 total missing images)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  💡 Tip: Run with --output-format=remediation to generate mirror commands.
```

**Note:** ODF has 16 missing images - these are PreGA images not yet published to the GA registry.

---

### 2. ACM Operator (PreGA)

**Command:**
```bash
./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.22-20260202T095851 \
  --operators advanced-cluster-management:release-2.16
```

**Result:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  📋 Operator Image Validation Report
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  📦 Catalog:   quay.io/prega/prega-operator-index:v4.22-20260202T095851
  🔄 Mode:      Source Registry (GA Release)
  🔧 Operators: advanced-cluster-management(release-2.16)
  📅 Date:      2026-02-02 14:53:49 UTC

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ❌ Status: FAILED

  📊 Summary:
     Total Images:     105
     ✓ Available:      19 (18.1%)
     ✗ Missing:        86 (81.9%)

  ██████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ 18.1%

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ❌ Missing Images (86):

     • registry.redhat.io/multicluster-engine/addon-manager-rhel9@sha256:e7c19076e9e68c8e07b78e1607a0586381ca3fe01bfdb2d460a0099614a99edd
     • registry.redhat.io/multicluster-engine/assisted-image-service-rhel9@sha256:5f41abafe6e982b22353fd41fe01be9da4ea480fe412124b3f88f75c69b310aa
     • ... (86 total missing images)
```

**Note:** ACM has 86 missing images - these are PreGA images not yet published to the GA registry.

---

### 3. RAN Operators (PreGA)

**Command:**
```bash
./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.22-20260202T095851 \
  --operators ptp-operator:stable,local-storage-operator:stable,sriov-network-operator:stable,cluster-logging:stable-6.2,lifecycle-agent:stable,redhat-oadp-operator:stable \
  --no-deps
```

**Results by operator:**

| Operator | Total | Available | Missing | Status |
|----------|-------|-----------|---------|--------|
| ptp-operator:stable | 5 | 0 (0%) | 5 | 🔴 **FAILED** |
| local-storage-operator:stable | 4 | 0 (0%) | 4 | 🔴 **FAILED** |
| sriov-network-operator:stable | 10 | 0 (0%) | 10 | 🔴 **FAILED** |
| cluster-logging:stable-6.2 | 3 | 0 (0%) | 3 | 🔴 **FAILED** |
| lifecycle-agent:stable | 2 | 0 (0%) | 2 | 🔴 **FAILED** |
| redhat-oadp-operator:stable | 11 | 11 (100%) | 0 | 🟢 **PASSED** |

**Note:** Only redhat-oadp-operator has all images available. Other RAN operators have PreGA images not yet published to the GA registry.

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  📋 Operator Image Validation Report (redhat-oadp-operator)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  📦 Catalog:   quay.io/prega/prega-operator-index:v4.22-20260202T095851
  🔄 Mode:      Source Registry (GA Release)
  🔧 Operators: redhat-oadp-operator(stable)
  📅 Date:      2026-02-02 14:54:09 UTC

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ✅ Status: PASSED

  📊 Summary:
     Total Images:     11
     ✓ Available:      11 (100.0%)
     ✗ Missing:        0 (0.0%)

  ████████████████████████████████████████████████████████████ 100.0%

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ✅ All images are available!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## PreGA Release Tests (v4.21)

PreGA tests validate images at the source registry (images not yet GA released).

### 1. ODF Operator (PreGA v4.21)

**Command:**
```bash
./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.21-20260202T055019 \
  --operators odf-operator:stable-4.21
```

**Result:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  📋 Operator Image Validation Report
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  📦 Catalog:   quay.io/prega/prega-operator-index:v4.21-20260202T055019
  🔄 Mode:      Source Registry (GA Release)
  🔧 Operators: odf-operator(stable-4.21)
  📅 Date:      2026-02-02 15:01:15 UTC

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ❌ Status: FAILED

  📊 Summary:
     Total Images:     30
     ✓ Available:      13 (43.3%)
     ✗ Missing:        17 (56.7%)

  ██████████████████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ 43.3%

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ❌ Missing Images (17):

     • registry.redhat.io/odf4/cephcsi-rhel9-operator@sha256:f0ddf6f8faf8a1d274bf427694a565a035e114815c063fac81a8a501d6fc2f87
     • registry.redhat.io/odf4/cephcsi-rhel9@sha256:2aacc7df35fb90d19f035a0cbe4ffdbf3191b3533955290a4042c67cbed91f10
     • ... (17 total missing images)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  💡 Tip: Run with --output-format=remediation to generate mirror commands.
```

**Note:** ODF has 17 missing images - these are PreGA images not yet published to the GA registry.

---

### 2. ACM Operator (PreGA v4.21)

**Command:**
```bash
./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.21-20260202T055019 \
  --operators advanced-cluster-management:release-2.16
```

**Result:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  📋 Operator Image Validation Report
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  📦 Catalog:   quay.io/prega/prega-operator-index:v4.21-20260202T055019
  🔄 Mode:      Source Registry (GA Release)
  🔧 Operators: advanced-cluster-management(release-2.16)
  📅 Date:      2026-02-02 15:01:37 UTC

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ❌ Status: FAILED

  📊 Summary:
     Total Images:     105
     ✓ Available:      19 (18.1%)
     ✗ Missing:        86 (81.9%)

  ██████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ 18.1%

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ❌ Missing Images (86):

     • registry.redhat.io/multicluster-engine/addon-manager-rhel9@sha256:e7c19076e9e68c8e07b78e1607a0586381ca3fe01bfdb2d460a0099614a99edd
     • registry.redhat.io/multicluster-engine/assisted-image-service-rhel9@sha256:5f41abafe6e982b22353fd41fe01be9da4ea480fe412124b3f88f75c69b310aa
     • ... (86 total missing images)
```

**Note:** ACM has 86 missing images - these are PreGA images not yet published to the GA registry.

---

### 3. RAN Operators (PreGA v4.21)

**Command:**
```bash
./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.21-20260202T055019 \
  --operators ptp-operator:stable,local-storage-operator:stable,sriov-network-operator:stable,cluster-logging:stable-6.4,lifecycle-agent:stable,redhat-oadp-operator:stable \
  --no-deps
```

**Results by operator:**

| Operator | Total | Available | Missing | Status |
|----------|-------|-----------|---------|--------|
| ptp-operator:stable | 5 | 0 (0%) | 5 | 🔴 **FAILED** |
| local-storage-operator:stable | 4 | 0 (0%) | 4 | 🔴 **FAILED** |
| sriov-network-operator:stable | 10 | 0 (0%) | 10 | 🔴 **FAILED** |
| cluster-logging:stable-6.4 | 3 | 3 (100%) | 0 | 🟢 **PASSED** |
| lifecycle-agent:stable | 2 | 0 (0%) | 2 | 🔴 **FAILED** |
| redhat-oadp-operator:stable | 11 | 11 (100%) | 0 | 🟢 **PASSED** |

**Note:** Only cluster-logging and redhat-oadp-operator have all images available. Other RAN operators have PreGA images not yet published to the GA registry.

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  📋 Operator Image Validation Report (cluster-logging - PASSED)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  📦 Catalog:   quay.io/prega/prega-operator-index:v4.21-20260202T055019
  🔄 Mode:      Source Registry (GA Release)
  🔧 Operators: cluster-logging(stable-6.4)
  📅 Date:      2026-02-02 15:01:50 UTC

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ✅ Status: PASSED

  📊 Summary:
     Total Images:     3
     ✓ Available:      3 (100.0%)
     ✗ Missing:        0 (0.0%)

  ████████████████████████████████████████████████████████████ 100.0%

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ✅ All images are available!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Multi-Channel Test Results

### ODF Operator - All Available Channels

| Catalog | Channel | Total | Available | Missing | Status |
|---------|---------|-------|-----------|---------|--------|
| GA v4.20 | stable-4.19 | 28 | 28 (100%) | 0 | 🟢 **PASSED** |
| GA v4.20 | stable-4.20 | 28 | 28 (100%) | 0 | 🟢 **PASSED** |
| PreGA v4.21 | stable-4.21 | 30 | 13 (43%) | 17 | 🔴 **FAILED** |
| PreGA v4.22 | stable-4.22 | 30 | 14 (47%) | 16 | 🔴 **FAILED** |

### ACM Operator - All Available Channels

| Catalog | Channel | Total | Available | Missing | Status |
|---------|---------|-------|-----------|---------|--------|
| GA v4.20 | release-2.14 | 96 | 96 (100%) | 0 | 🟢 **PASSED** |
| GA v4.20 | release-2.15 | 104 | 104 (100%) | 0 | 🟢 **PASSED** |
| PreGA v4.21 | release-2.16 | 105 | 19 (18%) | 86 | 🔴 **FAILED** |
| PreGA v4.22 | release-2.16 | 105 | 19 (18%) | 86 | 🔴 **FAILED** |

### Key Findings

- **GA releases (v4.20)**: All channels pass with 100% image availability
- **PreGA ODF**: ~43-47% availability - missing ODF4 namespace images not yet published
- **PreGA ACM**: Only ~18% availability - significant gaps in multicluster-engine and rhacm2 namespace images
- **PreGA RAN**: Most operators have 0% availability except cluster-logging and redhat-oadp-operator (100%)

---

## Operator:Channel Format

The new `operator:channel` format allows specifying channels per operator:

```bash
# Single operator with channel
--operators odf-operator:stable-4.22

# Multiple operators with mixed channels
--operators odf-operator:stable-4.22,ptp-operator:stable,cluster-logging:stable-6.2

# Without channel (uses default)
--operators odf-operator,ptp-operator
```

---

## Remediation

To fix the PreGA failures, add the missing mirrors to the IDMS file. Generate remediation commands:

```bash
# Generate skopeo copy commands for missing images
./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.22-20260121T101531 \
  --idms prega-idms-4.22.yaml \
  --operators odf-operator:stable-4.22 \
  --output-format=remediation
```

---

## Commands Used

```bash
# GA - ODF (all channels)
./operator-images-validator.sh validate \
  --catalog registry.redhat.io/redhat/redhat-operator-index:v4.20 \
  --operators odf-operator:stable-4.19

./operator-images-validator.sh validate \
  --catalog registry.redhat.io/redhat/redhat-operator-index:v4.20 \
  --operators odf-operator:stable-4.20

# GA - ACM (all channels)
./operator-images-validator.sh validate \
  --catalog registry.redhat.io/redhat/redhat-operator-index:v4.20 \
  --operators advanced-cluster-management:release-2.14

./operator-images-validator.sh validate \
  --catalog registry.redhat.io/redhat/redhat-operator-index:v4.20 \
  --operators advanced-cluster-management:release-2.15

# GA - RAN (includes lifecycle-agent and OADP)
./operator-images-validator.sh validate \
  --catalog registry.redhat.io/redhat/redhat-operator-index:v4.20 \
  --operators ptp-operator:stable,local-storage-operator:stable,sriov-network-operator:stable,cluster-logging:stable-6.4,lifecycle-agent:stable,redhat-oadp-operator:stable

# PreGA v4.21 - ODF
./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.21-20260202T055019 \
  --operators odf-operator:stable-4.21

# PreGA v4.21 - ACM
./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.21-20260202T055019 \
  --operators advanced-cluster-management:release-2.16

# PreGA v4.21 - RAN (individual operators)
./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.21-20260202T055019 \
  --operators ptp-operator:stable --no-deps

./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.21-20260202T055019 \
  --operators local-storage-operator:stable --no-deps

./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.21-20260202T055019 \
  --operators sriov-network-operator:stable --no-deps

./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.21-20260202T055019 \
  --operators cluster-logging:stable-6.4 --no-deps

./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.21-20260202T055019 \
  --operators lifecycle-agent:stable --no-deps

./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.21-20260202T055019 \
  --operators redhat-oadp-operator:stable --no-deps

# PreGA v4.22 - ODF
./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.22-20260202T095851 \
  --operators odf-operator:stable-4.22

# PreGA v4.22 - ACM
./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.22-20260202T095851 \
  --operators advanced-cluster-management:release-2.16

# PreGA v4.22 - RAN (individual operators)
./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.22-20260202T095851 \
  --operators ptp-operator:stable --no-deps

./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.22-20260202T095851 \
  --operators local-storage-operator:stable --no-deps

./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.22-20260202T095851 \
  --operators sriov-network-operator:stable --no-deps

./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.22-20260202T095851 \
  --operators cluster-logging:stable-6.2 --no-deps

./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.22-20260202T095851 \
  --operators lifecycle-agent:stable --no-deps

./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.22-20260202T095851 \
  --operators redhat-oadp-operator:stable --no-deps
```
