variable "apm_name" {
    type = string
}

variable "warning_recovery_uptime" {
  type = number
}

variable "warning_uptime" {
  type = number
}

variable "critical_uptime" {
  type = number
}

variable "critical_recovery_uptime" {
  type = number
}

variable "warning_response" {
  type = number
}

variable "warning_recovery_response" {
  type = number
}

variable "critical_response" {
  type = number
}

variable "critical_recovery_response" {
  type = number
}

variable "target_uptime" {
  type = number
}

variable "target_response" {
  type = number
}

variable "timeframe_uptime" {
  type = string
}

variable "timeframe_response" {
  type = string
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

variable "description" {
    type = string
    default = "A dashboard which holds service information"
}

variable "owner" {
    type = string
    default = ""
}
