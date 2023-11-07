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
  container_port  = "8080"

  container_env = {
    "SUPERBLOCKS_ORCHESTRATOR_LOG_LEVEL"               = "${var.superblocks_log_level}"
    "SUPERBLOCKS_ORCHESTRATOR_HTTP_PORT"               = "${local.superblocks_http_port}"
    "SUPERBLOCKS_ORCHESTRATOR_GRPC_PORT"               = "8081"
    "SUPERBLOCKS_ORCHESTRATOR_METRICS_PORT"            = "9090"
    "SUPERBLOCKS_ORCHESTRATOR_GRPC_BIND"               = "0.0.0.0"
    "SUPERBLOCKS_ORCHESTRATOR_HTTP_BIND"               = "0.0.0.0"
    "SUPERBLOCKS_ORCHESTRATOR_GRPC_MSG_RES_MAX"        = "${var.superblocks_grpc_msg_res_max}"
    "SUPERBLOCKS_ORCHESTRATOR_GRPC_MSG_REQ_MAX"        = "${var.superblocks_grpc_msg_req_max}"
    "SUPERBLOCKS_ORCHESTRATOR_SUPERBLOCKS_URL"         = "${var.superblocks_server_url}"
    "SUPERBLOCKS_ORCHESTRATOR_SUPERBLOCKS_TIMEOUT"     = "${var.superblocks_timeout}"
    "SUPERBLOCKS_ORCHESTRATOR_OTEL_COLLECTOR_HTTP_URL" = "https://traces.intake.superblocks.com:443/v1/traces"
    "SUPERBLOCKS_ORCHESTRATOR_EMITTER_REMOTE_INTAKE"   = "https://logs.intake.superblocks.com"
    "SUPERBLOCKS_ORCHESTRATOR_INTAKE_METADATA_URL"     = "https://metadata.intake.superblocks.com"
    "SUPERBLOCKS_ORCHESTRATOR_TRANSPORT_MODE"          = "grpc"
    "SUPERBLOCKS_ORCHESTRATOR_STORE_MODE"              = "grpc"
    "SUPERBLOCKS_AGENT_KEY"                            = "${var.superblocks_agent_key}"
    "SUPERBLOCKS_ORCHESTRATOR_SUPERBLOCKS_KEY"         = "${var.superblocks_agent_key}"
    "SUPERBLOCKS_ORCHESTRATOR_FILE_SERVER_URL"         = "http://127.0.0.1:${local.superblocks_http_port}/v2/files"
    "SUPERBLOCKS_ORCHESTRATOR_AGENT_HOST_URL"          = "https://${var.subdomain}.${var.domain}"
    "SUPERBLOCKS_ORCHESTRATOR_AGENT_ENVIRONMENT"       = "${var.superblocks_agent_environment}"
    "SUPERBLOCKS_ORCHESTRATOR_AGENT_TAGS"              = "${local.superblocks_agent_tags}"
    "SUPERBLOCKS_ORCHESTRATOR_DATA_DOMAIN"             = "${var.superblocks_agent_data_domain}"
    "SUPERBLOCKS_ORCHESTRATOR_HANDLE_CORS"             = "${var.superblocks_agent_handle_cors}"
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
