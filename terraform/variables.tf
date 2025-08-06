variable "yc_iam_token" {
    type = string
    sensitive = true
}

variable "yc_cloud_id" {
    type = string
}

variable "yc_folder_id" {
    type = string
}

variable "yc_zone" {
    type = string
    default = "ru-central1-a"
}

variable "yc_db_user" {
    type = string
    sensitive = true
}

variable "yc_db_password" {
    type = string
    sensitive = true
}
