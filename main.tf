# Generate random text for a unique storage account name
resource "random_id" "random_id" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = var.azurerm_resource_group
  }

  byte_length = 2
}

resource "random_pet" "pl_name" {
  prefix = var.resource_group_name_prefix
}

# Create public IPs
resource "azurerm_public_ip" "my_terraform_public_ip" {
  name                = "FshareVM${random_id.random_id.hex}"
  location            = var.resource_group_location
  resource_group_name = var.azurerm_resource_group
  allocation_method   = "Dynamic"
}

data "azurerm_subnet" "azurerm_subnet" {
  name                 = var.azurerm_subnet
  virtual_network_name = var.azurerm_virtual_network
  resource_group_name  = var.azurerm_resource_group
}

data "azurerm_network_security_group" "azurerm_sg" {
  #for_each = var.azurerm_network_security_group
  name                = var.azurerm_network_security_group
  resource_group_name = var.azurerm_resource_group
}

# # Create Network Security Group and rule
# resource "azurerm_network_security_group" "my_terraform_nsg" {
#   name                = "myNetworkSecurityGroup"
#   location            = var.resource_group_location
#   resource_group_name = var.azurerm_resource_group

#   security_rule {
#     name                       = "SSH"
#     priority                   = 1001
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "22"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
# }

# Create network interface
resource "azurerm_network_interface" "my_terraform_nic" {
  name                = "FshareVM${random_id.random_id.hex}"
  location            = var.resource_group_location
  resource_group_name = var.azurerm_resource_group

  ip_configuration {
    name                          = "FshareVM${random_id.random_id.hex}"
    subnet_id                     = data.azurerm_subnet.azurerm_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my_terraform_public_ip.id
  }
}


# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  #for_each = data.azurerm_network_security_group.azurerm_sg
  network_interface_id      = azurerm_network_interface.my_terraform_nic.id
  network_security_group_id = data.azurerm_network_security_group.azurerm_sg.id
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "my_terraform_vm" {
  name                  = "FshareVM${random_id.random_id.hex}"
  location              = var.resource_group_location
  resource_group_name   = var.azurerm_resource_group
  network_interface_ids = [azurerm_network_interface.my_terraform_nic.id]
  size                  = "Standard_B1s"

  os_disk {
    name                 = "FshareVM${random_id.random_id.hex}"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "FshareVM${random_id.random_id.hex}"
  admin_username                  = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("id_rsa.pub")
  }
}

resource "null_resource" "run-localexec" {
  provisioner "local-exec" {
    command = "ansible-playbook  -i ${azurerm_linux_virtual_machine.my_terraform_vm.public_ip_address} ./ansible/main.yml --extra-vars 'ansible_user=azureuser ansible_ssh_private_key_file=/opt/deploy_id_rsa'"
  }
}