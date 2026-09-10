# 07 — Research Timeline

## Phase 1 — Database discovery

The first phase focused on locating licensing data inside the bundled PostgreSQL database.

Work performed:

- confirmed the ServiceDesk PostgreSQL environment;
- enumerated databases, users and extensions;
- searched schema names/columns containing licensing, expiry and validity concepts;
- inspected `licensekey`, `license_upgrade`, `licenseagreement`, `licenseorderhistory` and related tables;
- compared results across `postgres` and `sdpadmin` where permissions mattered.

Key result:

The obvious product-license tables did not expose a simple populated evaluation-expiry record in the captured test state.

## Phase 2 — Query telemetry

Because schema discovery alone could not prove which tables were active in the runtime path, `pg_stat_statements` was introduced.

Work performed:

- enabled/verified relevant extensions;
- investigated reset permissions;
- created before/after snapshots;
- compared `calls`, `rows` and execution-time deltas;
- observed background TaskEngine/Scheduled_Task activity.

Key result:

SQL telemetry was useful for ruling in/out runtime database activity, but it did not reveal a single database-only evaluation authority.

## Phase 3 — Runtime logs

Startup and runtime logs were searched for licensing terminology and class-associated messages.

Observed examples:

```text
licenseTo : Evaluation User
Executing License Expire Notification in thread : ...
```

Key result:

The product independently exposed an evaluation identity and a scheduled license-expiry workflow.

## Phase 4 — Java class mapping

The next phase mapped Java classes and methods related to evaluation state without redistributing proprietary code.

Classes repeatedly investigated:

```text
Indication
Vendee
Wield
Validation
Clientele
ThreadWorn
User
SDPStarter
LicenseExpire
LicenseExpireTask
```

Important method/field concepts observed:

```text
getEvaluationExpiryDate
getEvalExpiryDate
getTheLastAccessedDate
lastAccessedString
expiryDate
evalExpiryDate
serialize
deSerialize
getLicenseType
getExpiryDate
```

Key result:

A multi-class evaluation state graph became visible, centered around persisted indication state and higher-level validation/accessor classes.

## Phase 5 — Filesystem correlation

The investigation then correlated Java observations with on-disk state.

Tracked files:

```text
AdventNetLicense.xml
ExpiredLicense.xml
petinfo.dat
product.dat
```

Hash and timestamp comparisons were used to determine whether state changed across runtime windows.

Key result:

`AdventNetLicense.xml` and `ExpiredLicense.xml` were byte-identical in one snapshot, while `petinfo.dat` showed evidence of changing state across observations.

## Current phase — Causal mapping

The remaining research problem is to determine, using safe observation only, which transitions cause which components to read or update state.

The project is therefore moving from:

```text
"Where are license-looking things?"
```

to:

```text
"Which component reads which state at which point in the lifecycle?"
```

That distinction is essential for accurately documenting the architecture without turning the project into a circumvention guide.
