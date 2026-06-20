output "master_name" {
  value = proxmox_virtual_environment_vm.master.name
}

output "master_ipv4" {
  value = "192.168.1.180"
}

output "master_fqdn" {
  value = "master.onikdam.local"
}

output "k8s_nodes" {
  value = {
    for name, vm in proxmox_virtual_environment_vm.k8s_nodes : name => {
      vm_id = vm.vm_id
      ip    = var.k8s_nodes[name].ip
      role  = var.k8s_nodes[name].role
    }
  }
}