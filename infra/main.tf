terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = true
  features {}
}

# Define variables
variable "resource_group_name" {
  default = "1-9667ee4d-playground-sandbox"
}

variable "location" {
  default = "eastus"
}

variable "storage_account_name" {
  default = "extractgithubsecrets4544"
}

variable "app_service_plan_name" {
  default = "ASP-19667ee4dplaygroundsandbox-9efc"
}

variable "web_app_name" {
  default = "extract-github-secrets"
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Storage Account
resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  enable_https_traffic_only = true

  blob_properties {
    delete_retention_policy {
      days = 7
    }
  }

  large_file_share_enabled = true
}

# App Service Plan
resource "azurerm_service_plan" "asp" {
  name                = var.app_service_plan_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "F1"
}

# App Service
resource "azurerm_linux_web_app" "app" {
  name                = var.web_app_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    ftps_state = "FtpsOnly"
  }

  app_settings = {
    "DOCKER_REGISTRY_SERVER_URL" = "https://ghcr.io"
  }
}
