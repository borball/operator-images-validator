# Operator Images Validator - Test Reports

Generated: 2026-02-01 (v1.0.0)

## Summary

This document contains validation reports for OpenShift operator images using the `operator-images-validator.sh` tool with the new `operator:channel` format.

### Test Configuration

| Parameter | GA Tests | PreGA v4.21 | PreGA v4.22 |
|-----------|----------|-------------|-------------|
| Catalog | `registry.redhat.io/redhat/redhat-operator-index:v4.20` | `quay.io/prega/prega-operator-index:v4.21-20251209T114504` | `quay.io/prega/prega-operator-index:v4.22-20260121T101531` |
| Mode | Source Registry (GA Release) | IDMS Mirror Mapping | IDMS Mirror Mapping |
| IDMS File | N/A | `prega-idms-4.21.yaml` (442 mappings) | `prega-idms-4.22.yaml` (460 mappings) |

### Results Summary

| Test | Catalog Version | Channel | Mode | Total | Available | Missing | Status |
|------|----------------|---------|------|-------|-----------|---------|--------|
| ODF (GA) | v4.20 | stable-4.19 | Source | 28 | 28 (100%) | 0 | 🟢 **PASSED** |
| ODF (GA) | v4.20 | stable-4.20 | Source | 28 | 28 (100%) | 0 | 🟢 **PASSED** |
| ACM (GA) | v4.20 | release-2.14 | Source | 96 | 96 (100%) | 0 | 🟢 **PASSED** |
| ACM (GA) | v4.20 | release-2.15 | Source | 104 | 104 (100%) | 0 | 🟢 **PASSED** |
| ptp-operator (GA) | v4.20 | stable | Source | 4 | 4 (100%) | 0 | 🟢 **PASSED** |
| local-storage-operator (GA) | v4.20 | stable | Source | 4 | 4 (100%) | 0 | 🟢 **PASSED** |
| sriov-network-operator (GA) | v4.20 | stable | Source | 7 | 7 (100%) | 0 | 🟢 **PASSED** |
| cluster-logging (GA) | v4.20 | stable-6.4 | Source | 12 | 12 (100%) | 0 | 🟢 **PASSED** |
| lifecycle-agent (GA) | v4.20 | stable | Source | 3 | 3 (100%) | 0 | 🟢 **PASSED** |
| redhat-oadp-operator (GA) | v4.20 | stable | Source | 7 | 7 (100%) | 0 | 🟢 **PASSED** |
| ODF (PreGA v4.21) | v4.21 | stable-4.21 | IDMS | 30 | 20 (67%) | 10 | 🔴 **FAILED** |
| ACM (PreGA v4.21) | v4.21 | release-2.16 | IDMS | 104 | 21 (20%) | 83 | 🔴 **FAILED** |
| ptp-operator (PreGA v4.21) | v4.21 | stable | IDMS | 4 | 4 (100%) | 0 | 🟢 **PASSED** |
| local-storage-operator (PreGA v4.21) | v4.21 | stable | IDMS | 4 | 4 (100%) | 0 | 🟢 **PASSED** |
| sriov-network-operator (PreGA v4.21) | v4.21 | stable | IDMS | 7 | 7 (100%) | 0 | 🟢 **PASSED** |
| cluster-logging (PreGA v4.21) | v4.21 | stable-6.4 | IDMS | 13 | 12 (92%) | 1 | 🟡 **FAILED** |
| lifecycle-agent (PreGA v4.21) | v4.21 | stable | IDMS | 3 | 3 (100%) | 0 | 🟢 **PASSED** |
| redhat-oadp-operator (PreGA v4.21) | v4.21 | stable | IDMS | 7 | 7 (100%) | 0 | 🟢 **PASSED** |
| ODF (PreGA v4.22) | v4.22 | stable-4.20 | IDMS | 29 | 23 (79%) | 6 | 🔴 **FAILED** |
| ODF (PreGA v4.22) | v4.22 | stable-4.21 | IDMS | 32 | 25 (78%) | 7 | 🔴 **FAILED** |
| ODF (PreGA v4.22) | v4.22 | stable-4.22 | IDMS | 31 | 24 (77%) | 7 | 🔴 **FAILED** |
| ACM (PreGA v4.22) | v4.22 | release-2.14 | IDMS | 97 | 15 (15%) | 82 | 🔴 **FAILED** |
| ACM (PreGA v4.22) | v4.22 | release-2.15 | IDMS | 105 | 21 (20%) | 84 | 🔴 **FAILED** |
| ACM (PreGA v4.22) | v4.22 | release-2.16 | IDMS | 105 | 21 (20%) | 84 | 🔴 **FAILED** |
| ptp-operator (PreGA v4.22) | v4.22 | stable | IDMS | 4 | 4 (100%) | 0 | 🟢 **PASSED** |
| local-storage-operator (PreGA v4.22) | v4.22 | stable | IDMS | 4 | 4 (100%) | 0 | 🟢 **PASSED** |
| sriov-network-operator (PreGA v4.22) | v4.22 | stable | IDMS | 7 | 7 (100%) | 0 | 🟢 **PASSED** |
| cluster-logging (PreGA v4.22) | v4.22 | stable-6.2 | IDMS | 13 | 12 (92%) | 1 | 🟡 **FAILED** |
| lifecycle-agent (PreGA v4.22) | v4.22 | stable | IDMS | 3 | 3 (100%) | 0 | 🟢 **PASSED** |
| redhat-oadp-operator (PreGA v4.22) | v4.22 | stable | IDMS | 7 | 7 (100%) | 0 | 🟢 **PASSED** |

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

