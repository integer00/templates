# Configure the Azure Provider
provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "=1.38.0"

}

# Data to populate inventory file
data "template_file" "hosts" {
  template = file("${path.module}/templates/hosts.cfg")
  vars = {
    prefix = var.resource_prefix
    hosts  = join("\n", azurerm_network_interface.nic.*.private_ip_address)
  }
}

resource "null_resource" "ansible_hosts" {
  triggers = {
    template_rendered = data.template_file.hosts.rendered
    build_number      = timestamp() //will execute every time
  }
  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = "echo '${data.template_file.hosts.rendered}' > inventory"
  }
}

resource "azurerm_public_ip" "public_ip" {
  name                = "${var.resource_prefix}-public-ip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "nic" {
  name                = "${var.resource_prefix}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  network_security_group_id = var.security_group_id


  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

resource "azurerm_virtual_machine" "vm" {
  name                  = var.hostname
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.nic.id]

  vm_size                          = var.vm_type
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7.6"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.resource_prefix}-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    disk_size_gb      = var.os_disk_size_gb
  }

  os_profile {
    computer_name  = var.hostname
    admin_username = var.admin_user
  }

  identity {
    type = "SystemAssigned"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/${var.admin_user}/.ssh/authorized_keys"
      key_data = var.admin_ssh_key
    }
  }
}
