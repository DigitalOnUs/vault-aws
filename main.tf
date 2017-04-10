provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

module "shared" {
  source              = "scripts"
  os                  = "${var.os}"
  region              = "${var.region}"
  consul_server_nodes = "${var.consul_nodes}"
  env_name            = "${var.env_name}"
}

//
// Consul
//

resource "aws_instance" "server_consul" {
  ami           = "${module.shared.base_image}"
  instance_type = "${var.instance_type}"
  key_name      = "${var.ssh_key_name}"
  subnet_id     = "${aws_subnet.main.id}"

  vpc_security_group_ids = [
    "${aws_security_group.egress.id}",
    "${aws_security_group.admin.id}",
    "${aws_security_group.internal.id}",
  ]

  tags {
    Name                     = "${var.env_name}-consul-${count.index}"
    consul_server_datacenter = "${var.region}"
  }

  count = "${var.consul_nodes}"

  connection {
    user        = "${module.shared.base_user}"
    private_key = "${file("${var.ssh_key_name}.pem")}"
  }

  provisioner "remote-exec" {
    inline = ["${module.shared.install_consul_server}"]
  }
}

//
// Vault
//

resource "aws_instance" "server_vault" {
  ami           = "${module.shared.base_image}"
  instance_type = "${var.instance_type}"
  key_name      = "${var.ssh_key_name}"
  subnet_id     = "${aws_subnet.main.id}"

  vpc_security_group_ids = [
    "${aws_security_group.egress.id}",
    "${aws_security_group.admin.id}",
    "${aws_security_group.internal.id}",
  ]

  tags {
    Name = "${var.env_name}-vault-${count.index}"
  }

  count = "${var.vault_nodes}"

  connection {
    user        = "${module.shared.base_user}"
    private_key = "${file("${var.ssh_key_name}.pem")}"
  }

  provisioner "remote-exec" {
    inline = ["${module.shared.install_consul_client}"]
  }

  provisioner "remote-exec" {
    inline = [
      "${module.shared.install_vault_server}",
      "echo 'export VAULT_ADDR=http://localhost:8200' >> /home/${module.shared.base_user}/.bashrc",
    ]
  }
}

resource "null_resource" "vault" {
  connection {
    user        = "${module.shared.base_user}"
    host        = "${aws_instance.server_vault.public_ip}"
    private_key = "${file("${var.ssh_key_name}.pem")}"
  }

  provisioner "remote-exec" {
    inline = ["${data.template_file.init_vault.rendered}"]
  }
}
