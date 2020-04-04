variable "vnet_name" {
  description = "Name of the vnet to create"
}
variable "location" {
}
variable "resource_group_name" {
}
variable "address_space" {
  description = "The address space that is used by the virtual network."
}
variable "subnet_prefix" {
  description = "The address prefix to use for the subnet."
}
variable "subnet_name" {
  description = "A list of public subnets inside the vNet."
}
variable "resource_prefix" {
}
variable "tags" {
  description = "The tags to associate with your network and subnets."
  type        = "map"

  default = {
    tag1 = ""
    tag2 = ""
  }
}
