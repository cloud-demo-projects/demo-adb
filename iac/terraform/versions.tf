terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 1.0"
    }
    databricks = {
      source = "databricks/databricks"
      # source = "databrickslabs/databricks"
      # version = "0.5.4"
    }
  }
}
