module "simple_fixture" {
  source = "../../../example/consul_nomad_example/"

  project_id = var.project_id

  metadata = {
    sshKeys = "integer:${file("~/.ssh/id_rsa.pub")}"
  }
}

