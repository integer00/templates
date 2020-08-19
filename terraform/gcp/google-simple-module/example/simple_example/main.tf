module "simple_example" {
  source = "../../"
  instance_count = 3
  project_id = var.project_id

  ports = ["8091"]

  metadata = {
    sshKeys = "integer:${file("~/.ssh/id_rsa.pub")}"
  }

}
