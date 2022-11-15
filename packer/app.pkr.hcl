packer {
  required_plugins {
    // Use the "Google Compute Builder" plugin to create images on GCP
    // https://www.packer.io/plugins/builders/googlecompute
    googlecompute = {
      version = ">= 0.0.1"
      source = "github.com/hashicorp/googlecompute"
    }
  }
}

// Provide base information to allow building of a new image
source "googlecompute" "packer-test" {
  // Provide the project in which you want to build your image
  project_id          = "st-dev-ugonnau-sandbox-96e8"

  // Provide a base image on which to base your final image
  source_image_family = "debian-10"

  // Provide a zone in which to place the builder VM
  zone                = "europe-west2-a"

  // Provide a system user to perform build tasks
  ssh_username        = "packer"

  // Provide a subnet in which to build the image
  subnetwork          = "projects/st-dev-ugonnau-sandbox-96e8/regions/europe-west2/subnetworks/packer-subnet"

  // Our Organisation Policies prevent use of external IP addresses for instances, so we must 
  // use interal IP address combined with IAP and OSLogin to SSH to the instance
  // You shouldn't need to change these, if you're having trouble getting Packer to SSH to the instance, 
  // check your firewalls and IAP in the Google Cloud Console
  omit_external_ip    = true
  use_internal_ip     = true
  use_iap             = true
  use_os_login        = true
}

// Things to do in order to transform the source image into your final image
build {
  // Name your image
  name    = "packer-test"

  // Declare sources
  sources = ["sources.googlecompute.packer-test"]

  // Transfer files onto the image
  provisioner "file" {
    sources = ["../app/lib", "../app/pages", "../app/public", "../app/styles", "../app/next.config.js",
     "../app/package-lock.json", "../app/package.json", "../app/tsconfig.json", "../app/.eslintrc.json"]
    destination = "/tmp/app/"
  }

  // Use a shell script to install programs and set stuff up on your image
  // https://www.packer.io/docs/provisioners/shell
  provisioner "shell" {
    script = "./provision.sh"
    environment_vars = []
  }
}
