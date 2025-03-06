# קבלת מידע על קלאסטר ה-AKS הקיים
data "azurerm_kubernetes_cluster" "existing" {
  name                = var.kubernetes_cluster_name
  resource_group_name = var.resource_group_name
}

# קבלת שם ה-NSG
data "azurerm_resources" "node_nsg" {
  resource_group_name = data.azurerm_kubernetes_cluster.existing.node_resource_group
  type                = "Microsoft.Network/networkSecurityGroups"
}

# הוספת כלל HTTP לאפשר גישה בפורט 80
resource "azurerm_network_security_rule" "allow_ingress_http" {
  name                        = "AllowIngressHTTP"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_kubernetes_cluster.existing.node_resource_group
  network_security_group_name = data.azurerm_resources.node_nsg.resources[0].name
}

# הוספת כלל HTTPS לאפשר גישה בפורט 443
resource "azurerm_network_security_rule" "allow_ingress_https" {
  name                        = "AllowIngressHTTPS"
  priority                    = 1002
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_kubernetes_cluster.existing.node_resource_group
  network_security_group_name = data.azurerm_resources.node_nsg.resources[0].name
}