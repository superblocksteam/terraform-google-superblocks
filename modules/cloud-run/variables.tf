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
  default = ""
}

variable "container_port" {
  type    = number
  default = "8020"
}

variable "container_env" {
  type    = map(any)
  default = {}
}

variable "container_requests_cpu" {
  type        = string
  default     = "512m"
  description = "Amount of CPU millicores."
}

variable "container_requests_memory" {
  type        = string
  default     = "1024Mi"
  description = "Amount of memory in MiB"
}

variable "container_limits_cpu" {
  type        = string
  default     = "1.0"
  description = "CPU limit, must be equal to one of [.08-1], 1.0, 2.0, 4.0, 6.0, 8.0"
}

variable "container_limits_memory" {
  type        = string
  default     = "2048Mi"
  description = "Amount of memory in MiB"
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
