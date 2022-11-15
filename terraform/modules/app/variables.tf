# Put your variables in here
variable "network" {
    type = string
}
variable "project" {
  description = "Google Cloud Project in which to create the resources"
  type        = string
}
variable "subnetwork" {
    type = string
}