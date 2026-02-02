# Operator Images Validator - Test Reports

Generated: 2026-02-02 (v1.0.0)

## Summary

This document contains validation reports for OpenShift operator images using the `operator-images-validator.sh` tool with the new `operator:channel` format.

### Test Configuration

| Parameter | GA Tests | PreGA v4.21 | PreGA v4.22 |
|-----------|----------|-------------|-------------|
| Catalog | `registry.redhat.io/redhat/redhat-operator-index:v4.20` | `quay.io/prega/prega-operator-index:v4.21-20260202T055019` | `quay.io/prega/prega-operator-index:v4.22-20260202T095851` |
| Mode | Source Registry (GA Release) | IDMS Mirror Mapping | IDMS Mirror Mapping |
| IDMS File | N/A | `prega-idms-4.21.yaml` (461 mappings) | `prega-idms-4.22.yaml` (478 mappings) |

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
| ODF (PreGA v4.21) | v4.21 | odf-operator:stable-4.21 | IDMS | 30 | 22 (73%) | 8 | 🔴 **FAILED** |
| ACM (PreGA v4.21) | v4.21 | advanced-cluster-management:release-2.16 | IDMS | 105 | 19 (18%) | 86 | 🔴 **FAILED** |
| RAN (PreGA v4.21) | v4.21 | ptp-operator:stable | IDMS | 5 | 4 (80%) | 1 | 🔴 **FAILED** |
| | | local-storage-operator:stable | IDMS | 4 | 3 (75%) | 1 | 🔴 **FAILED** |
| | | sriov-network-operator:stable | IDMS | 10 | 9 (90%) | 1 | 🟡 **FAILED** |
| | | cluster-logging:stable-6.4 | IDMS | 3 | 3 (100%) | 0 | 🟢 **PASSED** |
| | | lifecycle-agent:stable | IDMS | 2 | 2 (100%) | 0 | 🟢 **PASSED** |
| | | redhat-oadp-operator:stable | IDMS | 11 | 11 (100%) | 0 | 🟢 **PASSED** |
| ODF (PreGA v4.22) | v4.22 | odf-operator:stable-4.22 | IDMS | 30 | 22 (73%) | 8 | 🔴 **FAILED** |
| ACM (PreGA v4.22) | v4.22 | advanced-cluster-management:release-2.16 | IDMS | 105 | 19 (18%) | 86 | 🔴 **FAILED** |
| RAN (PreGA v4.22) | v4.22 | ptp-operator:stable | IDMS | 5 | 4 (80%) | 1 | 🔴 **FAILED** |
| | | local-storage-operator:stable | IDMS | 4 | 3 (75%) | 1 | 🔴 **FAILED** |
| | | sriov-network-operator:stable | IDMS | 10 | 9 (90%) | 1 | 🟡 **FAILED** |
| | | cluster-logging:stable-6.2 | IDMS | 3 | 3 (100%) | 0 | 🟢 **PASSED** |
| | | lifecycle-agent:stable | IDMS | 2 | 2 (100%) | 0 | 🟢 **PASSED** |
| | | redhat-oadp-operator:stable | IDMS | 11 | 11 (100%) | 0 | 🟢 **PASSED** |

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

PreGA tests validate images using IDMS mirror mappings to the PreGA registry.

### 1. ODF Operator (PreGA v4.22)

**Command:**
```bash
./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.22-20260202T095851 \
  --idms prega-idms-4.22.yaml \
  --operators odf-operator:stable-4.22
```

