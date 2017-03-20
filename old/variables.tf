variable "access_key" {}
variable "secret_key" {}

variable "region" {
    default = "us-west-2"
}

variable "ami" {
    default = "ami-9abea4fb" // ubuntu 14.04
}

variable "key-name" {
    default = "Hum_do"
}

variable "key-path" {
    default = "Hum_do.pem"
}

variable "user" {
    default = "ubuntu"
}

//-------------------------------------------------------------------
// Vault settings
//-------------------------------------------------------------------
variable "configuration" {
    default = ""
}

variable "extra-install" {
    default = ""
}

variable "zones" {
    default = "us-west-2a"
}

variable "instance-vault" {
    default = "t2.micro"
}

variable "nodes-vault" {
    default = "3"
}

//-------------------------------------------------------------------
// Consul settings
//-------------------------------------------------------------------
variable "instance-consul" {
    default = "t2.micro"
}

variable "nodes-consul" {
    default = "3"
}
