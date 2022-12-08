#################################################################
# Common
#################################################################
variable "project_id" {
  type = string
  validation {
    condition     = length(var.project_id) > 0
    error_message = "Variable `project_id` cannot be null."
  }
}

variable "region" {
  type = string
  validation {
    condition     = length(var.region) > 0
    error_message = "Variable `region` cannot be null."
  }
}

variable "superblocks_agent_key" {
  type      = string
  sensitive = true
  validation {
    condition     = length(var.superblocks_agent_key) > 10
    error_message = "The agent key is invalid."
  }
}

variable "superblocks_agent_environment" {
  type        = string
  default     = "*"
  description = <<EOF
    Use this varible to differentiate Superblocks Agent running environment.
    Valid values are "*", "staging" and "production"
  EOF
}

variable "superblocks_agent_port" {
  type        = number
  default     = "8020"
  description = "The port number used by Superblocks Agent container instance"
}

variable "superblocks_agent_image" {
  type        = string
  default     = "us-east1-docker.pkg.dev/superblocks-registry/superblocks/agent"
  description = "The docker image used by Superblocks Agent container instance"
}

variable "superblocks_server_url" {
  type    = string
  default = "https://app.superblocks.com"
}

variable "name_prefix" {
  type        = string
  default     = "superblocks"
  description = "This will be prepended to the name of each resource created by this module"
}

#################################################################
# Cloud Run
#################################################################
variable "internal" {
  type        = bool
  default     = false
  description = <<EOF
    false: Cloud Run service is accessible in public network.
    true : Cloud Run service is accessible only in the same GCP project or VPC.
  EOF
}

variable "deploy_in_cloud_run" {
  type        = bool
  default     = true
  description = <<EOF
    Whether to deploy Superblocks Agent to Google Cloud Run.
    Currently, this is the only option to deploy On-Premise Agent in GCP.
    We will support other deployment options in the future.
  EOF
}

variable "container_requests_cpu" {
  type        = string
  default     = "1"
  description = "Amount of CPU cores."
}

variable "container_requests_memory" {
  type        = string
  default     = "4Gi"
  description = "Amount of memory in Gib"
}

variable "container_limits_cpu" {
  type        = string
  default     = "2.0"
  description = "CPU limit, must be equal to one of [.08-1], 1.0, 2.0, 4.0, 6.0, 8.0"
}

variable "container_limits_memory" {
  type        = string
  default     = "4Gi"
  description = "Amount of memory in GiB"
}

variable "container_min_capacity" {
  type    = number
  default = "1"
}

variable "container_max_capacity" {
  type    = number
  default = "5"
}


#################################################################
# DNS
#################################################################
variable "create_dns" {
  type        = bool
  default     = true
  description = <<EOF
    If a valid Google Managed Zone is available,
    set 'create_dns' to 'true' to let this module create default DNS record
  EOF
}

variable "zone_name" {
  type    = string
  default = ""
}

variable "subdomain" {
  type    = string
  default = "agent"
}

variable "domain" {
  type = string
}
