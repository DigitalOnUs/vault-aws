provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "${var.region}"
}

module "consul" {
    source = "./consul"
    key_name = "Hum_do"
    key_path = "Hum_do.pem"
    region = "us-west-2"
    subnet = "${aws_subnet.vault-a.id}"
}

module "vault" {
    source = "./vault"
    config = ""
    ami = "ami-3389b803"
    availability-zones = "us-west-2a,us-west-2b"
    key-name = "Hum_do"
    subnets = "${aws_subnet.vault-a.id}"
    vpc-id = "${aws_vpc.vault.id}"
}

resource "aws_vpc" "vault" {
    cidr_block = "172.20.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true

    tags {
    	Name = "vault-vpc"
    }
}

resource "aws_subnet" "vault-a" {
    vpc_id = "${aws_vpc.vault.id}"
    cidr_block = "172.20.240.0/24"
    availability_zone = "us-west-2a"

    tags {
        Name = "vault-subnet-a"
    }
}
