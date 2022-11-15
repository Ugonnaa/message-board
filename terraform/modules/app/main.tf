resource "google_compute_instance_template" "default" {
  name        = "appserver-template"
  project = var.project
  description = "This template is used to create app server instances."

  tags = ["allow-health-check"]
  meta_data_startup_script = <<-EOF
  #!/usr/bin/env bash
  sudo setcap cap_net_bind_service=+ep `readlink -f \`which node\`` 
  cd /app
  PORT=80 npm run start
  EOF
  labels = {
    managed-by-cnrm = "true"
  }

  instance_description = "description assigned to instances"
  machine_type         = "e2-micro"
  can_ip_forward       = false

  scheduling {
    automatic_restart   = true
  }
    // Create a new boot disk from an image
  disk {
    source_image      ="projects/st-dev-ugonnau-sandbox-96e8/global/images/packer-1668437543"
    auto_delete       = true
    boot              = true
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork
    subnetwork_project = var.project
  }

  service_account {
    email  = "742623525630-compute@developer.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_instance_group_manager" "packer_group_manager" {
  name = "lb-backend-example"
  project = var.project
  zone = "europe-west2-a"
  named_port {
    name = "http"
    port = 80
  }
  version {
    instance_template = google_compute_instance_template.default.id
    name              = "primary"
  }
  base_instance_name = "vm"
  target_size        = 2
}

resource "google_compute_firewall" "packer_firewall" {
  name          = "fw-allow-health-check"
  project= var.project
  direction     = "INGRESS"
  network       = var.network
  priority      = 1000
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  target_tags   = ["allow-health-check"]
  allow {
    ports    = ["80"]
    protocol = "tcp"
  }
}

resource "google_compute_global_address" "packer_global_address" {
  name       = "lb-ipv4-1"
  project= var.project
  ip_version = "IPV4"
}

resource "google_compute_health_check" "packer_health_check" {
  name               = "http-basic-check"
  project = var.project
  check_interval_sec = 5
  healthy_threshold  = 2
  http_health_check {
    port               = 80
    port_specification = "USE_FIXED_PORT"
    proxy_header       = "NONE"
    request_path       = "/"
  }
  timeout_sec         = 5
  unhealthy_threshold = 2
}

resource "google_compute_backend_service" "packer_backend_service" {
  name                            = "packer-backend-service"
  project = var.project
  connection_draining_timeout_sec = 0
  health_checks                   = [google_compute_health_check.packer_health_check.id]
  load_balancing_scheme           = "EXTERNAL_MANAGED"
  port_name                       = "http"
  protocol                        = "HTTP"
  session_affinity                = "NONE"
  timeout_sec                     = 30
  backend {
    group           = google_compute_instance_group_manager.packer_group_manager.instance_group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }
}

resource "google_compute_url_map" "packer_url_map" {
  name            = "packer-map-http"
  project = var.project
  default_service = google_compute_backend_service.packer_backend_service.id
}

resource "google_compute_target_http_proxy" "packer_http_proxy" {
  name    = "http-lb-proxy"
  project = var.project
  url_map = google_compute_url_map.packer_url_map.id
}

resource "google_compute_global_forwarding_rule" "packer_forwarding_rule" {
  name                  = "http-content-rule"
  project = var.project
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range            = "80-80"
  target                = google_compute_target_http_proxy.packer_http_proxy.id
  ip_address            = google_compute_global_address.packer_global_address.id
}