terraform {
  cloud {
    organization = "capstone-adityapwr"
    workspaces {
      name = "ji-capstone"
    }
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.42.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "ji_capstone" {
  name     = "jicapstone"
  location = "Central India"
}

resource "azurerm_storage_account" "ji_capstone" {
  name                     = "jicapstone"
  resource_group_name      = azurerm_resource_group.ji_capstone.name
  location                 = azurerm_resource_group.ji_capstone.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_mssql_server" "mysql_server" {
  name                         = "capstonesqlserver"
  resource_group_name          = azurerm_resource_group.ji_capstone.name
  location                     = azurerm_resource_group.ji_capstone.location
  version                      = "12.0"
  administrator_login          = var.db_username
  administrator_login_password = var.db_password
}

resource "azurerm_mssql_database" "mysql_db" {
  name           = "capstonesqldb"
  server_id      = azurerm_mssql_server.mysql_server.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 10
  read_scale     = true
  sku_name       = "S0"
  zone_redundant = true

  tags = {
    Environment = "Production"
  }
}
