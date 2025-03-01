variable "resource_group_name" {
  description = "Name of the resource group"
  default     = "orel-neto-project"
}

variable "location" {
  description = "Azure region"
  default     = "westeurope"
}

variable "cluster_name" {
  description = "Name of the AKS cluster"
  default     = "gifapp-aks"
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  default     = "1.31.5"
}

variable "node_count" {
  description = "Number of nodes in the default node pool"
  default     = 1
}

variable "vm_size" {
  description = "VM size for nodes"
  default     = "Standard_B2s"
}