variable "project_id" {
  description = "The project ID to deploy to"
}

variable "metadata" {
  type    = map(string)
  default = {}
}
variable "tags" {
  default = []
  type    = list(string)
}
variable "vm_count" {
  default = 1
}
variable "instance_machine_type" {
  default = "n1-standard-1"
}
variable "instance_zone" {
  default = "europe-west2-a"
}
variable "network" {
  default = "default"
}
variable "subnetwork" {
  default = "default"
}
variable "instance_name" {
  default = "consul-node"
}
variable "disk_type" {
  default = "pd-standard"
}
variable "disk_size" {
  default = "20"
}
variable "instance_image" {
  default = "centos-7-v20200521"
}
variable "instance_region" {
  default = "europe-west2"
}