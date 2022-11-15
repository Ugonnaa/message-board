module "vpc" {
  source  = "../modules/vpc"
  project = "st-dev-ugonnau-sandbox-96e8"
}

module "app" {
  source = "../modules/app"
  network = module.vpc.network
  project = "st-dev-ugonnau-sandbox-96e8"
  subnetwork = module.vpc.subnetwork
}

