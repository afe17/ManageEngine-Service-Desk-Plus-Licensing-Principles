# 00 — Scope and Ethics

## Research statement

This repository documents an independent, educational analysis of the licensing architecture observed in a locally controlled ManageEngine ServiceDesk Plus test environment.

The goal is to understand **software design principles** around evaluation state, licensing metadata, persistence, scheduled expiry handling, runtime validation, and observability.

It is **not** a guide to bypass licensing, extend an evaluation without authorization, forge license files, patch validation logic, or unlock paid functionality.

## Questions we are trying to answer

1. Which storage surfaces contain licensing-related metadata?
2. Which Java classes participate in reading and interpreting that metadata?
3. What happens during ServiceDesk startup?
4. What scheduled tasks are related to license expiration?
5. Which findings are database-backed, file-backed, runtime-backed, or only inferred from symbols?
6. How can these layers be documented in a reproducible, read-only way?

## Evidence handling

We do **not** publish:

- proprietary binaries or JARs;
- full decompiled source/bytecode dumps;
- real customer data;
- license keys, secrets, passwords or tokens;
- altered license material;
- bypass patches or operational circumvention instructions.

Instead, this repository preserves:

- method/class names;
- table/column names;
- sanitized query patterns;
- hashes and timestamps where useful;
- high-level control-flow diagrams;
- summarized observations.

## Confidence labels

| Label | Meaning |
|---|---|
| Confirmed | Directly observed in schema, logs, filesystem metadata, hash output or bytecode symbol/call output. |
| Strong indicator | Supported by multiple observations, but the final decision point has not been isolated. |
| Hypothesis | A working model that requires additional observation. |

## Safety boundary

Experiments should be performed only on systems the researcher owns or is explicitly authorized to test. Any future experiment added to this repository should preserve the read-only/default-safe posture unless separately justified and legally authorized.
