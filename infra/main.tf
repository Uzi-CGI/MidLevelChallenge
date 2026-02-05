terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# --------------------
# VARIABLES
# --------------------
variable "location" {
  default = "westeurope"
}

variable "resource_group_name" {
  default = "CloudChallenge"
}

variable "aks_cluster_name" {
  default = "aks-challenge"
}

variable "node_count" {
  default = 2
}

variable "node_size" {
  default = "Standard_B2s"
}

# --------------------
# RESOURCE GROUP
# --------------------
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags = {
        "author"  = "uzeyir.mammadov"
        "purpose" = "InterviewChallenge"
    }
}

# --------------------
# AKS CLUSTER
# --------------------
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_cluster_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.aks_cluster_name

  default_node_pool {
    name                = "agentpool"
    node_count          = var.node_count
    vm_size             = var.node_size
    enable_auto_scaling = true
    min_count           = 2
    max_count           = 4
  }

  identity {
    type = "SystemAssigned"
  }
}
