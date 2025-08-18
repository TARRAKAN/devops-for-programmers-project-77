resource "yandex_mdb_postgresql_cluster" "postgresql_cluster" {
  name        = "my-mdb-postgresql-cluster"
  network_id  = yandex_vpc_network.network.id
  environment = "PRESTABLE"

  config {
    version = 16

    resources {
      resource_preset_id = "s2.micro"
      disk_type_id       = "network-hdd"
      disk_size          = 10
    }

    postgresql_config = {
      max_connections = 100
    }
  }

  host {
    zone      = var.yc_zone
    subnet_id = yandex_vpc_subnet.subnet.id
  }

  maintenance_window {
    type = "WEEKLY"
    day  = "SAT"
    hour = 12
  }
}

resource "yandex_mdb_postgresql_user" "postgresql_user" {
  name       = var.yc_db_user
  password   = var.yc_db_password
  cluster_id = yandex_mdb_postgresql_cluster.postgresql_cluster.id
  depends_on = [yandex_mdb_postgresql_cluster.postgresql_cluster]
}

resource "yandex_mdb_postgresql_database" "postgresql_database" {
  name       = var.yc_db_name
  lc_collate = "en_US.UTF-8"
  lc_type    = "en_US.UTF-8"
  cluster_id = yandex_mdb_postgresql_cluster.postgresql_cluster.id
  owner      = yandex_mdb_postgresql_user.postgresql_user.name

  depends_on = [yandex_mdb_postgresql_cluster.postgresql_cluster]
}

resource "local_file" "db_host" {
  filename = "../ansible/group_vars/webservers/db_address.yml"
  content = templatefile("db_address.yml.tftpl", {
    db_address = yandex_mdb_postgresql_cluster.postgresql_cluster.host[0].fqdn
  })
}

output "postgresql_host" {
  value = yandex_mdb_postgresql_cluster.postgresql_cluster.host[0].fqdn
}