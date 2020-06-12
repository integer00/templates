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