**Result:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  📋 Operator Image Validation Report
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  📦 Catalog:   quay.io/prega/prega-operator-index:v4.22-20260202T095851
  🔄 Mode:      IDMS Mirror Mapping
  📄 IDMS:      prega-idms-4.22.yaml (459 mappings)
  🔧 Operators: odf-operator(stable-4.22)
  📅 Date:      2026-02-02 15:16:02 UTC

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ❌ Status: FAILED

  📊 Summary:
     Total Images:     30
     ✓ Available:      22 (73.3%)
     ✗ Missing:        8 (26.7%)

  ██████████████████████████████████████████████░░░░░░░░░░░░░░ 73.3%

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ❌ Missing Images (8):

     • registry.redhat.io/openshift4/ose-kube-rbac-proxy-rhel9@sha256:...
     • registry.redhat.io/openshift4/ose-oauth-proxy-rhel9@sha256:...
     • registry.redhat.io/openshift4/ose-prometheus-alertmanager-rhel9@sha256:...
     • registry.redhat.io/openshift4/ose-prometheus-config-reloader-rhel9@sha256:...
     • registry.redhat.io/openshift4/ose-prometheus-rhel9-operator@sha256:...
     • registry.redhat.io/openshift4/ose-prometheus-rhel9@sha256:...
     • registry.redhat.io/rhceph/rhceph-9-rhel9@sha256:...
     • registry.redhat.io/rhel8/postgresql-12@sha256:...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Note:** ODF has 8 missing images - these are common OpenShift infrastructure images (prometheus, oauth-proxy, kube-rbac-proxy) not included in the IDMS file.

---

### 2. ACM Operator (PreGA v4.22)

**Command:**
```bash
./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.22-20260202T095851 \
  --idms prega-idms-4.22.yaml \
  --operators advanced-cluster-management:release-2.16
```

**Result:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  📋 Operator Image Validation Report
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  📦 Catalog:   quay.io/prega/prega-operator-index:v4.22-20260202T095851
  🔄 Mode:      IDMS Mirror Mapping
  📄 IDMS:      prega-idms-4.22.yaml (459 mappings)
  🔧 Operators: advanced-cluster-management(release-2.16)
  📅 Date:      2026-02-02 15:15:55 UTC

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ❌ Status: FAILED

  📊 Summary:
     Total Images:     105
     ✓ Available:      19 (18.1%)
     ✗ Missing:        86 (81.9%)

  ██████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ 18.1%

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ❌ Missing Images (86):

     • registry.redhat.io/multicluster-engine/addon-manager-rhel9@sha256:...
     • registry.redhat.io/multicluster-engine/assisted-image-service-rhel9@sha256:...
     • ... (86 total missing images from multicluster-engine and rhacm2 namespaces)
```

**Note:** ACM has 86 missing images - the IDMS file is missing mappings for multicluster-engine and rhacm2 namespaces.

---

### 3. RAN Operators (PreGA v4.22)

**Command:**
```bash
./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.22-20260202T095851 \
  --idms prega-idms-4.22.yaml \
  --operators ptp-operator:stable,local-storage-operator:stable,sriov-network-operator:stable,cluster-logging:stable-6.2,lifecycle-agent:stable,redhat-oadp-operator:stable \
  --no-deps
```

**Results by operator:**

| Operator | Total | Available | Missing | Status |
|----------|-------|-----------|---------|--------|
| ptp-operator:stable | 5 | 4 (80%) | 1 | 🔴 **FAILED** |
| local-storage-operator:stable | 4 | 3 (75%) | 1 | 🔴 **FAILED** |
| sriov-network-operator:stable | 10 | 9 (90%) | 1 | 🟡 **FAILED** |
| cluster-logging:stable-6.2 | 3 | 3 (100%) | 0 | 🟢 **PASSED** |
| lifecycle-agent:stable | 2 | 2 (100%) | 0 | 🟢 **PASSED** |
| redhat-oadp-operator:stable | 11 | 11 (100%) | 0 | 🟢 **PASSED** |

**Note:** The missing image across ptp, local-storage, and sriov operators is `ose-kube-rbac-proxy-rhel9` - a common OpenShift infrastructure image not included in the IDMS file.

---

## PreGA Release Tests (v4.21)

PreGA tests validate images using IDMS mirror mappings to the PreGA registry.

### 1. ODF Operator (PreGA v4.21)

**Command:**
```bash
./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.21-20260202T055019 \
  --idms prega-idms-4.21.yaml \
  --operators odf-operator:stable-4.21