## PreGA Release Tests (v4.22 with IDMS)

PreGA tests show missing mirrors that need to be added to the IDMS file.

### 1. ODF Operator (PreGA)

**Command:**
```bash
./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.22-20260121T101531 \
  --idms prega-idms-4.22.yaml \
  --operators odf-operator:stable-4.22
```

**Result:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  📋 Operator Image Validation Report
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  📦 Catalog:   quay.io/prega/prega-operator-index:v4.22-20260121T101531
  🔄 Mode:      IDMS Mirror Mapping
  📄 IDMS:      prega-idms-4.22.yaml (460 mappings)
  🔧 Operators: odf-operator(stable-4.22)
  📅 Date:      2026-02-01 15:57:08 UTC

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ❌ Status: FAILED

  📊 Summary:
     Total Images:     31
     ✓ Available:      24 (77.4%)
     ✗ Missing:        7 (22.6%)

  ██████████████████████████████████████████████░░░░░░░░░░░░░░ 77.4%

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ❌ Missing Images (7):

     • registry.redhat.io/openshift4/ose-kube-rbac-proxy-rhel9@sha256:883be225980cafa658d73b7d87ac99a39dce0fa8fb7754158ec28dc218bc903d
     • registry.redhat.io/openshift4/ose-oauth-proxy-rhel9@sha256:ea7466accc131798680f23c43ca1128e5683a8b21747447164124605acbef026
     • registry.redhat.io/openshift4/ose-prometheus-alertmanager-rhel9@sha256:59a82bd52f612e0931b74ab0e39b4464eadcd29fb301efcfc4aea4ac6e25f78a
     • registry.redhat.io/openshift4/ose-prometheus-config-reloader-rhel9@sha256:0bf92f64e29ca5efe44fdd04ffc34142c53099dd1d6c54e103fd85e96659438b
     • registry.redhat.io/openshift4/ose-prometheus-rhel9-operator@sha256:feb5c355d50d9f87922af2ebac547d88fd53715069568fbce3ab747ea3a4eca4
     • registry.redhat.io/openshift4/ose-prometheus-rhel9@sha256:ef0700d2eed9c28b628c7ef13a5ff36e6831dc16fed57000506daa8f64e75f01
     • registry.redhat.io/rhceph/rhceph-9-rhel9@sha256:d73121460bf5c4fe1133facf85ae76982d61eb965e403cef9fd5e991679f85e6

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  💡 Tip: Run with --output-format=remediation to generate mirror commands.
```

---

### 2. ACM Operator (PreGA)

**Command:**
```bash
./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.22-20260121T101531 \
  --idms prega-idms-4.22.yaml \
  --operators advanced-cluster-management:release-2.14
