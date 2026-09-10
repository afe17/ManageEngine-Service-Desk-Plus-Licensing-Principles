-- ManageEngine ServiceDesk Plus licensing research
-- EDUCATIONAL / DEFENSIVE / READ-ONLY OBSERVATION SCRIPT
--
-- This script intentionally contains SELECT-only observations.
-- It does not modify licensing state, reset trials, patch data, or alter product behavior.

SELECT
    current_user,
    session_user,
    current_database(),
    inet_server_addr(),
    inet_server_port(),
    version();

-- Installed extensions
SELECT extname, extversion
FROM pg_extension
ORDER BY extname;

-- License-related relations visible in the current database
SELECT
    table_schema,
    table_name
FROM information_schema.tables
WHERE table_schema NOT IN ('pg_catalog', 'information_schema')
  AND lower(table_name) LIKE '%license%'
ORDER BY table_schema, table_name;

-- License/expiry/validity-looking columns for inventory only.
SELECT
    table_schema,
    table_name,
    column_name,
    data_type
FROM information_schema.columns
WHERE table_schema NOT IN ('pg_catalog', 'information_schema')
  AND (
      lower(table_name) LIKE '%license%'
      OR lower(column_name) LIKE '%license%'
      OR lower(column_name) LIKE '%expiry%'
      OR lower(column_name) LIKE '%valid%'
  )
ORDER BY table_schema, table_name, ordinal_position;

-- Presence checks for the core tables investigated in this project.
SELECT to_regclass('public.licensekey')           AS licensekey,
       to_regclass('public.license_upgrade')      AS license_upgrade,
       to_regclass('public.licenseagreement')     AS licenseagreement,
       to_regclass('public.licenseorderhistory')  AS licenseorderhistory;

-- Run the following only when the corresponding relation exists.
-- These are counts, not content dumps.
SELECT COUNT(*) AS licensekey_rows FROM public.licensekey;
SELECT COUNT(*) AS license_upgrade_rows FROM public.license_upgrade;
SELECT COUNT(*) AS licenseagreement_rows FROM public.licenseagreement;
SELECT COUNT(*) AS licenseorderhistory_rows FROM public.licenseorderhistory;

-- Read-only pg_stat_statements inspection. Do not assume reset permission.
SELECT
    calls,
    rows,
    round(total_exec_time::numeric, 3) AS total_exec_ms,
    left(query, 300) AS query_sample
FROM public.pg_stat_statements
WHERE lower(query) ~ '(license|evaluation|scheduled_task|taskengine)'
ORDER BY calls DESC, total_exec_time DESC
LIMIT 100;
