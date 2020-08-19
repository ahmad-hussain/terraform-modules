variable "description" {
    type = string
    default = "A dashboard which holds service information for the services seen below"
}

variable "pods" {
    type = list(object({
      name = string
      services = list(string)
    }))
}

variable "create" {
  type        = bool
  default     = true
}

variable "DATADOG_API_KEY" {
  type        = string
}

variable "DATADOG_APP_KEY" {
  type        = string
}
