variable "access_key" {}
variable "secret_key" {}
variable "ssh_key_name" {}

variable "region" {
  default = "us-west-2"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "os" {
  default = "ubuntu"
}

variable "env_name" {
  default = "DevSecOps"
}

variable "consul_nodes" {
  default = "1"
}

variable "vault_nodes" {
  default = "1"
}

variable "vpc_cidr" {
  default = "172.30.0.0/16"
}

variable "vpc_cidrs" {
  default = "172.30.0.0/20"
}
