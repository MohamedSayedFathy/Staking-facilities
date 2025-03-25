resource "google_compute_global_address" "lb_static_ip" {
  name = "lb-static-ip"
}

resource "google_compute_instance_group" "web_group" {
  name  = "web-instance-group"
  zone  = "europe-north1-a"
  instances = [
    for instance in google_compute_instance.web : instance.self_link
  ]

  named_port {
    name = "http"
    port = 80
  }
}

resource "google_compute_health_check" "http_health_check" {
  name                = "http-health-check"
  check_interval_sec  = 10
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 2

  http_health_check {
    request_path = "/"
    port         = 80
  }
}

resource "google_compute_url_map" "lb_url_map" {
  name            = "lb-url-map"
  default_service = google_compute_backend_service.lb_backend.self_link
}

resource "google_compute_backend_service" "lb_backend" {
  name                  = "lb-backend"
  protocol              = "HTTP"
  port_name             = "http"
  timeout_sec           = 10
  health_checks         = [google_compute_health_check.http_health_check.self_link]
  load_balancing_scheme = "EXTERNAL"

  backend {
    group = google_compute_instance_group.web_group.self_link
  }
}


resource "google_compute_target_http_proxy" "lb_proxy" {
  name    = "lb-http-proxy"
  url_map = google_compute_url_map.lb_url_map.self_link
}

resource "google_compute_global_forwarding_rule" "lb_forwarding_rule" {
  name                  = "lb-forwarding-rule"
  ip_address            = google_compute_global_address.lb_static_ip.address
  port_range            = "80"
  target                = google_compute_target_http_proxy.lb_proxy.self_link
  load_balancing_scheme = "EXTERNAL"
}