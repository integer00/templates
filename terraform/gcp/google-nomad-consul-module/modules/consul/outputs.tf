output "simple_external_ip" {
  value = google_compute_instance.consul_vm[*].network_interface[0].access_config[0].nat_ip
}
output "simple_vm_name" {
  value = google_compute_instance.consul_vm[*].name
}
output "consul_server_ip" {
  value = google_compute_address.consul_vm_internal_address[0].address
}
output "project_id" {
  value = var.project_id
}