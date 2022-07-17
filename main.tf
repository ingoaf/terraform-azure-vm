terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.91.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "ingoaf-rg" {
  name     = "ingoaf-resources"
  location = "West Europe"
  tags = {
    environment = "dev"
  }
}

resource "azurerm_linux_virtual_machine" "ingoaf-vm" {
  name                  = "ingoaf-vm"
  resource_group_name   = azurerm_resource_group.ingoaf-rg.name
  location              = azurerm_resource_group.ingoaf-rg.location
  size                  = "Standard_B1s"
  admin_username        = "adminuser"
  network_interface_ids = [azurerm_network_interface.ingoaf-nic.id]

  custom_data = filebase64("customdata.tpl")

  admin_ssh_key {
    username   = "adminuser"
    public_key = file(var.path_to_public_key)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  provisioner "local-exec" {
    command = templatefile("windows-ssh-script.tpl", {
      hostname     = self.public_ip_address,
      user         = "adminuser",
      identityfile = var.path_to_private_key
    })
    interpreter = [
      "Powershell", "-Command"
    ]
  }

  tags = {
    environment = "dev"
  }
}

data "azurerm_public_ip" "ingoaf-ip-data" {
  name                = azurerm_public_ip.ingoaf-ip.name
  resource_group_name = azurerm_resource_group.ingoaf-rg.name
}