module "consul_server" {
  source = "../../modules/consul/"

  project_id    = var.project_id
  vm_count      = 3
  instance_name = "consul-server-node"

  metadata = var.metadata
}

module "nomad_server" {
  source = "../../modules/nomad/"

  nomad_server  = true
  project_id    = var.project_id
  vm_count      = 1
  instance_name = "nomad-server-node"
  consul_server = module.consul_server.consul_server_ip

  metadata = var.metadata
}

module "nomad_client" {
  source = "../../modules/nomad/"

  nomad_server  = false
  project_id    = var.project_id
  vm_count      = 3
  instance_name = "nomad-client-node"

  consul_server = module.consul_server.consul_server_ip

  metadata = var.metadata
}