```

**Result:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  📋 Operator Image Validation Report
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  📦 Catalog:   quay.io/prega/prega-operator-index:v4.22-20260121T101531
  🔄 Mode:      IDMS Mirror Mapping
  📄 IDMS:      prega-idms-4.22.yaml (460 mappings)
  🔧 Operators: advanced-cluster-management(release-2.14)
  📅 Date:      2026-02-01 15:56:57 UTC

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ❌ Status: FAILED

  📊 Summary:
     Total Images:     97
     ✓ Available:      15 (15.5%)
     ✗ Missing:        82 (84.5%)

  █████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ 15.5%

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ❌ Missing Images (82):

     • registry.redhat.io/multicluster-engine/addon-manager-rhel9@sha256:98bf3a2f5b55ad932323a5e977f390c43835749360641798bea979f2e4052db2
     • registry.redhat.io/multicluster-engine/assisted-image-service-rhel9@sha256:5f41abafe6e982b22353fd41fe01be9da4ea480fe412124b3f88f75c69b310aa
     • registry.redhat.io/multicluster-engine/assisted-installer-agent-rhel9@sha256:bbc8bf25847bb8b18f840b56afe394b8b10f2ba874e1a65df2e11b0029321603
     • ... (82 total missing images)
```

**Note:** ACM has 82 missing images. The IDMS file needs additional mirror mappings for multicluster-engine and rhacm2 namespaces.

---

### 3. RAN Operators (PreGA)

**Command:**
```bash
./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.22-20260121T101531 \
  --idms prega-idms-4.22.yaml \
  --operators ptp-operator:stable,local-storage-operator:stable,sriov-network-operator:stable,cluster-logging:stable-6.2,lifecycle-agent:stable,redhat-oadp-operator:stable
```

**Result:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  📋 Operator Image Validation Report
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  📦 Catalog:   quay.io/prega/prega-operator-index:v4.22-20260121T101531
  🔄 Mode:      IDMS Mirror Mapping
  📄 IDMS:      prega-idms-4.22.yaml (460 mappings)
  🔧 Operators: ptp-operator(stable)
                local-storage-operator(stable)
                sriov-network-operator(stable)
                cluster-logging(stable-6.2)
                lifecycle-agent(stable)
                redhat-oadp-operator(stable)
  📅 Date:      2026-02-01 16:20:47 UTC

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ❌ Status: FAILED

  📊 Summary:
     Total Images:     38
     ✓ Available:      37 (97.4%)
     ✗ Missing:        1 (2.6%)

  ██████████████████████████████████████████████████████████░░ 97.4%

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ❌ Missing Images (1):

     • registry.redhat.io/openshift4/ose-kube-rbac-proxy-rhel9@sha256:5c4fb3049af4fc41f00eb2b4c72a42c03aa3ac689ba517ad47567e7722118fa6

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  💡 Tip: Run with --output-format=remediation to generate mirror commands.
```

---

## PreGA Release Tests (v4.21 with IDMS)

### 1. ODF Operator (PreGA v4.21)

**Command:**
```bash
./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.21-20251209T114504 \
  --idms prega-idms-4.21.yaml \
  --operators odf-operator:stable-4.21
