variable "apm_name" {
    type = string
}

variable "description" {
    type = string
    default = "A dashboard which holds service information"
}

variable "uptime_slo_id" {
    type = string
}

variable "response_slo_id" {
    type = string
}

variable "ok_uptime" {
  type = number
}

variable "error_uptime" {
  type = number
}

variable "ok_response" {
  type = number
}

variable "error_response" {
  type = number
}

variable "DATADOG_API_KEY" {
  type        = string
}

variable "DATADOG_APP_KEY" {
  type        = string
}

variable "create_datadog" {
  type = bool
  default = false
}
