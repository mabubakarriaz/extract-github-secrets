terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = true
  features {}
}

variable "subscription_id" {
  description = "The subscription ID where the resources will be created"
}

variable "resource_group_name" {
  description = "The name of the resource group where the resources will be created"
}


# Define variables
# Data source to reference an existing resource group
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

variable "location" {
  description = "The Azure location where the resources will be created"
  default     = "eastus"
}

# Use the random string to create unique names
variable "storage_account_name_prefix" {
  default = "extractgithub"
}

# Azure table name
variable "storage_table_name" {
  default = "KeyValueTable"
}

variable "app_service_name_prefix" {
  default = "extract-github-secrets-"
}

variable "docker_registry_url" {
  default = "https://ghcr.io"
}

variable "docker_image_name" {
  default = "mabubakarriaz/extract-github-secrets:latest"
}

# Generate random string for uniqueness
resource "random_string" "random" {
  length  = 8
  special = false
  upper   = false
}

# Storage Account
resource "azurerm_storage_account" "storage" {
  name                     = "${var.storage_account_name_prefix}${random_string.random.result}"
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  enable_https_traffic_only = true

  blob_properties {
    delete_retention_policy {
      days = 7
    }
  }

  large_file_share_enabled = true

  tags = {
    created-by = "abubakar-terraform"
  }
}

# Create Azure Table in Storage Account
resource "azurerm_storage_table" "table" {
  name                 = "${var.storage_table_name}"
  storage_account_name = azurerm_storage_account.storage.name
}

# App Service Plan
resource "azurerm_service_plan" "asp" {
  name                = "${var.app_service_name_prefix}${random_string.random.result}-plan"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "F1"

  tags = {
    created-by = "abubakar-terraform"
  }
}

# App Service
resource "azurerm_linux_web_app" "app" {
  name                = "${var.app_service_name_prefix}${random_string.random.result}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    ftps_state = "FtpsOnly"
    always_on  = false
    
    application_stack {
      docker_image_name = var.docker_image_name
      docker_registry_url = var.docker_registry_url
    }
  }

  app_settings = {
    "STORAGE_CONNECTION_STRING"  = azurerm_storage_account.storage.primary_connection_string
  }

  tags = {
    created-by = "abubakar-terraform"
  }
}

# Outputs
output "storage_account_name" {
  value = azurerm_storage_account.storage.name
}

output "app_service_domain" {
  value = azurerm_linux_web_app.app.default_hostname
}