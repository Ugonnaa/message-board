# Pop anything related to your network infrastructure in here, think VPC, subnets, firewall rules

# Example: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network
resource "google_compute_network" "this" {
  project                 = var.project
  name                    = "my-network"
  auto_create_subnetworks = false
}

