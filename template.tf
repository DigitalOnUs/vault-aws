data "template_file" "init_vault" {
  template = "${file("${path.module}/scripts/vault/init-vault.sh.tpl")}"

  vars {
    private_ip_consul = "${aws_instance.server_consul.private_ip}"
    access_key        = "${var.access_key}"
    secret_key        = "${var.secret_key}"
    region            = "${var.region}"
  }
}
