resource "proxmox_virtual_environment_vm" "k8s_nodes" {
  for_each = var.k8s_nodes

  name        = each.key
  description = "Kubernetes ${each.value.role} node. Managed by Terraform."
  tags        = ["terraform", "ubuntu", "k8s", each.value.role]

  node_name = var.proxmox_node
  vm_id     = each.value.vm_id

  started         = true
  on_boot         = true
  stop_on_destroy = true

  clone {
    vm_id        = var.ubuntu_template_vmid
    full         = true
    datastore_id = "local-lvm"
  }

  cpu {
    cores = each.value.cores
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = each.value.memory
  }

  agent {
    enabled = true
  }

  operating_system {
    type = "l26"
  }

  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }

  disk {
    datastore_id = "local-lvm"
    interface    = "scsi0"
    size         = each.value.disk_size
  }

  initialization {
    datastore_id = "local-lvm"

    dns {
      domain  = "onikdam.local"
      servers = ["192.168.1.180", "1.1.1.1"]
    }

    ip_config {
      ipv4 {
        address = "${each.value.ip}/24"
        gateway = "192.168.1.1"
      }
    }

    user_account {
      username = "onikdam"
      keys     = [trimspace(file(var.ssh_public_key_path))]
    }
  }

  serial_device {}
}
