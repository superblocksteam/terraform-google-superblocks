provider "google" {
  #credentials = file("<NAME>.json")
  region = var.region
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
  region     = var.region
  internal   = false
  create_dns = false

  superblocks_agent_key         = var.superblocks_agent_key
  superblocks_agent_environment = "dev"
  superblocks_agent_host_url    = "https://custom-url.koalitytools.com"
  superblocks_agent_image       = "us-docker.pkg.dev/cloudrun/container/hello"
  superblocks_agent_port        = "9898"
  #superblocks_agent_image       = "ghcr.io/superblocksteam/superblocks-agent-simplified:ts-opa-simplification"
  #superblocks_agent_port        = "8020"
}

# Once Superblocks Agent is deployed to Cloud Run,
# we need to create the DNS record manually.
# Go to "Cloud Run -> Manage Custom Domains -> Add Mappings"
#   follow the instructions to
#   1. verify your domain
#   2. create the mapping
#   3. update DNS record
