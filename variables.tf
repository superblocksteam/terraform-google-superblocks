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
    DEPRECATED! Use superblocks_agent_tags instead.
    Use this varible to differentiate Superblocks Agent running environment.
    Valid values are "*", "staging" and "production"
  EOF
}

variable "superblocks_agent_tags" {
  type        = string
  default     = "profile:*"
  description = <<EOF
    Use this variable to specify which profile-specific workloads can be executed on this agent.
    It accepts a comma (and colon) separated string representing key-value pairs, and currently only the "profile" key is used.

    Some examples:
    - To support all API executions:      "profile:*"
    - To support staging and production:  "profile:staging,profile:production"
    - To support only staging:            "profile:staging"
    - To support only production:         "profile:production"
    - To support a custom profile:        "profile:custom_profile_key"
  EOF
}

variable "superblocks_agent_port" {
  type        = number
  default     = "8080"
  description = "The port number used by Superblocks Agent container instance"
}

variable "superblocks_agent_image" {
  type        = string
  default     = "us-east1-docker.pkg.dev/superblocks-registry/superblocks/agent"
  description = "The docker image used by Superblocks Agent container instance"
}

variable "superblocks_server_url" {
  type    = string
  default = "https://api.superblocks.com"
}

variable "name_prefix" {
  type        = string
  default     = "superblocks"
  description = "This will be prepended to the name of each resource created by this module"
}

variable "superblocks_agent_data_domain" {
  type    = string
  default = "app.superblocks.com"
  validation {
    condition     = contains(["app.superblocks.com", "eu.superblocks.com"], var.superblocks_agent_data_domain)
    error_message = "The data domain is invalid. Please use 'app.superblocks.com' or 'eu.superblocks.com'."
  }
  description = "The domain name for the specific Superblocks region that hosts your data."
}

variable "superblocks_grpc_msg_res_max" {
  type        = string
  default     = "100000000"
  description = "The maximum message size in bytes allowed to be sent by the gRPC server. This is used to prevent malicious clients from sending large messages to cause memory exhaustion."
}

variable "superblocks_grpc_msg_req_max" {
  type        = string
  default     = "30000000"
  description = "The maximum message size in bytes allowed to be received by the gRPC server. This is used to prevent malicious clients from sending large messages to cause memory exhaustion."
}

variable "superblocks_timeout" {
  type        = string
  default     = "10000000000"
  description = "The maximum amount of time in milliseconds before a request is aborted. This applies for http requests against the Superblocks server and does not apply to the execution time limit of a workload."
}

variable "superblocks_log_level" {
  type        = string
  default     = "info"
  description = "Logging level for the superblocks agent. Accepted values are 'debug', 'info', 'warn', 'error', 'fatal', 'panic'."
}

variable "superblocks_agent_handle_cors" {
  type        = bool
  default     = true
  description = "Whether to handle CORS requests, this will accept all requests from any origin."
}

variable "superblocks_additional_env_vars" {
  type        = map(any)
  default     = {}
  description = "Additional environment variables to specify for the Superblocks Agent container."
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

variable "container_cpu_throttling" {
  type        = bool
  default     = false
  description = "When it's false, CPU is always allocated."
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
