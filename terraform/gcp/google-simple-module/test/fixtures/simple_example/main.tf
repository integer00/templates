resource "tls_private_key" "fixture-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "fixture-private-key" {
  content  = tls_private_key.fixture-key.private_key_pem
  filename = "${path.module}/.kitchen/ssh/key"
}

module "simple_fixture" {
  source = "../../../example/simple_example"

  project_id = var.project_id

  metadata = {
    sshKeys = "ci:${tls_private_key.fixture-key.public_key_openssh}"
  }
}
