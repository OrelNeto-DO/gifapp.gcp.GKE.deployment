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
  skip_provider_registration = true
}

# אנחנו משתמשים ב-resource group קיים
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

# AKS Cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  dns_prefix          = var.cluster_name
  kubernetes_version  = var.kubernetes_version

  default_node_pool {
    name                = "default"
    node_count          = var.node_count
    vm_size             = var.vm_size
    enable_auto_scaling = true
    min_count           = 1
    max_count           = 2
    zones               = ["1"]  # שימוש ב-zones במקום availability_zones
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "kubenet"  # יותר פשוט וחסכוני מ-azure CNI
    load_balancer_sku = "standard"
  }

  tags = {
    Environment = "Development"
    Project     = "GifApp"
    Creator     = "Orel"
  }
}