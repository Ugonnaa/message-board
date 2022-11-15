output "network" {
    value = google_compute_network.this.id
}
output "subnetwork" {
    value = google_compute_subnetwork.packer-subnet.id
}