variable "region" {}
variable "env_name" {}

variable "os" {
  default = "ubuntu"
}

variable "consul_server_nodes" {
  default = "3"
}
