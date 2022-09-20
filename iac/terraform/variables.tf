variable "location" {
  type        = string
  description = "(Optional) The location for resource deployment"
  default     = "westeurope"
}

variable "environment" {
  type        = string
  description = "(Required) Three character environment name"
  default     = "d"

  validation {
    condition     = length(var.environment) <= 3
    error_message = "Err: Environment cannot be longer than three characters."
  }
}

variable "project" {
  type        = string
  description = "(Required) The project name"
  default     = "adb"
}

variable "databricks_sku" {
  type        = string
  description = "(Optional) The SKU to use for the databricks instance"
  default     = "standard"

  validation {
    condition     = can(regex("standard|premium|trial", var.databricks_sku))
    error_message = "Err: Valid options are 'standard', 'premium' or 'trial'."
  }
}
