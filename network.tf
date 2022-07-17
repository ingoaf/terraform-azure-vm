resource "azurerm_virtual_network" "ingoaf-vn" {
  name                = "ingoaf-network"
  resource_group_name = azurerm_resource_group.ingoaf-rg.name
  location            = azurerm_resource_group.ingoaf-rg.location
  address_space       = ["10.123.0.0/16"]

  tags = {
    environment = "dev"
  }
}

resource "azurerm_subnet" "ingoaf-subnet" {
  name                 = "ingoaf-subnet"
  resource_group_name  = azurerm_resource_group.ingoaf-rg.name
  virtual_network_name = azurerm_virtual_network.ingoaf-vn.name
  address_prefixes     = ["10.123.1.0/24"]
}

resource "azurerm_network_security_group" "ingoaf-sg" {
  name                = "ingoaf-sg"
  location            = azurerm_resource_group.ingoaf-rg.location
  resource_group_name = azurerm_resource_group.ingoaf-rg.name

  tags = {
    "environment" = "dev"
  }
}

resource "azurerm_network_security_rule" "ingoaf-dev-rule" {
  name                        = "ingoaf-dev-rule"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = var.my_ip_address
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.ingoaf-rg.name
  network_security_group_name = azurerm_network_security_group.ingoaf-sg.name
}

resource "azurerm_subnet_network_security_group_association" "ingoaf-sga" {
  subnet_id                 = azurerm_subnet.ingoaf-subnet.id
  network_security_group_id = azurerm_network_security_group.ingoaf-sg.id
}

resource "azurerm_public_ip" "ingoaf-ip" {
  name                = "ingoaf-ip"
  resource_group_name = azurerm_resource_group.ingoaf-rg.name
  location            = azurerm_resource_group.ingoaf-rg.location
  allocation_method   = "Dynamic"

  tags = {
    environment = "dev"
  }
}

resource "azurerm_network_interface" "ingoaf-nic" {
  name                = "ingoaf-nic"
  location            = azurerm_network_security_group.ingoaf-sg.location
  resource_group_name = azurerm_resource_group.ingoaf-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.ingoaf-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ingoaf-ip.id
  }

  tags = {
    "environment" = "dev"
  }
}