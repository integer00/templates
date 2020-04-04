# Data contains dns-zone from infra
data "azurerm_dns_zone" "dns_zone" {
  name = "my_dns_zone"
}

# A records
resource "azurerm_dns_a_record" "a_record" {
  name                = var.a_record
  zone_name           = data.azurerm_dns_zone.dns_zone.name
  resource_group_name = data.azurerm_dns_zone.dns_zone.resource_group_name
  ttl                 = 60
  records             = [var.compute_ip_address]
}