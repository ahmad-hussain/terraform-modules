resource "datadog_monitor" "uptime" {
    count = var.create_datadog ? 1 : 0
    name = "${var.apm_name} Uptime Monitor"
    type = "query alert"
    query = "sum(last_10m):sum:trace.http.request.hits.by_http_status{http.status_class:2xx,env:prod,service:${var.apm_name}}.as_count()/sum:trace.http.request.hits{env:prod,service:${var.apm_name}}.as_count() * 100 < ${var.critical_uptime}"
    message = <<EOF

    {{#is_alert}}
    {{#is_exact_match "env.name" "prod"}}
    {{${var.apm_name}}} bruh
    @slack-<name>-${var.owner}-team-monitor-alerts
    {{/is_exact_match}}

    {{#is_exact_match "env.name" "sandbox"}}
    {{${var.apm_name}}} bruh
    @slack-<name>-${var.owner}-team-monitor-alerts
    {{/is_exact_match}}

    {{#is_exact_match "env.name" "staging"}}
    {{${var.apm_name}}} bruh
    @slack-<name>-${var.owner}-team-monitor-alerts
    {{/is_exact_match}}
    {{/is_alert}}



    {{#is_warning}}
    {{#is_exact_match "env.name" "prod"}}
    {{${var.apm_name}}} bruh
    @slack-<name>-${var.owner}-team-monitor-alerts
    {{/is_exact_match}}

    {{#is_exact_match "env.name" "sandbox"}}
    {{${var.apm_name}}} bruh
    @slack-<name>-${var.owner}-team-monitor-alerts
    {{/is_exact_match}}

    {{#is_exact_match "env.name" "staging"}}
    {{${var.apm_name}}} bruh
    @slack-<name>-${var.owner}-team-monitor-alerts
    {{/is_exact_match}}
    {{/is_warning}}


    {{#is_recovery}}
    {{#is_exact_match "env.name" "prod"}}
    @slack-<name>-${var.owner}-team-monitor-alerts
    {{/is_exact_match}}

    {{#is_exact_match "env.name" "sandbox"}}
    @slack-<name>-${var.owner}-team-monitor-alerts
    {{/is_exact_match}}

    {{#is_exact_match "env.name" "staging"}}
    @slack-<name>-${var.owner}-team-monitor-alerts
    {{/is_exact_match}}
    {{/is_recovery}}
    EOF
    tags = ["service:${var.apm_name}","env:prod"]
    notify_audit = false
    locked = true
    include_tags = true
    thresholds = {
        warning = var.warning_uptime
        warning_recovery = var.warning_recovery_uptime
        critical = var.critical_uptime
        critical_recovery = var.critical_recovery_uptime
    }
    new_host_delay = 300
    notify_no_data = false
    escalation_message = "bruh"
}

resource "datadog_service_level_objective" "uptime_slo" {
  count = var.create_datadog ? 1 : 0
  name        = "${var.apm_name} Uptime SLO"
  type        = "monitor"
  description = "TF: ${var.apm_name} uptime"
  monitor_ids = [datadog_monitor.uptime[count.index].id]

  thresholds {
    timeframe = var.timeframe_uptime
    target    = var.target_uptime
    warning   = var.warning_uptime
  }

  tags = ["env:prod", "service:${var.apm_name}"]
}


resource "datadog_monitor" "response_time" {
  count = var.create_datadog ? 1 : 0
  name = "${var.apm_name} Response Time Monitor"
  type = "query alert"
  query = "avg(last_5m):avg:trace.http.request.duration.by.service.95p{env:prod,service:${var.apm_name}} > ${var.critical_response}"
  message = <<EOF
  {{#is_alert}}
  {{#is_exact_match "env.name" "prod"}}
  {{${var.apm_name}}} bruh
  @slack-<name>-${var.owner}-team-monitor-alerts
  {{/is_exact_match}}

  {{#is_exact_match "env.name" "sandbox"}}
  {{${var.apm_name}}} bruh
  @slack-<name>-${var.owner}-team-monitor-alerts
  {{/is_exact_match}}

  {{#is_exact_match "env.name" "staging"}}
  {{${var.apm_name}}} bruh
  @slack-<name>-${var.owner}-team-monitor-alerts
  {{/is_exact_match}}
  {{/is_alert}}


  {{#is_warning}}
  {{#is_exact_match "env.name" "prod"}}
  {{${var.apm_name}}} bruh
  @slack-<name>-${var.owner}-team-monitor-alerts
  {{/is_exact_match}}

  {{#is_exact_match "env.name" "sandbox"}}
  {{${var.apm_name}}} bruh
  @slack-<name>-${var.owner}-team-monitor-alerts
  {{/is_exact_match}}

  {{#is_exact_match "env.name" "staging"}}
  {{${var.apm_name}}} bruh
  @slack-<name>-${var.owner}-team-monitor-alerts
  {{/is_exact_match}}
  {{/is_warning}}


  {{#is_recovery}}
  {{#is_exact_match "env.name" "prod"}}
  @slack-<name>-${var.owner}-team-monitor-alerts
  {{/is_exact_match}}

  {{#is_exact_match "env.name" "sandbox"}}
  @slack-<name>-${var.owner}-team-monitor-alerts
  {{/is_exact_match}}

  {{#is_exact_match "env.name" "staging"}}
  @slack-<name>-${var.owner}-team-monitor-alerts
  {{/is_exact_match}}
  {{/is_recovery}}
  EOF
  tags = ["env:prod","service:${var.apm_name}"]
  notify_audit = false
  locked = true
  include_tags = true
  thresholds = {
      warning = var.warning_response
      warning_recovery = var.warning_recovery_response
      critical = var.critical_response
      critical_recovery = var.critical_recovery_response
  }
  new_host_delay = 300
  require_full_window = true
  notify_no_data = false
  escalation_message = "bruh"
}

resource "datadog_service_level_objective" "response_slo" {
  count = var.create_datadog ? 1 : 0
  name        = "${var.apm_name} Response Time SLO"
  type        = "monitor"
  description = "TF: ${var.apm_name} response time"
  monitor_ids = [datadog_monitor.response_time[count.index].id]

  thresholds {
    timeframe = var.timeframe_response
    target    = var.target_response
    warning   = var.warning_recovery_response
  }

  tags = ["env:prod", "service:${var.apm_name}"]
}

module "service_dashboards" {
  source = "../dashboards/service-dashboards"
  create_datadog = var.create_datadog
  DATADOG_API_KEY = var.DATADOG_API_KEY
  DATADOG_APP_KEY = var.DATADOG_APP_KEY
  apm_name = var.apm_name
  uptime_slo_id = module.monitors_slos.uptime_slo_id
  response_slo_id = module.monitors_slos.response_slo_id
  ok_uptime = target_uptime
  error_uptime = critical_uptime
  ok_response = target_response
  error_response = critical_response
}
