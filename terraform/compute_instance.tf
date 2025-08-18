resource "yandex_compute_instance" "compute_instance" {
  count       = 2
  name        = "my-compute-compute_instance-${count.index + 1}"
  platform_id = "standard-v3"
  zone        = var.yc_zone

  resources {
    core_fraction = 50
    cores         = 2
    memory        = 2
  }

  boot_disk {
    initialize_params {
      name     = "ubuntu-24-04-lts-${count.index + 1}"
      image_id = "fd8e4gcflhhc7odvbuss"
      size     = 10
      type     = "network-hdd"
    }
  }

  scheduling_policy {
    preemptible = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/yacl_rsa.pub")}"
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet.id
    nat       = true
  }

  depends_on = [yandex_mdb_postgresql_cluster.postgresql_cluster]
}

resource "local_file" "ansible_inventory" {
  filename = "../ansible/inventory.ini"
  content = templatefile("inventory.ini.tftpl", {
    web_servers_ips = {
      for instance in yandex_compute_instance.compute_instance :
      instance.name => instance.network_interface[0].nat_ip_address
    }
  })
}

output "compute_instances_ip" {
  value = try(yandex_compute_instance.compute_instance[*].network_interface[0].nat_ip_address)
}
