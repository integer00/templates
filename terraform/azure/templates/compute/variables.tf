variable "resource_group_name" {
}
variable "location" {
}
variable "subnet_id" {
}
variable "resource_prefix" {
}
variable "hostname" {
}
variable "vm_type" {
  default = "Standard_B2s"
}
variable "os_disk_size_gb" {
  default = "30"
}
variable "security_group_id" {
}
variable "admin_user" {
}
variable "admin_ssh_key" {
}