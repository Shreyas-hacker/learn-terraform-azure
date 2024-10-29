resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name = "rg-terraform-VM"
}

# Managed Identity
resource "azurerm_user_assigned_identity" "vm_identity" {
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  name = "vm-managed-identity"
}

data "azurerm_storage_account" "existing" {
  name                = "shreyastesting"
  resource_group_name = "testing"
}

# Give permissions to the managed identity to access the storage account
resource "azurerm_role_assignment" "vm_storage_role" {
  scope                = data.azurerm_storage_account.existing.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.vm_identity.principal_id
}

# Create virtual network
resource "azurerm_virtual_network" "my_terraform_network" {
  name = "terraform-VM-network"
  address_space = [ "10.0.0.0/16" ]
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Create subnet
resource "azurerm_subnet" "my_terraform_subnet" {
  name = "terraform-VM-subnet"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.my_terraform_network.name
  address_prefixes = [ "10.0.1.0/24" ]
}

# Create public IPs
resource "azurerm_public_ip" "my_terraform_public_ip" {
  name = "terraform-VM-public-ip"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method = "Dynamic"
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "my_terraform_nsg" {
  name = "terraform-VM-nsg"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  # This rule allows all external connections from internet to SSH port
  security_rule {
    name = "SSH"
    priority = 1001
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "22"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }
}

# Create network interface
resource "azurerm_network_interface" "my_terraform_nic" {
  name = "terraform-VM-nic"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name = "terraform-nic-configuration"
    subnet_id = azurerm_subnet.my_terraform_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.my_terraform_public_ip.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "my-nsg-assoc" {
  network_interface_id      = azurerm_network_interface.my_terraform_nic.id
  network_security_group_id = azurerm_network_security_group.my_terraform_nsg.id
}

# Create (and display) an SSH key
resource "tls_private_key" "secureadmin_ssh" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "local_file" "ssh_key" {
  filename = "./.ssh/id_rsa.pem"
  content = tls_private_key.secureadmin_ssh.private_key_pem
  file_permission = "0600"
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "my_terraform_vm" {
  name = "terraform-VM"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  network_interface_ids = [ azurerm_network_interface.my_terraform_nic.id ]
  size = "Standard_DS1_v2"

  computer_name = "terraform-vm"
  admin_username = var.username
  disable_password_authentication = true
  
  admin_ssh_key {
    username = var.username
    public_key = tls_private_key.secureadmin_ssh.public_key_openssh
  }

  identity {
    type = "UserAssigned"
    identity_ids = [ azurerm_user_assigned_identity.vm_identity.id ]
  }

  os_disk {
    name = "terraform-VM-osdisk"
    caching = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}

resource "null_resource" "vm-provision" {
  depends_on = [ azurerm_linux_virtual_machine.my_terraform_vm, azurerm_virtual_machine_extension.example ]

  provisioner "remote-exec" {
    connection {
      host = azurerm_linux_virtual_machine.my_terraform_vm.public_ip_address
      type = "ssh"
      user = var.username
      private_key = tls_private_key.secureadmin_ssh.private_key_pem
    }
    inline = [ 
      "sudo mkdir tmp",
      "sudo chmod 777 tmp",
    ]
  }
  
  provisioner "file" {
    connection {
      host = azurerm_linux_virtual_machine.my_terraform_vm.public_ip_address
      type = "ssh"
      user = var.username
      private_key = tls_private_key.secureadmin_ssh.private_key_pem
    }
    source = "./testing"
    destination = "./tmp"
  }
}

resource "azurerm_virtual_machine_extension" "example" {
  name = "hostname"
  virtual_machine_id = azurerm_linux_virtual_machine.my_terraform_vm.id
  publisher = "Microsoft.Azure.Extensions"
  type = "CustomScript"
  type_handler_version = "2.0"

  protected_settings = <<PROT
    {
        "script": "${base64encode(file("setup.sh"))}"
    }
    PROT
}