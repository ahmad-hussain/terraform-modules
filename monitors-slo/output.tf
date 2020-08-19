output "uptime_slo_id" {
    value = var.create_datadog ? datadog_service_level_objective.uptime_slo[0].id : "no id"
}

output "response_slo_id" {
    value = var.create_datadog ? datadog_service_level_objective.response_slo[0].id : "no id"
}
