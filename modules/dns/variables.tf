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

variable "zone_name" {
  type    = string
  default = null
}

variable "record_name" {
  type    = string
  default = "agent"
}

variable "route_name" {
  type    = string
  default = ""
}

variable "namespace" {
  type    = string
  default = "superblocks"
}
