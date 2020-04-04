
output "ip_address" {
  value = azurerm_public_ip.public_ip.ip_address
}

output "private_ip_address" {
  value = azurerm_network_interface.nic.private_ip_address
}