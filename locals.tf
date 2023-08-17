locals {
  # if superblocks_agent_tags is not default, then
  #   use superblocks_agent_tags as is
  # else if superblocks_agent_tags is default, then
  #   if superblocks_agent_environment is *,
  #     use profile:* (default)
  #   else
  #     use profile:${superblocks_agent_environment}
  superblocks_agent_tags = var.superblocks_agent_tags != "profile:*" ? var.superblocks_agent_tags : var.superblocks_agent_environment == "*" ? "profile:*" : "profile:${var.superblocks_agent_environment}"

  superblocks_http_port = var.superblocks_agent_port
}
