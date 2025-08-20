resource "datadog_monitor" "datadog_service_check" {
  name              = "my-datadog-monitor"
  type              = "service check"
  no_data_timeframe = 10
  notify_no_data    = true

  query = <<EOT
"http.can_connect".over("*").by("host").last(2).count_by_status()
EOT

  message = <<EOT
service check was failed
EOT
}
