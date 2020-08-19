terraform {
  required_version = ">= 0.12.0"
  backend "s3" {}
}

provider "datadog" {
    api_key = var.DATADOG_API_KEY
    app_key = var.DATADOG_APP_KEY
}