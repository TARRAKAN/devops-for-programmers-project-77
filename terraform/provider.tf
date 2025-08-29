terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.84.0"
    }
    datadog = {
      source  = "DataDog/datadog"
      version = "3.57.0"
    }
  }

  required_version = ">= 1.0.0"
}

provider "yandex" {
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = var.yc_zone
}

provider "datadog" {
  api_url = var.datadog_api_url
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
}
