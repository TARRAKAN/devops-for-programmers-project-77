variable "yc_cloud_id" {
  type      = string
  sensitive = true
}

variable "yc_folder_id" {
  type      = string
  sensitive = true
}

variable "yc_zone" {
  type    = string
  default = "ru-central1-a"
}

variable "yc_db_name" {
  type      = string
  sensitive = true
}

variable "yc_db_user" {
  type      = string
  sensitive = true
}

variable "yc_db_password" {
  type      = string
  sensitive = true
}

variable "datadog_api_url" {
  default = "https://api.datadoghq.eu/"
  type    = string
}

variable "datadog_app_key" {
  type      = string
  sensitive = true
}

variable "datadog_api_key" {
  type      = string
  sensitive = true
}
