module "consul_server" {
  source = "../../modules/consul/"

  project_id    = var.project_id
  vm_count      = 3
  instance_name = "consul-server-node"

  metadata = {
  sshKeys = "int:${file("~/.ssh/id_rsa.pub")}"
  }
}
