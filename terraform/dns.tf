resource "yandex_dns_zone" "zone" {
    name   = "my-dns-zone"
    zone   = "krasnayaschahta.ru."
    public = true
}

resource "yandex_dns_recordset" "recordset" {
    zone_id = yandex_dns_zone.zone.id
    name    = "krasnayaschahta.ru."
    type    = "A"
    ttl     = 600
    data    = [yandex_alb_load_balancer.load_balancer.listener[0].endpoint[0].address[0].external_ipv4_address[0].address]
}
