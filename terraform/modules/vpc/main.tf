# Pop anything related to your network infrastructure in here, think VPC, subnets, firewall rules

# Example: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network
resource "google_compute_network" "this" {
  project                 = var.project
  name                    = "my-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "packer-subnet" {
  name          = "packer-subnet"
  project       = var.project
  ip_cidr_range = "10.2.0.0/16"
  region        = "europe-west2"
  network       = google_compute_network.this.id
}

resource "google_compute_firewall" "packer-firewall" {
  name    = "packer-firewall"
  project = var.project
  network = google_compute_network.this.self_link
  allow {
    protocol = "tcp"
    ports = ["22"]
  }
  source_ranges = ["35.235.240.0/20"]
}

resource "google_compute_router" "packer_router" {
  name = "packer-router"
  project = var.project
  region = "europe-west2"
  network = google_compute_network.this.id
}

resource "google_compute_router_nat" "packer_router_nat" {
  name = "packer-router-nat"
  project = var.project
  router = google_compute_router.packer_router.name
  region = "europe-west2"
  nat_ip_allocate_option = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
