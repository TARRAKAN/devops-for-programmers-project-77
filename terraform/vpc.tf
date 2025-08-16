resource "yandex_vpc_network" "network" {
  name = "vpc-network"
}

resource "yandex_vpc_subnet" "subnet" {
  name           = "vpc-subnet"
  zone           = var.yc_zone
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.0.0/16"]
  folder_id      = var.yc_folder_id
}

resource "yandex_vpc_address" "address" {
  name = "my-vpc-address"

  external_ipv4_address {
    zone_id = var.yc_zone
  }
}
