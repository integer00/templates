output "project_id" {
  value = module.simple_fixture.project_id
}

output "consul_server" {
  value = module.simple_fixture.consul_server
}
output "nomad_server" {
  value = module.simple_fixture.nomad_server
}
output "nomad_client" {
  value = module.simple_fixture.nomad_client
}