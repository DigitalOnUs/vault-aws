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
// Network
//

resource "aws_vpc" "main" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags {
    Name = "${var.env_name}"
  }
}

resource "aws_subnet" "main" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${var.vpc_cidrs}"
  map_public_ip_on_launch = true

  tags {
    Name = "${var.env_name}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "${var.env_name}"
  }
}

resource "aws_route_table" "main" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main.id}"
  }

  tags {
    Name = "${var.env_name}"
  }
}

resource "aws_route_table_association" "main" {
  subnet_id      = "${aws_subnet.main.id}"
  route_table_id = "${aws_route_table.main.id}"
}

//
// Firewall
//

resource "aws_security_group" "default_egress" {
  name       = "${var.env_name}-egress"
  vpc_id     = "${aws_vpc.main.id}"
  depends_on = ["aws_route_table_association.main"]

  egress {
    protocol     = "-1"
    from_port    = 0
    to_port      = 0
    cidr_blocks  = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "admin" {
  name        = "${var.env_name}-admin"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    protocol     = "tcp"
    from_port    = 22
    to_port      = 22
    cidr_blocks  = ["0.0.0.0/0"]
  }

  //ingress {
  //  protocol     = "tcp"
  //  from_port    = 8500
  //  to_port      = 8500
  //  cidr_blocks  = ["0.0.0.0/0"]
  //}

  //ingress {
  //  protocol     = "tcp"
  //  from_port    = 8200
  //  to_port      = 8200
  //  cidr_blocks  = ["0.0.0.0/0"]
  //}
}

resource "aws_security_group" "internal" {
  name        = "${var.env_name}-internal"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    protocol   = "tcp"
    from_port  = 1
    to_port    = 65535
    self       = true
  }

  ingress {
    protocol   = "udp"
    from_port  = 1
    to_port    = 65535
    self       = true
  }
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
    "${aws_security_group.default_egress.id}",
    "${aws_security_group.admin.id}",
    "${aws_security_group.internal.id}",
  ]

  tags {
    Name = "${var.env_name}-consul-${count.index}"
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
    "${aws_security_group.default_egress.id}",
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
