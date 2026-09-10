# 05 — File and Log Observations

## License-related filesystem inventory

Observed paths:

```text
C:\Program Files\ManageEngine\ServiceDesk\lib\AdventNetLicense.xml
C:\Program Files\ManageEngine\ServiceDesk\lib\petinfo.dat
C:\Program Files\ManageEngine\ServiceDesk\lib\product.dat
C:\Program Files\ManageEngine\ServiceDesk\licenses\expiredlicense\ExpiredLicense.xml
```

At one observation point, the following metadata was captured:

| File | Size | Observation |
|---|---:|---|
| `AdventNetLicense.xml` | 1,876 bytes | license XML under `lib` |
| `petinfo.dat` | 4,044 bytes | changed during later runtime observations |
| `product.dat` | 619 bytes | product metadata file |
| `ExpiredLicense.xml` | 1,876 bytes | stored under `licenses\expiredlicense` |

## SHA-256 correlation

One captured snapshot produced:

```text
AdventNetLicense.xml
1227E69E1B4D64CB91D77DF0AC97F8871C0402604C04BF83ABEE3ABFFDEFB0D7

ExpiredLicense.xml
1227E69E1B4D64CB91D77DF0AC97F8871C0402604C04BF83ABEE3ABFFDEFB0D7

product.dat
227D7485B4A5A5D050EB9B7FAD8812F248A6768CCEC5300B968077B526B68E18
```

`AdventNetLicense.xml` and `ExpiredLicense.xml` therefore matched byte-for-byte at that observation point.

### Interpretation boundary

This proves only that the two files were identical at that time. It does **not** prove:

- which file was the original source;
- which one is authoritative;
- whether either file alone controls entitlement;
- whether the application trusts an unvalidated file copy.

## `petinfo.dat` as a changing state surface

Across captures, `petinfo.dat` was observed with different timestamps/hash values. That makes it especially interesting as a state-bearing artifact.

This aligns with Java-layer observations around `Indication.serialize()` / `deSerialize()` and product/evaluation metadata, but the precise encoding and trust model should be treated as a separate research question.

The repository deliberately does not publish modified `petinfo.dat` material or instructions to alter it.

## Runtime log observations

Targeted searches in `serverout*.txt` returned licensing-related messages such as:

```text
licenseTo : Evaluation User
Executing License Expire Notification in thread : ...
```

The expiry notification message was associated with:

```text
com.adventnet.servicedesk.task.LicenseExpireTask
```

The log corpus also contains many unrelated strings containing the word `Validation`. These should not be confused with licensing validation merely because the term overlaps.

## Startup correlation strategy

A useful observation window is:

```text
T-1: capture hashes/timestamps
T0 : start ServiceDesk
T1 : capture startup log lines
T2 : capture hashes/timestamps again
T3 : capture pg_stat_statements delta
```

Then correlate:

```text
file changed?
    + Java class was invoked?
    + log event occurred?
    + SQL delta appeared?
```

The more independent planes line up, the stronger the architectural inference.

## Current conclusion

The filesystem evidence strongly supports a file-backed licensing/product metadata layer alongside the Java `prevalent` classes. Runtime logs independently confirm that the process identifies an evaluation user and executes an expiry-related scheduled workflow.

The evidence does **not** support reducing the mechanism to a single editable XML or `.dat` file.
