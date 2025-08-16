resource "yandex_alb_target_group" "target_group" {
  name = "my-alb-target-group"

  dynamic "target" {
    for_each = yandex_compute_instance.compute_instance
    content {
      subnet_id  = yandex_vpc_subnet.subnet.id
      ip_address = target.value.network_interface[0].ip_address
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
      handler {
        http_router_id = yandex_alb_http_router.http_router.id
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
      timeout             = "1s"
      interval            = "1s"
      healthy_threshold   = 1
      unhealthy_threshold = 1
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
    name = "my-alb-virtual-host-route"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.backend_group.id
      }
    }
  }

  depends_on = [
    yandex_alb_backend_group.backend_group,
    yandex_alb_http_router.http_router,
    yandex_alb_target_group.target_group
  ]
}

output "alb_ip" {
  value = try(yandex_alb_load_balancer.load_balancer.listener[0].endpoint[0].address[0].external_ipv4_address[0].address, "")
}
