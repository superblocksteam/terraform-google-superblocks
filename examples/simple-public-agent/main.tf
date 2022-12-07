provider "google" {
  #credentials = file("<NAME>.json")
  project = var.project_id
  region  = var.region
}

variable "project_id" {
  type    = string
  default = "<GOOGLE_CLOUD_PROJECT_ID>"
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "superblocks_agent_key" {
  type      = string
  default   = "<SUPERBLOCKS_AGENT_KEY>"
  sensitive = true
}

module "terraform_google_superblocks" {
  source = "../../"

  project_id = var.project_id
  region     = var.region

  zone_name             = "koalitytools-com"
  record_name           = "example-simple-public-agent"
  superblocks_agent_key = var.superblocks_agent_key
}
