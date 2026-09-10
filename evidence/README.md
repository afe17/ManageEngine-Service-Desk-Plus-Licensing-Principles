# Evidence Directory

This directory is reserved for **sanitized, non-proprietary research evidence**.

## Allowed evidence

- redacted log excerpts;
- file metadata and hashes;
- schema summaries;
- read-only SQL result summaries;
- class/method call notes;
- diagrams created by the researcher;
- timestamps and controlled observation records.

## Do not commit

```text
*.jar
*.class
vendor binaries
full decompile dumps
real license keys
passwords / tokens
customer data
modified license files
license-bypass patches
```

## Suggested naming convention

```text
YYYY-MM-DD_<plane>_<short-description>.md
```

Examples:

```text
2026-09-10_filesystem_hash-snapshot.md
2026-09-10_postgres_startup-delta.md
2026-09-10_java_indication-call-map.md
```

## Evidence record template

```markdown
# Observation title

- Date/time:
- Product build:
- Evidence plane:
- Account/context:

## Observation

...

## What this proves

...

## What this does not prove

...

## Confidence

Confirmed / Strong indicator / Hypothesis

## Next read-only test

...
```
