# 01 — Environment

## Product context

Observed installation root:

```text
C:\Program Files\ManageEngine\ServiceDesk
```

The investigation was performed on a locally controlled ServiceDesk Plus installation and focused on the application's bundled PostgreSQL database, startup/runtime logs, license-related files, and Java classes used by the licensing subsystem.

## Database environment

Observed PostgreSQL characteristics:

| Property | Observed value |
|---|---|
| Database engine | PostgreSQL |
| Version | 15.14 |
| Architecture | 64-bit |
| Product database | `servicedesk` |
| Local host | `127.0.0.1` / `localhost` |
| Port | `65432` |
| Application DB user observed in startup logs | `sdpadmin` |
| Bundled data directory | `C:\Program Files\ManageEngine\ServiceDesk\pgsql\data` |

Observed JDBC pattern:

```text
jdbc:postgresql://localhost:65432/servicedesk
```

The application startup logs explicitly showed the bundled PostgreSQL adapter checking the database and invoking `psql` using `sdpadmin`.

## PostgreSQL extensions

During the wider investigation the following extensions were observed in the environment:

```text
citext
pg_stat_statements
pg_trgm
pgadmin
pgcrypto
plpgsql
```

Startup logs also showed ServiceDesk attempting to create `pg_stat_statements` and `pg_trgm` when needed.

## Important filesystem surfaces

Observed files included:

```text
ServiceDesk\
├── lib\
│   ├── AdventNetLicense.xml
│   ├── petinfo.dat
│   └── product.dat
├── licenses\
│   └── expiredlicense\
│       └── ExpiredLicense.xml
├── logs\
│   └── serverout*.txt
└── pgsql\
    └── data\
```

The investigation treats these as **evidence surfaces**, not automatically as independent sources of truth.

## Java / application layer

The licensing investigation repeatedly encountered classes in the `com.adventnet.tools.prevalent` namespace and ServiceDesk-specific expiry task classes.

Key names documented in this repository:

```text
com.adventnet.tools.prevalent.Indication
com.adventnet.tools.prevalent.Vendee
com.adventnet.tools.prevalent.Wield
com.adventnet.tools.prevalent.Validation
com.adventnet.tools.prevalent.Clientele
com.adventnet.tools.prevalent.ThreadWorn
com.adventnet.tools.prevalent.User
com.adventnet.servicedesk.task.LicenseExpire
com.adventnet.servicedesk.task.LicenseExpireTask
SDPStarter
```

Only class/method relationships and summarized behavior are documented. Proprietary binaries and full decompile dumps are intentionally excluded.

## Research account discipline

PostgreSQL observations were compared using two identities where relevant:

1. `postgres`
2. `sdpadmin`

Results should be labeled by the account that produced them because permissions and visible telemetry can differ even against the same database server.
