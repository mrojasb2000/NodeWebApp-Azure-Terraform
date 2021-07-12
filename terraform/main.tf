# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.65.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

#Create Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.environment}-${var.project}"
  location = var.location
}

resource "azurerm_app_service_plan" "app_service_plan" {
  name                = "sp-${var.environment}-${var.project}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "Linux"
  reserved            = true
  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "dockerapp" {
  name                = "${azurerm_resource_group.rg.name}-dockerapp"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  app_service_plan_id = "${azurerm_app_service_plan.app_service_plan.id}"

  # Do not attach Storage by default
  app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = false
    DOCKER_REGISTRY_SERVER_URL      = "https://hub.docker.com/"
    DOCKER_REGISTRY_SERVER_USERNAME = "${var.docker_hub_username}"
    DOCKER_REGISTRY_SERVER_PASSWORD = "${var.docker_hub_password}"

    /*
    # Settings for private Container Registires  
    DOCKER_REGISTRY_SERVER_URL      = ""
    DOCKER_REGISTRY_SERVER_USERNAME = ""
    DOCKER_REGISTRY_SERVER_PASSWORD = ""
    */
  }

  # Configure Docker Image to load on start
  site_config {
    linux_fx_version = "DOCKER|${var.docker_image}:${var.docker_image_tag}"
    always_on        = "true"
  }

  identity {
    type = "SystemAssigned"
  }
}