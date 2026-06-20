provider "proxmox" {
  endpoint  = var.proxmox_endpoint
  api_token = var.proxmox_api_token
  insecure = true # в проде нужен норм tls
}

resource "proxmox_virtual_environment_vm" "master" {
  name        = "master"
  description = "DNS + NFS master for onikdam.local. Managed by Terraform."
  tags        = ["terraform", "debian", "dns", "nfs"]

  node_name = var.proxmox_node
  vm_id     = 180

  started         = true
  on_boot         = true
  stop_on_destroy = true

  clone {
    vm_id        = var.template_vmid
    full         = true
    datastore_id = "local-lvm"
  }

  cpu {
    cores = 1
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = 1024
  }

  agent {
    enabled = false
  }

  operating_system {
    type = "l26"
  }

  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }

  initialization {
    datastore_id = "local-lvm"

    dns {
      domain  = "onikdam.local"
      servers = ["192.168.1.180", "8.8.8.8"]
    }

    ip_config {
      ipv4 {
        address = "192.168.1.180/24"
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