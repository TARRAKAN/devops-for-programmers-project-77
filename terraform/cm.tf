resource "yandex_cm_certificate" "cm_certificate" {
  name = "my-cm-certificate"

  self_managed {
    certificate = file("./selfsigned.crt")
    private_key = file("./selfsigned.key")
  }
}
