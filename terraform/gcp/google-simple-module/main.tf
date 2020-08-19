locals {
  local_tags = ["simple-firewall"]
}

data "google_compute_network" "data_network" {
  project = var.project_id
  name    = var.network
}

data "google_compute_subnetwork" "data_subnetwork" {
  project = var.project_id
  name    = var.subnetwork
  region  = var.instance_region
}


resource "google_compute_instance" "simple_vm" {
  count        = var.instance_count
  project      = var.project_id
  name         = "${var.instance_name}${count.index}"
  machine_type = var.instance_machine_type
  zone         = var.instance_zone
  tags = concat(
  var.tags,
  local.local_tags
  )

  allow_stopping_for_update = "false"

  boot_disk {
    source = google_compute_disk.simple_vm_disk[count.index].name
  }

  metadata = merge(
    var.metadata
  )

  network_interface {
    subnetwork = data.google_compute_subnetwork.data_subnetwork.self_link
    network_ip = google_compute_address.simple_vm_internal_address[count.index].address

    access_config {

    }
  }

}

resource "google_compute_disk" "simple_vm_disk" {
  count   = var.instance_count
  project = var.project_id
  name    = "${var.instance_name}${count.index}-disk"
  type    = var.disk_type
  size    = var.disk_size
  zone    = var.instance_zone
  image   = var.instance_image

  physical_block_size_bytes = 4096
}

resource "google_compute_address" "simple_vm_internal_address" {
  count      = var.instance_count
  project    = var.project_id
  name       = "${var.instance_name}${count.index}-internal-address"
  region     = var.instance_region
  subnetwork = data.google_compute_subnetwork.data_subnetwork.name

  address_type = "INTERNAL"
}

resource "google_compute_firewall" "simple_vm_allow_external" {
  project = var.project_id
  name    = "${var.instance_name}-firewall-rule"
  network = data.google_compute_network.data_network.name

  allow {
    protocol = "tcp"
    ports    = var.ports
  }

  target_tags = ["simple-firewall"]
}