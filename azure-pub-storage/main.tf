provider "azurerm" {
  version = "2.35.0"
  features {}
}

resource "random_string" "storage-acc-name" {
  length = 12
  lower = true
  upper = false
  special = false
}

resource "azurerm_resource_group" "rg-public-storage-acc" {
  location = "East US"
  name = "RG_public_storage_acc_TF"
}

resource "azurerm_storage_account" "public-storage-acc" {
  name                     = "${random_string.storage-acc-name.result}pubstorage"
  resource_group_name      = azurerm_resource_group.rg-public-storage-acc.name
  location                 = azurerm_resource_group.rg-public-storage-acc.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  enable_https_traffic_only = false
  allow_blob_public_access = true
}

resource "azurerm_storage_container" "public-storage-container" {
  name                  = "${random_string.storage-acc-name.result}pubblob"
  storage_account_name  = azurerm_storage_account.public-storage-acc.name
  container_access_type = "blob"
}

resource "azurerm_storage_blob" "public-storage-blob" {
  name                   = "fake.zip"
  storage_account_name   = azurerm_storage_account.public-storage-acc.name
  storage_container_name = azurerm_storage_container.public-storage-container.name
  type                   = "Page"
  size                   = 512
  source                 = "some-local-file.zip"
}