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
  type        = string
  default     = null
  description = "This is the name of Google DNS Managed Zone that in the same project"
}

variable "record_name" {
  type        = string
  default     = "agent"
  description = "This is the record that will be created in Google DNS Managed Zone"
}

variable "namespace" {
  type    = string
  default = "superblocks"
}
