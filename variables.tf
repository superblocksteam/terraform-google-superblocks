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
  type = string
  validation {
    condition     = length(var.superblocks_agent_environment) > 0
    error_message = "The agent environment cannot be null."
  }
}

variable "superblocks_agent_host_url" {
  type    = string
  default = ""
}

variable "superblocks_agent_port" {
  type    = number
  default = "8020"
}

variable "superblocks_agent_image" {
  type    = string
  default = ""
}

variable "superblocks_server_url" {
  type    = string
  default = "https://app.superblocks.com"
}

variable "name_prefix" {
  type    = string
  default = "superblocks"
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

variable "record_name" {
  type    = string
  default = "agent"
}
