output "consul_server" {
  value = {
    name = module.consul_server.simple_vm_name,
    ip   = module.consul_server.simple_external_ip,
    port = 8500
  }
}
output "nomad_server" {
  value = {
    name = module.nomad_server.simple_vm_name,
    ip   = module.nomad_server.simple_external_ip
  }
}
output "nomad_client" {
  value = {
    name = module.nomad_client.simple_vm_name,
    ip   = module.nomad_client.simple_external_ip,
    port = 4646
  }
}
output "project_id" {
  value = var.project_id
}