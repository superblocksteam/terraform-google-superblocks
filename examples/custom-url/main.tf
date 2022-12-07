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

  create_dns                 = false
  superblocks_agent_host_url = "https://custom-url.koalitytools.com"
  superblocks_agent_key      = var.superblocks_agent_key
}

# Once Superblocks Agent is deployed to Cloud Run, create the DNS record manually.
# Go to "Cloud Run -> Manage Custom Domains -> Add Mappings"
#   follow the instructions to
#   1. verify your domain
#   2. create the mapping
#   3. update DNS record
