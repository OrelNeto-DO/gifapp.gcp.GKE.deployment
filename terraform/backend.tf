terraform {
  backend "azurerm" {
    resource_group_name  = "orel-neto-project"
    storage_account_name = "devops1114" 
    container_name       = "devops1114blob"         
    key                  = "gifapp.terraform.tfstate"
    # use_azuread_auth     = true              
  }
}