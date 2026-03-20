# elementary (org fork)

Fork of [elementary-data/elementary](https://github.com/elementary-data/elementary) v0.23.0 with Snowflake-focused customizations.

## What's different from upstream

- **Snowflake namespace fixes** — all unqualified macro calls patched with `elementary.` prefix so they resolve correctly under Snowflake's `EXECUTE DBT PROJECT` runtime.
- **Slack alert hook** (`macros/wgt/send_slack_alert.sql`) — an `on-run-end` hook that calls a Snowflake stored procedure to post test-failure summaries to Slack. Opt-in via vars.
- **Nested deps for Snowflake** — `packages.yml` pins `dbt_utils` via `git` + `revision` (Hub `package:` entries fail Snowflake’s dbt compile validator).
- **Trimmed CI/test scaffolding** — removed `.github/`, `integration_tests/`, and dev tooling to keep `dbt deps` clones fast.

## Usage

In your dbt project's `packages.yml`:

```yaml
packages:
  - git: "https://github.com/<org>/elementary.git"
    revision: v0.23.0-org.1
```

Then:

```bash
dbt deps
dbt run --select elementary
```

### Enabling Slack alerts

Add these vars to your `dbt_project.yml`:

```yaml
vars:
  elementary_slack_alert_enabled: true
  elementary_slack_alert_procedure: "DB.SCHEMA.SEND_ELEMENTARY_SLACK_ALERT"
```

The hook runs automatically via `on-run-end`. When disabled (the default), it's a no-op.

## Updating from upstream

```bash
git remote add upstream https://github.com/elementary-data/elementary.git
git fetch upstream
git merge upstream/master
# resolve conflicts, re-apply namespace fixes if overwritten, tag a new release
git tag v0.X.Y-org.N
git push origin master --tags
```

