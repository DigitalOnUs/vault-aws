variable "os_user" {
  default = "ubuntu"
}

variable "os_name_filter" {
  default = "ubuntu/images/hvm/ubuntu-trusty-14.04-amd64-server-*"
}

variable "os_owner_filter" {
  default = "099720109477" # Canonical
}

data "aws_ami" "main" {
  most_recent = true

  filter {
    name   = "name"
    values = ["${var.os_name_filter}"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["${var.os_owner_filter}"]
}

output "base_image" {
  value = "${data.aws_ami.main.id}"
}

output "base_image_name" {
  value = "${data.aws_ami.main.name}"
}

output "base_user" {
  value = "${var.os_user}"
}
