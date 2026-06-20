output "master_name" {
  value = proxmox_virtual_environment_vm.master.name
}

output "master_ipv4" {
  value = "192.168.1.180"
}

output "master_fqdn" {
  value = "master.onikdam.local"
}