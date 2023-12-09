provider "azurerm" {
  alias           = "stage1"
  subscription_id = "yyy"
  tenant_id       = "xxx"

  features {}
}

provider "azurerm" {
  alias           = "prod1"
  subscription_id = "yyy"
  tenant_id       = "xxx"

  features {}
}

#endregion

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "jobathon" {
  name     = "jobathon-resource-group"
  location = "East US"
}

resource "azurerm_virtual_network" "jobathon" {
  name                = "jobathon-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.jobathon.location
  resource_group_name = azurerm_resource_group.jobathon.name
}

resource "azurerm_postgresql_server" "jobathon" {
  name                = "jobathon-db-server"
  resource_group_name = azurerm_resource_group.jobathon.name
  location            = azurerm_resource_group.jobathon.location
  version             = "11"
  administrator_login = "adminuser"
  administrator_login_password = "adminpassword"

  sku_name = "GP_Gen5_2"
  ssl_enforcement_enabled = true  # Set this according to your security requirements

  storage_mb = 51200

  tags = {
    environment = "dev"
  }
}


resource "azurerm_postgresql_database" "jobathon" {
  name                = "jobathon-database"
  resource_group_name = azurerm_resource_group.jobathon.name
  server_name         = azurerm_postgresql_server.jobathon.name
  charset             = "UTF8"
  collation           = "Arabic_CI_AI"
}

resource "azurerm_app_service_plan" "jobathon" {
  name                = "jobathon-app-service-plan"
  resource_group_name = azurerm_resource_group.jobathon.name
  location            = azurerm_resource_group.jobathon.location
  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "jobathon" {
  name                = "jobathon-app-service"
  resource_group_name = azurerm_resource_group.jobathon.name
  location            = azurerm_resource_group.jobathon.location
  app_service_plan_id = azurerm_app_service_plan.jobathon.id

  site_config {
    linux_fx_version = "DOCKER|docker-image-name"
    always_on        = true
  }

  app_settings = {
    "FLASK_ENV" = "production"
    "DATABASE_URL" = "postgresql://${azurerm_postgresql_server.jobathon.name}.postgres.database.azure.com:5432/${azurerm_postgresql_database.jobathon.name}?sslmode=require&user=${azurerm_postgresql_server.jobathon.administrator_login}@${azurerm_postgresql_server.jobathon.name}&password=${azurerm_postgresql_server.jobathon.administrator_login_password}"
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = "your_actual_application_insights_connection_string"
    "APPLICATIONINSIGHTS_ROLE_NAME"         = "jobathon-app-service"
  }
}




output "app_url" {
  value = azurerm_app_service.jobathon.default_site_hostname
}
