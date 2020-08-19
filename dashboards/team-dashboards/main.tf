resource "datadog_dashboard" "free_dashboard" {
    count = var.create ? length(var.pods) : 0
    title = var.pods[count.index].name
    description = var.description
    is_read_only = true
    layout_type = "free"

    dynamic "widget" {
        for_each = var.pods
        content {
            free_text_definition {
                color = "#4d4d4d"
                font_size = "36"
                text = "${var.pods[count.index].name} Service Health Board"
                text_align = "left"
            }
            layout = {
                height = 3
                width = 23
                x = 11
                y = 0
            }
        }
    }

    dynamic "widget" {
        for_each = var.pods[count.index].services
        content {
            query_value_definition {
                request {
                    aggregator = "sum"
                    q = "sum:trace.http.request.hits.by_http_status{$Environment,service:${widget.value}}.as_count()"
                }
                autoscale = true
                precision = 2
                title = widget.value
                title_align = "left"
                title_size = "16"
            }
            layout = {
                height = 6
                width = 17
                x = 0
                y = 4 + 7 * widget.key
            }
        }
    }

    dynamic "widget" {
        for_each = var.pods[count.index].services
        content {
            query_value_definition {
                request {
                    aggregator = "avg"
                    q = "sum:trace.http.request.hits.by_http_status{$Environment,service:${widget.value}}.as_rate()"
                }
                autoscale = true
                precision = 2
                title = "Rate"
                title_align = "left"
                title_size = "16"
            }
            layout = {
                height = 6
                width = 17
                x = 17
                y = 4 + 7 * widget.key
            }
        }
    }

    dynamic "widget" {
        for_each = var.pods[count.index].services
        content {
            query_value_definition {
                request {
                    aggregator = "avg"
                    q = "avg:trace.http.request.duration.by.service.50p{$Environment,service:${widget.value}}"
                }
                autoscale = true
                precision = 2
                title = "50p"
                title_align = "left"
                title_size = "16"
            }
            layout = {
                height = 6
                width = 15
                x = 34
                y = 4 + 7 * widget.key
            }
        }
    }

    dynamic "widget" {
        for_each = var.pods[count.index].services
        content {
            query_value_definition {
                request {
                    aggregator = "avg"
                    q = "avg:trace.http.request.duration.by.service.95p{$Environment,service:${widget.value}}"
                }
                autoscale = true
                precision = 2
                title = "95p"
                title_align = "left"
                title_size = "16"
            }
            layout = {
                height = 6
                width = 15
                x = 49
                y = 4 + 7 * widget.key
            }
        }
    }

    dynamic "widget" {
        for_each = var.pods[count.index].services
        content {
            query_value_definition {
                request {
                    q = "sum:trace.http.request.hits.by_http_status{http.status_class:2xx,$Environment,service:${widget.value}}.as_count()/sum:trace.http.request.hits{$Environment,service:${widget.value}}.as_count()*100"
                    aggregator = "avg"
                    conditional_formats {
                        comparator = "<"
                        palette = "white_on_red"
                        value = 98
                    }
                    conditional_formats {
                        comparator = "<="
                        palette = "white_on_yellow"
                        value = 99
                    }
                    conditional_formats  {
                        comparator = ">"
                        palette = "white_on_green"
                        value = 99
                    }
                }
                autoscale = false
                precision = 2
                title = "Uptime"
                title_align = "left"
                title_size = "16"
            }
            layout = {
                height = 6
                width = 15
                x = 64
                y = 4 + 7 * widget.key
            }
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