```

**Result:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  📋 Operator Image Validation Report
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  📦 Catalog:   quay.io/prega/prega-operator-index:v4.21-20251209T114504
  🔄 Mode:      IDMS Mirror Mapping
  📄 IDMS:      prega-idms-4.21.yaml (442 mappings)
  🔧 Operators: odf-operator(stable-4.21)
  📅 Date:      2026-02-01 15:57:02 UTC

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ❌ Status: FAILED

  📊 Summary:
     Total Images:     30
     ✓ Available:      20 (66.7%)
     ✗ Missing:        10 (33.3%)

  ████████████████████████████████████████░░░░░░░░░░░░░░░░░░░░ 66.7%

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ❌ Missing Images (10):

     • registry.redhat.io/openshift4/ose-csi-external-provisioner-rhel9@sha256:591720c7e2301931e160cf1280c6b55bba9de1fe6a38545de09e05be38c50fc1
     • registry.redhat.io/openshift4/ose-csi-external-resizer-rhel9@sha256:7ff843555402276000116f7644a66ffa009933a3f9a04860dd3fa6b60385befb
     • registry.redhat.io/openshift4/ose-csi-external-snapshotter-rhel9@sha256:4cf3eca6e1f958a9b3c14cdb6be536a2b8f11491b475b23dbfee4eee8de8a60d
     • registry.redhat.io/openshift4/ose-csi-node-driver-registrar-rhel9@sha256:1c480fa5089a32cf804fc84df7219ca64066cbac2eeb962c4385754132c3873b
     • registry.redhat.io/openshift4/ose-kube-rbac-proxy-rhel9@sha256:5d7478a62742900e39d7b007dde5375cd06c6076ced6dab69d805f5fcce3f342
     • registry.redhat.io/openshift4/ose-oauth-proxy-rhel9@sha256:e945fe323ef489e0716da8839218d923e65dcf8419d7057dd4536e3a7e6b5385
     • registry.redhat.io/openshift4/ose-prometheus-alertmanager-rhel9@sha256:59cf66900a52b0a023c13c9eb0f8bc9b9a7bc35b6c8786b3155fc4f31750b8df
     • registry.redhat.io/openshift4/ose-prometheus-config-reloader-rhel9@sha256:23b45e3425b6d8f35362b4e4da5d4223c5008e4906ec60df265a953dc31c10de
     • registry.redhat.io/openshift4/ose-prometheus-rhel9-operator@sha256:1d223b2b630256baf8a73bb9fd97ce413fde7385bbe123ac4ef62e72b5fd4023
     • registry.redhat.io/openshift4/ose-prometheus-rhel9@sha256:d7b7042a608777cdc48c2d34ba5694d4724b52794cf579b37f4e3978422db9d3

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  💡 Tip: Run with --output-format=remediation to generate mirror commands.
```

---

### 2. ACM Operator (PreGA v4.21)

**Command:**
```bash
./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.21-20251209T114504 \
  --idms prega-idms-4.21.yaml \
  --operators advanced-cluster-management:release-2.16
```

**Result:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  📋 Operator Image Validation Report
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  📦 Catalog:   quay.io/prega/prega-operator-index:v4.21-20251209T114504
  🔄 Mode:      IDMS Mirror Mapping
  📄 IDMS:      prega-idms-4.21.yaml (442 mappings)
  🔧 Operators: advanced-cluster-management(release-2.16)
  📅 Date:      2026-02-01 15:56:55 UTC

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ❌ Status: FAILED

  📊 Summary:
     Total Images:     104
     ✓ Available:      21 (20.2%)
     ✗ Missing:        83 (79.8%)

  ████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ 20.2%

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ❌ Missing Images (83):

     • registry.redhat.io/multicluster-engine/addon-manager-rhel9@sha256:4e390aa09989bfa909851f24286a22a4d724951ec0225a769faaa120f3763b81
     • registry.redhat.io/multicluster-engine/assisted-image-service-rhel9@sha256:a961f144326b65383b20557f044e70e633c00135a18d15f8491246d23ff7e3e4
     • ... (83 total missing images)
```

**Note:** ACM has 83 missing images. The IDMS file needs additional mirror mappings for multicluster-engine and rhacm2 namespaces.

---

### 3. RAN Operators (PreGA v4.21)

**Command:**
```bash
./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.21-20251209T114504 \
  --idms prega-idms-4.21.yaml \
  --operators ptp-operator:stable,local-storage-operator:stable,sriov-network-operator:stable,cluster-logging:stable-6.4,lifecycle-agent:stable,redhat-oadp-operator:stable
```

**Result:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  📋 Operator Image Validation Report
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  📦 Catalog:   quay.io/prega/prega-operator-index:v4.21-20251209T114504
  🔄 Mode:      IDMS Mirror Mapping
  📄 IDMS:      prega-idms-4.21.yaml (442 mappings)
  🔧 Operators: ptp-operator(stable)
                local-storage-operator(stable)
                sriov-network-operator(stable)
                cluster-logging(stable-6.4)
                lifecycle-agent(stable)
                redhat-oadp-operator(stable)
  📅 Date:      2026-02-01 16:20:46 UTC

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ❌ Status: FAILED

  📊 Summary:
     Total Images:     38
     ✓ Available:      37 (97.4%)
     ✗ Missing:        1 (2.6%)

  ██████████████████████████████████████████████████████████░░ 97.4%

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ❌ Missing Images (1):

     • registry.redhat.io/openshift4/ose-kube-rbac-proxy-rhel9@sha256:4740dc116b2c7785ea788ceb504d44b74593633febb699f2d6d236bda58b7777

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  💡 Tip: Run with --output-format=remediation to generate mirror commands.
```

