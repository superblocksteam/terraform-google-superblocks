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
    error_message = "Variable `region` cannot null."
  }
}

variable "name_prefix" {
  type    = string
  default = "superblocks"
}

variable "internal" {
  type    = bool
  default = false
}

variable "container_image" {
  type    = string
  default = "us-east1-docker.pkg.dev/superblocks-registry/superblocks/agent"
}

variable "container_port" {
  type    = number
  default = "8080"
}

variable "container_env" {
  type    = map(any)
  default = {}
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
  description = "Amount of memory in GiB"
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

variable "cloud_run_role" {
  type    = string
  default = "roles/run.invoker"
}

variable "cloud_run_member" {
  type    = string
  default = "allUsers"
}

variable "health_check_period" {
  type        = number
  default     = 10
  description = "The interval between health checks in seconds"
}

variable "health_check_failure_threshold" {
  type        = number
  default     = 6
  description = "The number of consecutive failed health checks before considering the agent unhealthy"
}
