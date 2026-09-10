# 06 — Findings Matrix

Bu sayfa, araştırmadaki gözlemleri kanıt gücüne göre ayırır.

| ID | Finding | Evidence plane | Confidence | Notes |
|---|---|---|---|---|
| F-01 | ServiceDesk bundled PostgreSQL uses version 15.14 / 64-bit in the observed build | Runtime log | Confirmed | Startup log explicitly reported DB version and architecture |
| F-02 | ServiceDesk connects locally to `servicedesk` on port `65432` | Runtime log | Confirmed | JDBC / psql startup command observed |
| F-03 | `sdpadmin` is used by ServiceDesk database startup routines | Runtime log | Confirmed | `psql -U sdpadmin ...` observed |
| F-04 | Product schema contains several licensing-related tables | PostgreSQL schema | Confirmed | `licensekey`, `license_upgrade`, `licenseagreement`, etc. observed |
| F-05 | `licensekey` contains expiry/type/user/workstation/org metadata fields | PostgreSQL schema | Confirmed | columns directly enumerated |
| F-06 | Core license tables were empty in the initial evaluation-focused checks | PostgreSQL data | Confirmed for observed test state | Negative result applies only to that captured state |
| F-07 | Application still identified itself as `Evaluation User` while obvious core tables were not a simple active source | Runtime log + DB | Strong indicator | Suggests evaluation identity is not exclusively represented by those rows |
| F-08 | `AdventNetLicense.xml`, `ExpiredLicense.xml`, `petinfo.dat`, `product.dat` exist in license/product-related filesystem locations | Filesystem | Confirmed | paths, size and timestamps captured |
| F-09 | `AdventNetLicense.xml` and `ExpiredLicense.xml` had identical SHA-256 in one snapshot | Filesystem hash | Confirmed | Means byte-identical at that moment only |
| F-10 | `petinfo.dat` changed across observation windows | Filesystem metadata/hash | Confirmed | Supports role as mutable state surface |
| F-11 | `Indication` exposes evaluation metadata and serialization/deserialization methods | Java bytecode symbols | Confirmed | `evalExpiryDate`, `serialize`, `deSerialize`, `getEvalExpiryDate` observed |
| F-12 | `Vendee` exposes `lastAccessedString` and `expiryDate` via getters | Java bytecode | Confirmed | getters return backing fields directly |
| F-13 | Multiple wrapper/validation classes expose or call `getEvaluationExpiryDate()` | Java call graph | Confirmed | Wield, ThreadWorn, Clientele, Validation, Vendee observed |
| F-14 | `SDPStarter` reads `User.getExpiryDate()` and `User.getLicenseType()` and compares against `Evaluation` | Java bytecode | Confirmed | startup control flow observed |
| F-15 | `LicenseExpireTask` exists and logs expiry-notification execution | Java + runtime log | Confirmed | ServiceDesk TaskEngine component observed |
| F-16 | `pg_stat_statements` is useful for startup/runtime SQL deltas but account permissions affect reset capability | PostgreSQL telemetry | Confirmed | permission/function-resolution differences observed |
| F-17 | Evaluation state is likely implemented across file + Java runtime + scheduler layers rather than one SQL field | Cross-layer synthesis | Strong indicator | Supported by F-06 through F-15 |
| F-18 | A single final authoritative licensing-enforcement function has been isolated | — | Not established | Still open |

## What we should not infer

The following conclusions are **not** justified by the evidence collected so far:

- "Changing `licensekey.expiry_date` changes the evaluation period."
- "`ExpiredLicense.xml` is trusted without validation."
- "`petinfo.dat` alone determines the license state."
- "`LicenseExpireTask` is the original license validator."
- "Any one `getEvaluationExpiryDate()` getter is the final entitlement decision."

These would require stronger causal experiments and are intentionally not treated as established facts.