---

## Multi-Channel Test Results

### ODF Operator - All Available Channels

| Catalog | Channel | Total | Available | Missing | Status |
|---------|---------|-------|-----------|---------|--------|
| GA v4.20 | stable-4.19 | 28 | 28 (100%) | 0 | 🟢 **PASSED** |
| GA v4.20 | stable-4.20 | 28 | 28 (100%) | 0 | 🟢 **PASSED** |
| PreGA v4.21 | stable-4.21 | 30 | 20 (67%) | 10 | 🔴 **FAILED** |
| PreGA v4.22 | stable-4.20 | 29 | 23 (79%) | 6 | 🔴 **FAILED** |
| PreGA v4.22 | stable-4.21 | 32 | 25 (78%) | 7 | 🔴 **FAILED** |
| PreGA v4.22 | stable-4.22 | 31 | 24 (77%) | 7 | 🔴 **FAILED** |

### ACM Operator - All Available Channels

| Catalog | Channel | Total | Available | Missing | Status |
|---------|---------|-------|-----------|---------|--------|
| GA v4.20 | release-2.14 | 96 | 96 (100%) | 0 | 🟢 **PASSED** |
| GA v4.20 | release-2.15 | 104 | 104 (100%) | 0 | 🟢 **PASSED** |
| PreGA v4.21 | release-2.16 | 104 | 21 (20%) | 83 | 🔴 **FAILED** |
| PreGA v4.22 | release-2.14 | 97 | 15 (15%) | 82 | 🔴 **FAILED** |
| PreGA v4.22 | release-2.15 | 105 | 21 (20%) | 84 | 🔴 **FAILED** |
| PreGA v4.22 | release-2.16 | 105 | 21 (20%) | 84 | 🔴 **FAILED** |

### Key Findings

- **GA releases (v4.20)**: All channels pass with 100% image availability
- **PreGA ODF**: Approximately 67-79% availability across all channels - missing mostly OpenShift CSI/Prometheus components
- **PreGA ACM**: Only ~15-20% availability - significant gaps in multicluster-engine and rhacm2 namespace images

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
  --catalog quay.io/prega/prega-operator-index:v4.21-20251209T114504 \
  --idms prega-idms-4.21.yaml \
  --operators odf-operator:stable-4.21

# PreGA v4.21 - ACM
./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.21-20251209T114504 \
  --idms prega-idms-4.21.yaml \
  --operators advanced-cluster-management:release-2.16

# PreGA v4.21 - RAN (includes lifecycle-agent and OADP)
./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.21-20251209T114504 \
  --idms prega-idms-4.21.yaml \
  --operators ptp-operator:stable,local-storage-operator:stable,sriov-network-operator:stable,cluster-logging:stable-6.4,lifecycle-agent:stable,redhat-oadp-operator:stable

# PreGA v4.22 - ODF (all channels)
./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.22-20260121T101531 \
  --idms prega-idms-4.22.yaml \
  --operators odf-operator:stable-4.20

./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.22-20260121T101531 \
  --idms prega-idms-4.22.yaml \
  --operators odf-operator:stable-4.21

./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.22-20260121T101531 \
  --idms prega-idms-4.22.yaml \
  --operators odf-operator:stable-4.22

# PreGA v4.22 - ACM (all channels)
./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.22-20260121T101531 \
  --idms prega-idms-4.22.yaml \
  --operators advanced-cluster-management:release-2.14

./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.22-20260121T101531 \
  --idms prega-idms-4.22.yaml \
  --operators advanced-cluster-management:release-2.15

./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.22-20260121T101531 \
  --idms prega-idms-4.22.yaml \
  --operators advanced-cluster-management:release-2.16

# PreGA v4.22 - RAN (includes lifecycle-agent and OADP)
./operator-images-validator.sh validate \
  --catalog quay.io/prega/prega-operator-index:v4.22-20260121T101531 \
  --idms prega-idms-4.22.yaml \
  --operators ptp-operator:stable,local-storage-operator:stable,sriov-network-operator:stable,cluster-logging:stable-6.2,lifecycle-agent:stable,redhat-oadp-operator:stable
```
