#################################################################
# Cloud Run
#################################################################

locals {
  _container_memory_value      = regex("^(\\d*)(.*)", var.container_limits_memory)[0]
  _container_memory_unit       = regex("^(\\d*)(.*)", var.container_limits_memory)[1]
  _container_memory_multiplier = lower(local._container_memory_unit) == "gi" ? 1000 : 1
  node_heap                    = local._container_memory_value * 0.75 * local._container_memory_multiplier
}

module "cloud_run" {
  count  = var.deploy_in_cloud_run ? 1 : 0
  source = "./modules/cloud-run"

  project_id  = var.project_id
  region      = var.region
  internal    = var.internal
  name_prefix = var.name_prefix

  container_port  = var.superblocks_agent_port
  container_image = var.superblocks_agent_image
  container_env = merge({
    "SUPERBLOCKS_ORCHESTRATOR_LOG_LEVEL"               = "${var.superblocks_log_level}"
    "SUPERBLOCKS_ORCHESTRATOR_HTTP_PORT"               = "${var.superblocks_agent_port}"
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
    "SUPERBLOCKS_ORCHESTRATOR_AGENT_TAGS"              = "${var.superblocks_agent_tags}"
    "SUPERBLOCKS_ORCHESTRATOR_DATA_DOMAIN"             = "${var.superblocks_agent_data_domain}"
    "SUPERBLOCKS_ORCHESTRATOR_HANDLE_CORS"             = "${var.superblocks_agent_handle_cors}"
    "S6_READ_ONLY_ROOT"                                = "1"
  }, var.superblocks_additional_env_vars)
  container_cpu_throttling  = var.container_cpu_throttling
  container_requests_cpu    = var.container_requests_cpu
  container_requests_memory = var.container_requests_memory
  container_limits_cpu      = var.container_limits_cpu
  container_limits_memory   = var.container_limits_memory
  container_max_capacity    = var.container_max_capacity
  container_min_capacity    = var.container_min_capacity

  health_check_failure_threshold = var.health_check_failure_threshold
  health_check_period            = var.health_check_period
}

#################################################################
# DNS
#################################################################
module "dns" {
  count  = var.create_dns ? 1 : 0
  source = "./modules/dns"

  project_id  = var.project_id
  region      = var.region
  zone_name   = var.zone_name
  record_name = var.subdomain
  route_name  = module.cloud_run[0].route_name
}
