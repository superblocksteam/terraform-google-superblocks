provider "google" {
  #credentials = file("<NAME>.json")
  project = var.project_id
  region  = var.region
}

variable "project_id" {
  type    = string
  default = "<YOUR GOOGLE CLOUD PROJECT ID>"
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "superblocks_agent_key" {
  type      = string
  default   = "YOUR AGENT KEY"
  sensitive = true
}

module "terraform_google_superblocks" {
  source     = "../../"
  project_id = var.project_id
  region     = var.region
  # Set 'internal' to true if we want Cloun Run service is accessible
  # only in the same project or VPC
  internal = false

  zone_name   = "koalitytools-com"
  record_name = "example-simple-public-agent"

  superblocks_agent_key         = var.superblocks_agent_key
  superblocks_agent_environment = "dev"
  superblocks_agent_image       = "us-docker.pkg.dev/cloudrun/container/hello"
  superblocks_agent_port        = "9898"
  #superblocks_agent_image       = "ghcr.io/superblocksteam/superblocks-agent-simplified:ts-opa-simplification"
  #superblocks_agent_port        = "8020"
}
