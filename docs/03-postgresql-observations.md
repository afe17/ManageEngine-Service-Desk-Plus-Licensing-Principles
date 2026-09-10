# 03 — PostgreSQL Observations

## Why PostgreSQL was investigated

ServiceDesk Plus includes a bundled PostgreSQL instance. Because products frequently persist licensing metadata, organization state, scheduled jobs and runtime state in relational storage, the first hypothesis was that evaluation expiry might be represented directly in one or more database tables.

The database investigation therefore had two goals:

1. inventory fields and tables that *look* licensing-related;
2. observe which SQL statements are actually executed while the product starts and runs.

## Environment confirmed from logs

Observed startup information:

```text
PostgreSQL version: 15.14
Architecture: 64-bit
Database: servicedesk
Host: localhost / 127.0.0.1
Port: 65432
Application DB identity observed: sdpadmin
Data directory: C:\Program Files\ManageEngine\ServiceDesk\pgsql\data
```

Startup logs also showed the product checking/creating `pg_stat_statements` and `pg_trgm` extensions.

## Licensing-related schema inventory

Tables identified during schema discovery included:

```text
licensekey
license_upgrade
licenseagreement
licenseorderhistory
licensereminder
licenserenewalhistory
licenseallocationhistory
licensestatus
```

Additional product tables contain the word `license` but belong to software-asset or cloud-license management rather than necessarily to the ServiceDesk product entitlement itself. Name matching alone was therefore not treated as proof.

### `licensekey`

Relevant observed fields include:

```text
licenseid
org_id
license_type
product_type
product_name
no_of_users
no_of_ws
islocalized
expiry_date
instance_id
comments
```

The table is structurally capable of storing expiry and entitlement metadata.

### `license_upgrade`

Observed fields include:

```text
added_time
modified_time
old_license
new_license
old_license_backp_path
trial_status
data_json
```

This appears suited to upgrade/migration history and packaged license data, rather than proving it is the active evaluation clock.

### `licenseagreement` / `licenseorderhistory`

Expiry-like fields were observed, including:

```text
licenseagreement.expirydate
licenseorderhistory.subscription_expirydate
```

These tables are important to inventory but their business meaning may be different from the core application's evaluation expiry.

## Early count observations

During the first targeted checks, the main product-license tables under investigation returned zero records in the test environment, including the core set:

```text
licensekey
license_upgrade
licenseagreement
licenseorderhistory
adslicpromotionsettings
adslicpromotionparams
```

This was an important negative result: the running installation could still identify itself as an `Evaluation User` even though these obvious tables did not provide a simple active-license row to explain that state.

**Interpretation:** evaluation state is unlikely to be explained exclusively by those database rows.

## Query telemetry with `pg_stat_statements`

`pg_stat_statements` was introduced to answer a stronger question:

> Which SQL statements are actually executed around startup and runtime events?

The investigation encountered several operational details:

- the extension/relation was initially unavailable in some contexts;
- attempts to invoke `pg_stat_statements_reset` as a less-privileged identity produced permission/function-resolution issues;
- after extension setup, the reset function was visible but execution permission differed by account;
- before/after snapshots were therefore used to compare deltas without assuming reset capability.

This led to the use of a snapshot-table approach (for example `sdp_stat_before`) and comparison of:

```text
calls
rows
total_exec_time
```

The resulting deltas exposed normal application traffic such as `TaskEngine_Task` and `Scheduled_Task` activity. This helped distinguish background scheduler traffic from licensing-specific SQL.

## Important methodological conclusion

A SQL query appearing in `pg_stat_statements` proves that SQL was executed; it does **not** prove the query is the authoritative licensing decision point.

Likewise, a licensing-related table being empty does not prove the database is irrelevant. The database still participates in:

- organization/business licensing metadata;
- scheduler persistence;
- application configuration;
- runtime state and general ServiceDesk operation.

## Current conclusion

| Question | Current assessment |
|---|---|
| Does PostgreSQL contain licensing-related schema? | **Confirmed** |
| Can `licensekey` store an expiry? | **Confirmed** |
| Were obvious licensing tables populated in the initial evaluation investigation? | **No / observed empty in that test state** |
| Is evaluation identity visible elsewhere while those tables are empty? | **Yes** |
| Is PostgreSQL alone proven to be the evaluation expiry authority? | **No** |
| Is PostgreSQL still relevant to the overall licensing/runtime topology? | **Yes** |

The database phase redirected the research toward the file-backed and Java `prevalent` layers rather than supporting a simple "change one expiry column" model.
