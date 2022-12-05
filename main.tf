#################################################################
# Cloud Run
#################################################################
module "cloud_run" {
  count  = var.deploy_in_cloud_run ? 1 : 0
  source = "./modules/cloud-run"

  region      = var.region
  internal    = var.internal
  name_prefix = var.name_prefix

  container_port  = var.superblocks_agent_port
  container_image = var.superblocks_agent_image
  container_env = [
    {
      name  = "__SUPERBLOCKS_AGENT_SERVER_URL"
      value = var.superblocks_server_url
    },
    {
      name  = "__SUPERBLOCKS_WORKER_LOCAL_ENABLED"
      value = "true"
    },
    {
      name  = "SUPERBLOCKS_WORKER_TLS_INSECURE"
      value = "true"
    },
    {
      name  = "SUPERBLOCKS_AGENT_KEY"
      value = var.superblocks_agent_key
    },
    {
      name  = "SUPERBLOCKS_CONTROLLER_DISCOVERY_ENABLED"
      value = "false"
    },
    {
      name  = "SUPERBLOCKS_AGENT_HOST_URL"
      value = var.superblocks_agent_host_url
    },
    {
      name  = "SUPERBLOCKS_AGENT_ENVIRONMENT"
      value = var.superblocks_agent_environment
    },
    {
      name  = "SUPERBLOCKS_AGENT_PORT"
      value = var.superblocks_agent_port
    }
  ]
}
