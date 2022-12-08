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

module "cloud_run" {
  source = "../../modules/cloud-run"

  project_id  = var.project_id
  region      = var.region
  name_prefix = "superblocks"
  internal    = false

  container_image = "us-east1-docker.pkg.dev/superblocks-registry/superblocks/agent"
  container_port  = "8020"

  container_env = {
    "__SUPERBLOCKS_AGENT_SERVER_URL"           = "https://app.superblocks.com",
    "__SUPERBLOCKS_WORKER_LOCAL_ENABLED"       = "true",
    "SUPERBLOCKS_WORKER_TLS_INSECURE"          = "true",
    "SUPERBLOCKS_AGENT_KEY"                    = var.superblocks_agent_key,
    "SUPERBLOCKS_CONTROLLER_DISCOVERY_ENABLED" = "false",
    "SUPERBLOCKS_AGENT_HOST_URL"               = "https://example-complete.koalitytools.com",
    "SUPERBLOCKS_AGENT_ENVIRONMENT"            = "*",
    "SUPERBLOCKS_AGENT_PORT"                   = "8020"
  }

  container_requests_cpu    = "512m"
  container_requests_memory = "1024Mi"
  container_limits_cpu      = "1.0"
  container_limits_memory   = "2048Mi"
  container_min_capacity    = "1"
  container_max_capacity    = "5"
}

# Once Superblocks Agent is deployed to Cloud Run, create the DNS record manually.
# Go to "Cloud Run -> Manage Custom Domains -> Add Mappings"
#   follow the instructions to
#   1. verify your domain
#   2. create the mapping
#   3. update DNS record
