variable "project_id" {
  description = "The ID of the project in which to provision resources."
  type        = string
}

variable "metadata" {
  type    = map(string)
  default = {}
}
variable "instance_count" {
  default = "1"
}