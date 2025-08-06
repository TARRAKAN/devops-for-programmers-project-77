resource "yandex_alb_target_group" "target_group" {
    name = "my-alb-target-group"

    dynamic "target" {
        for_each = yandex_compute_instance.compute_instance
        content {
            subnet_id  = yandex_vpc_subnet.subnet.id
            ip_address = target.value.network_interface.0.ip_address
        }
    }
}

resource "yandex_alb_http_router" "http_router" {
    name = "my-alb-http-router"
}

resource "yandex_alb_load_balancer" "load_balancer" {
    name       = "my-alb-load-balancer"
    network_id = yandex_vpc_network.network.id

    allocation_policy {
        location {
            zone_id   = var.yc_zone
            subnet_id = yandex_vpc_subnet.subnet.id
        }
    }

    listener {
      name = "my-http-listener"
      endpoint {
        address {
          external_ipv4_address {
            address = yandex_vpc_address.address.external_ipv4_address[0].address
          }
        }
        ports = [80]
      }
      http {
        # handler {
        #   http_router_id = yandex_alb_http_router.http_router.id
        # }
        redirects {
          http_to_https = true
        }
      }
    }

    listener {
      name = "my-https-listener"
      endpoint {
        ports = [443]
        address {
          external_ipv4_address {
            address = yandex_vpc_address.address.external_ipv4_address[0].address
          }
        }
      }

      tls {
        default_handler {
          certificate_ids = ["${yandex_cm_certificate.cm_certificate.id}"]

          http_handler {
            http_router_id = yandex_alb_http_router.http_router.id
          }
        }
      }
    }
}

resource "yandex_alb_backend_group" "backend_group" {
    name = "my-backend-group"

    http_backend {
        name             = "my-http-backend"
        weight           = 1
        port             = 80
        target_group_ids = [yandex_alb_target_group.target_group.id]
        healthcheck {
            timeout  = "30s"
            interval = "5s"
            http_healthcheck {
                path = "/"
            }
        }
    }
}

resource "yandex_alb_virtual_host" "virtual_host" {
    name           = "my-alb-virtual-host"
    http_router_id = yandex_alb_http_router.http_router.id
    route {
        name = "route"
        http_route {
            http_route_action {
                backend_group_id = yandex_alb_backend_group.backend_group.id
            }
        }
    }
}