```

**Result:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  📋 Operator Image Validation Report
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  📦 Catalog:   quay.io/prega/prega-operator-index:v4.21-20260202T055019
  🔄 Mode:      IDMS Mirror Mapping
  📄 IDMS:      prega-idms-4.21.yaml (442 mappings)
  🔧 Operators: odf-operator(stable-4.21)
  📅 Date:      2026-02-02 15:15:15 UTC

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ❌ Status: FAILED

  📊 Summary:
     Total Images:     30
     ✓ Available:      22 (73.3%)
     ✗ Missing:        8 (26.7%)

  ██████████████████████████████████████████████░░░░░░░░░░░░░░ 73.3%

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ❌ Missing Images (8):

     • registry.redhat.io/openshift4/ose-kube-rbac-proxy-rhel9@sha256:e5bb9eca4e9d9c3a55d04695edf6c1d9f571bd86341f8d2a7132a951dae67bd7
     • registry.redhat.io/openshift4/ose-oauth-proxy-rhel9@sha256:fbd2fe6c6f19065e416957243275cd12254dd47ecffc1363b77475797559b56c
     • registry.redhat.io/openshift4/ose-prometheus-alertmanager-rhel9@sha256:...
     • registry.redhat.io/openshift4/ose-prometheus-config-reloader-rhel9@sha256:...
     • registry.redhat.io/openshift4/ose-prometheus-rhel9-operator@sha256:...
     • registry.redhat.io/openshift4/ose-prometheus-rhel9@sha256:...
     • registry.redhat.io/rhceph/rhceph-9-rhel9@sha256:...
     • registry.redhat.io/rhel8/postgresql-12@sha256:...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Note:** ODF has 8 missing images - these are common OpenShift infrastructure images (prometheus, oauth-proxy, kube-rbac-proxy) not included in the IDMS file.

---

### 2. ACM Operator (PreGA v4.21)

**Command:**
```bash
./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.21-20260202T055019 \
  --idms prega-idms-4.21.yaml \
  --operators advanced-cluster-management:release-2.16
```

**Result:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  📋 Operator Image Validation Report
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  📦 Catalog:   quay.io/prega/prega-operator-index:v4.21-20260202T055019
  🔄 Mode:      IDMS Mirror Mapping
  📄 IDMS:      prega-idms-4.21.yaml (442 mappings)
  🔧 Operators: advanced-cluster-management(release-2.16)
  📅 Date:      2026-02-02 15:15:09 UTC

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ❌ Status: FAILED

  📊 Summary:
     Total Images:     105
     ✓ Available:      19 (18.1%)
     ✗ Missing:        86 (81.9%)

  ██████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ 18.1%

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ❌ Missing Images (86):

     • registry.redhat.io/multicluster-engine/addon-manager-rhel9@sha256:...
     • registry.redhat.io/multicluster-engine/assisted-image-service-rhel9@sha256:...
     • ... (86 total missing images from multicluster-engine and rhacm2 namespaces)
```

**Note:** ACM has 86 missing images - the IDMS file is missing mappings for multicluster-engine and rhacm2 namespaces.

---

### 3. RAN Operators (PreGA v4.21)

**Command:**
```bash
./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.21-20260202T055019 \
  --idms prega-idms-4.21.yaml \
  --operators ptp-operator:stable,local-storage-operator:stable,sriov-network-operator:stable,cluster-logging:stable-6.4,lifecycle-agent:stable,redhat-oadp-operator:stable \
  --no-deps
```

**Results by operator:**

| Operator | Total | Available | Missing | Status |
|----------|-------|-----------|---------|--------|
| ptp-operator:stable | 5 | 4 (80%) | 1 | 🔴 **FAILED** |
| local-storage-operator:stable | 4 | 3 (75%) | 1 | 🔴 **FAILED** |
| sriov-network-operator:stable | 10 | 9 (90%) | 1 | 🟡 **FAILED** |
| cluster-logging:stable-6.4 | 3 | 3 (100%) | 0 | 🟢 **PASSED** |
| lifecycle-agent:stable | 2 | 2 (100%) | 0 | 🟢 **PASSED** |
| redhat-oadp-operator:stable | 11 | 11 (100%) | 0 | 🟢 **PASSED** |

**Note:** The missing image across ptp, local-storage, and sriov operators is `ose-kube-rbac-proxy-rhel9` - a common OpenShift infrastructure image not included in the IDMS file.

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

