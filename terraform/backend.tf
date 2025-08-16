terraform {
  backend "s3" {
    key                         = "remote-terraform.tfstate"
    endpoint                    = "https://storage.yandexcloud.net"
    region                      = "ru-central1"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}