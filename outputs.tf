output "servers_consul" {
  value = ["${aws_instance.server_consul.*.public_ip}"]
}

output "servers_vault" {
  value = ["${aws_instance.server_vault.*.public_ip}"]
}

output "base_user" {
  value = ["${module.shared.base_user}"]
}

output "base_image_name" {
  value = ["${module.shared.base_image_name}"]
}
