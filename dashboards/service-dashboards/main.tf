resource "datadog_dashboard" "free_dashboard" {
    count = var.create_datadog ? 1 : 0
    title = "${var.apm_name} Service Dashboard"
    description = var.description
    is_read_only = true
    layout_type = "free"

    widget {
        free_text_definition {
            color = "#4d4d4d"
            font_size = "36"
            text = "${var.apm_name}  Service Health Board"
            text_align = "left"
        }
        layout = {
            height = 3
            width = 23
            x = 38
            y = 2
        }
    }

    widget {
        query_value_definition {
            request {
                aggregator = "avg"
                q = "avg:trace.http.request.duration.by.service.50p{$Environment,service:${var.apm_name}}"
            conditional_formats {
                comparator = ">"
                palette = "white_on_red"
                value = "${var.error_response}"
            }
            conditional_formats {
                comparator = ">="
                palette = "white_on_yellow"
                value = "${var.ok_response}"
            }
            conditional_formats  {
                comparator = "<"
                palette = "white_on_green"
                value = "${var.ok_response}"
            }
            }
            autoscale = true
            precision = 2
            title = "50p"
            title_align = "left"
            title_size = "16"
        }
        layout = {
            height = 8
            width = 12
            x = 12
            y = 0
        }
    }

    widget {
        timeseries_definition {
            request {
                q = "sum:trace.http.request.hits.by_http_status{http.status_class:2xx,$Environment,service:${var.apm_name}}.as_count()/sum:trace.http.request.hits{$Environment,service:${var.apm_name}}.as_count()*100"
                display_type = "line"
                style {
                    palette = "dog_classic"
                    line_type = "solid"
                    line_width = "normal"
                }
            }
            yaxis {
                min = 90
                max = 101
                include_zero = true
            }
            marker {
                display_type = "ok dashed"
                value = "y > ${var.ok_uptime}"
            }
            marker {
                display_type = "warning dashed"
                value = "${var.error_uptime} < y < ${var.ok_uptime}"
            }
            marker {
                display_type = "error dashed"
                value = "y < ${var.error_uptime}"
            }

            title = "Uptime"
            title_align = "left"
            title_size = "16"
            show_legend = true
        }
        layout = {
            height = 20
            width = 53
            x = 0
            y = 10
        }
    }

    widget {
        timeseries_definition {
            request {
                q = "avg:trace.http.request.duration.by.service.50p{$Environment,service:${var.apm_name}}"
                display_type = "line"
                style {
                    palette = "dog_classic"
                    line_type = "solid"
                    line_width = "normal"
                }
            }
            yaxis {
                scale = "linear"
                min = "auto"
                max = "auto"
                include_zero = true
            }

            //TODO: conditional formatting for response time graph where the scale makes sense
            // marker {
            //     display_type = "ok dashed"
            //     value = "y < ${var.ok_response}"
            // }
            // marker {
            //     display_type = "warning dashed"
            //     value = "${var.error_response} > y > ${var.ok_response}"
            // }
            // marker {
            //     display_type = "error dashed"
            //     value = "y > ${var.error_response}"
            // }
            title = "50p Response time"
            title_align = "left"
            title_size = "16"
            show_legend = true
        }
        layout = {
            height = 24
            width = 53
            x = 0
            y = 30
        }
    }

    widget {
        query_value_definition {
            request {
                aggregator = "avg"
                q = "sum:trace.http.request.hits.by_http_status{http.status_class:2xx,service:${var.apm_name},$Environment}.as_count()/sum:trace.http.request.hits{service:${var.apm_name},$Environment}.as_count()*100"
                conditional_formats {
                    comparator = "<"
                    palette = "white_on_red"
                    value = "${var.error_uptime}"
                }
                conditional_formats {
                    comparator = "<="
                    palette = "white_on_yellow"
                    value = "${var.ok_uptime}"
                }
                conditional_formats  {
                    comparator = ">"
                    palette = "white_on_green"
                    value = "${var.ok_uptime}"
                }
            }
            autoscale = true
            precision = 2
            title = "Uptime"
            title_align = "left"
            title_size = "16"
        }
        layout = {
            height = 8
            width = 12
            x = -3
            y = -1
        }
    }

    widget {
        query_value_definition {
            request {
                q = "sum:trace.http.request.hits{$Environment,service:${var.apm_name}}.as_count()"
                aggregator = "sum"
            }
            autoscale = false
            precision = 2
            title = "Hits"
            title_align = "left"
            title_size = "16"
        }
        layout = {
            height = 8
            width = 12
            x = 89
            y = 0
        }
    }

    widget {
        query_value_definition {
            request {
                q = "sum:trace.http.request.hits.by_http_status{$Environment,service:${var.apm_name}}.as_rate()"
                aggregator = "avg"
            }
            autoscale = false
            precision = 2
            title = "Rate"
            title_align = "left"
            title_size = "16"
        }
        layout = {
            height = 8
            width = 12
            x = 101
            y = 0
        }
    }

    widget {
        service_level_objective_definition {
            title = "Uptime SLO"
            view_type = "detail"
            slo_id = var.uptime_slo_id
            show_error_budget = true
            view_mode = "overall"
            time_windows = ["30d"]
        }
        layout = {
            height = 21
            width = 60
            x = 53
            y = 10
        }
    }

    widget {
        service_level_objective_definition {
            title = "Response Time SLO"
            view_type = "detail"
            slo_id = var.response_slo_id
            show_error_budget = true
            view_mode = "overall"
            time_windows = ["30d"]
        }
        layout = {
            height = 21
            width = 60
            x = 53
            y = 30
        }
    }

    template_variable_preset {
        name = "Production"
        template_variable {
            name = "Environment"
            value = "prod"
        }
    }

    template_variable_preset {
        name = "Sandbox"
        template_variable {
            name = "Environment"
            value = "sandbox"
        }
    }

    template_variable_preset {
        name = "Staging"
        template_variable {
            name = "Environment"
            value = "staging"
        }
    }

    template_variable {
        default = "prod"
        name = "Environment"
        prefix = "env"
    }
}
