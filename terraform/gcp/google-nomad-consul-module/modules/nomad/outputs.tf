output "simple_external_ip" {
  value = google_compute_instance.nomad_vm[*].network_interface[0].access_config[0].nat_ip
}
output "simple_vm_name" {
  value = google_compute_instance.nomad_vm[*].name
}
output "project_id" {
  value = var.project_id
}