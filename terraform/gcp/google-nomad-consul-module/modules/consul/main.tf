locals {
  local_metadata = {
    startup-script = data.template_file.init_consul.rendered
  }
  local_tags = ["consul-ui-external"]

}

data "template_file" "init_consul" {
  template = file("${path.module}/templates/install_consul.tpl")

  vars = {
    #dirty hack //todo fixme
    internal_ip = join("\",\"", google_compute_address.consul_vm_internal_address[*].address)
    num_nodes   = var.vm_count
  }
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

resource "google_compute_instance" "consul_vm" {
  project      = var.project_id
  name         = "${var.instance_name}${count.index}"
  count        = var.vm_count
  machine_type = var.instance_machine_type
  zone         = var.instance_zone
  tags = concat(
    var.tags,
    local.local_tags
  )

  allow_stopping_for_update = "false"

  boot_disk {
    source = google_compute_disk.consul_vm_disk[count.index].name
  }

  metadata = merge(
    var.metadata,
    local.local_metadata
  )

  network_interface {
    subnetwork = data.google_compute_subnetwork.data_subnetwork.self_link
    network_ip = google_compute_address.consul_vm_internal_address[count.index].address

    access_config {

    }
  }
}


resource "google_compute_disk" "consul_vm_disk" {
  project = var.project_id
  name    = "${var.instance_name}${count.index}-disk"
  count   = var.vm_count
  type    = var.disk_type
  size    = var.disk_size
  zone    = var.instance_zone
  image   = var.instance_image

  physical_block_size_bytes = 4096
}

resource "google_compute_address" "consul_vm_internal_address" {
  project    = var.project_id
  count      = var.vm_count
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
    ports    = ["8500"]
  }

  target_tags = ["consul-ui-external"]
}