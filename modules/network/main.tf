



resource "azurerm_virtual_network" "vnet" {
  name                = "${var.name_prefix}-vnet"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space

  tags = var.tags

}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.name_prefix}-snet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_address_prefix
}

resource "azurerm_subnet" "data" {
  name                 = "${var.name_prefix}-data-subnet"   # samme mønster som subnettet som står der
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]           # ledig blokk i 10.0.0.0/16
}