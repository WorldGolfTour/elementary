{# Call a Snowflake stored procedure to send Elementary alerts to Slack.
   Runs as an on-run-end hook during Snowflake EXECUTE DBT PROJECT builds.
   Enable by setting vars in the consumer project's dbt_project.yml:
     elementary_slack_alert_enabled: true
     elementary_slack_alert_procedure: "DB.SCHEMA.SEND_ELEMENTARY_SLACK_ALERT"
#}
{% macro send_slack_alert() %}
  {% set enabled = var('elementary_slack_alert_enabled', false) %}
  {% set proc = var('elementary_slack_alert_procedure', '') %}
  {% if enabled and proc %}
    {% set inv = invocation_id %}
    {% set tgt = target.name %}
    {{ return("CALL " ~ proc ~ "('" ~ inv ~ "', '" ~ tgt ~ "');") }}
  {% else %}
    {{ return("SELECT 1 AS elementary_slack_alert_skipped") }}
  {% endif %}
{% endmacro %}
