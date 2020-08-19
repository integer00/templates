output "project_id" {
  value = var.project_id
}
output "consul_server" {
  value = {
    name = module.consul_server.simple_vm_name,
    ip   = module.consul_server.simple_external_ip,
    port = 8500
  }
}
