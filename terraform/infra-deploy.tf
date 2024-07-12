provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "azure-multi"
  location = "northeurope"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "dev-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  address_space = ["10.0.0.0/16"]
}

resource "azurerm_app_service_plan" "appServicePlan" {
  name                = "dev-appServicePlan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku {
    tier = "Free"
    size = "F1"
  }
}

resource "azurerm_app_service" "webApp" {
  name                = "unique-dev-webapp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  app_service_plan_id = azurerm_app_service_plan.appServicePlan.id
}

resource "azurerm_sql_server" "sqlServer" {
  name                         = "devcloud-sqlserver"
  location                     = azurerm_resource_group.rg.location
  resource_group_name          = azurerm_resource_group.rg.name
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = "P@ssw0rd"
}

resource "azurerm_sql_database" "sqlDatabase" {
  name                = "devcloud-database"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_sql_server.sqlServer.name

  collation     = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb   = 2
  edition       = "Standard"
  requested_service_objective_name = "S0"
}
