output "project_id" {
  value = var.project_id
}
output "instance_name" {
  value = var.instance_name
}
output "instance_zone" {
  value = var.instance_zone
}
output "public_ip" {
  value = google_compute_instance.simple_vm[*].network_interface[0].access_config[0].nat_ip
}