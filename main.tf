#################################################################
# Cloud Run
#################################################################
module "cloud_run" {
  count  = var.deploy_in_cloud_run ? 1 : 0
  source = "./modules/cloud-run"

  project_id  = var.project_id
  region      = var.region
  internal    = var.internal
  name_prefix = var.name_prefix

  container_port  = var.superblocks_agent_port
  container_image = var.superblocks_agent_image
  container_env = {
    "__SUPERBLOCKS_AGENT_SERVER_URL"           = var.superblocks_server_url,
    "__SUPERBLOCKS_WORKER_LOCAL_ENABLED"       = "true",
    "SUPERBLOCKS_WORKER_TLS_INSECURE"          = "true",
    "SUPERBLOCKS_AGENT_KEY"                    = var.superblocks_agent_key,
    "SUPERBLOCKS_CONTROLLER_DISCOVERY_ENABLED" = "false",
    "SUPERBLOCKS_AGENT_HOST_URL"               = var.superblocks_agent_host_url,
    "SUPERBLOCKS_AGENT_ENVIRONMENT"            = var.superblocks_agent_environment,
    "SUPERBLOCKS_AGENT_PORT"                   = var.superblocks_agent_port
  }
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
  record_name = var.record_name
  route_name  = module.cloud_run[0].route_name
}