| Catalog | Channel | Mode | Total | Available | Missing | Status |
|---------|---------|------|-------|-----------|---------|--------|
| GA v4.20 | stable-4.19 | Source | 28 | 28 (100%) | 0 | 🟢 **PASSED** |
| GA v4.20 | stable-4.20 | Source | 28 | 28 (100%) | 0 | 🟢 **PASSED** |
| PreGA v4.21 | stable-4.21 | IDMS | 30 | 22 (73%) | 8 | 🔴 **FAILED** |
| PreGA v4.22 | stable-4.22 | IDMS | 30 | 22 (73%) | 8 | 🔴 **FAILED** |

### ACM Operator - All Available Channels

| Catalog | Channel | Mode | Total | Available | Missing | Status |
|---------|---------|------|-------|-----------|---------|--------|
| GA v4.20 | release-2.14 | Source | 96 | 96 (100%) | 0 | 🟢 **PASSED** |
| GA v4.20 | release-2.15 | Source | 104 | 104 (100%) | 0 | 🟢 **PASSED** |
| PreGA v4.21 | release-2.16 | IDMS | 105 | 19 (18%) | 86 | 🔴 **FAILED** |
| PreGA v4.22 | release-2.16 | IDMS | 105 | 19 (18%) | 86 | 🔴 **FAILED** |

### Key Findings

- **GA releases (v4.20)**: All channels pass with 100% image availability
- **PreGA ODF with IDMS**: 73% availability - missing common OpenShift infrastructure images (prometheus, kube-rbac-proxy)
- **PreGA ACM with IDMS**: Only 18% availability - IDMS file missing multicluster-engine and rhacm2 namespace mappings
- **PreGA RAN with IDMS**: Most operators reach 75-100% availability; missing image is `ose-kube-rbac-proxy-rhel9`

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

# PreGA v4.21 - ODF (with IDMS)
./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.21-20260202T055019 \
  --idms prega-idms-4.21.yaml \
  --operators odf-operator:stable-4.21

# PreGA v4.21 - ACM (with IDMS)
./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.21-20260202T055019 \
  --idms prega-idms-4.21.yaml \
  --operators advanced-cluster-management:release-2.16

# PreGA v4.21 - RAN (with IDMS, individual operators)
./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.21-20260202T055019 \
  --idms prega-idms-4.21.yaml \
  --operators ptp-operator:stable --no-deps

./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.21-20260202T055019 \
  --idms prega-idms-4.21.yaml \
  --operators local-storage-operator:stable --no-deps

./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.21-20260202T055019 \
  --idms prega-idms-4.21.yaml \
  --operators sriov-network-operator:stable --no-deps

./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.21-20260202T055019 \
  --idms prega-idms-4.21.yaml \
  --operators cluster-logging:stable-6.4 --no-deps

./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.21-20260202T055019 \
  --idms prega-idms-4.21.yaml \
  --operators lifecycle-agent:stable --no-deps

./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.21-20260202T055019 \
  --idms prega-idms-4.21.yaml \
  --operators redhat-oadp-operator:stable --no-deps

# PreGA v4.22 - ODF (with IDMS)
./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.22-20260202T095851 \
  --idms prega-idms-4.22.yaml \
  --operators odf-operator:stable-4.22

# PreGA v4.22 - ACM (with IDMS)
./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.22-20260202T095851 \
  --idms prega-idms-4.22.yaml \
  --operators advanced-cluster-management:release-2.16

# PreGA v4.22 - RAN (with IDMS, individual operators)
./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.22-20260202T095851 \
  --idms prega-idms-4.22.yaml \
  --operators ptp-operator:stable --no-deps

./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.22-20260202T095851 \
  --idms prega-idms-4.22.yaml \
  --operators local-storage-operator:stable --no-deps

./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.22-20260202T095851 \
  --idms prega-idms-4.22.yaml \
  --operators sriov-network-operator:stable --no-deps

./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.22-20260202T095851 \
  --idms prega-idms-4.22.yaml \
  --operators cluster-logging:stable-6.2 --no-deps

./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.22-20260202T095851 \
  --idms prega-idms-4.22.yaml \
  --operators lifecycle-agent:stable --no-deps

./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.22-20260202T095851 \
  --idms prega-idms-4.22.yaml \
  --operators redhat-oadp-operator:stable --no-deps
```
