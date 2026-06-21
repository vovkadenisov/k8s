provider "proxmox" {
  endpoint  = var.proxmox_endpoint
  api_token = var.proxmox_api_token
  insecure  = true # в проде нужен норм tls
}

resource "proxmox_virtual_environment_vm" "vpn" {
  name        = "vpn"
  description = "vpn for onikdam.local. Managed by Terraform."
  tags        = ["terraform", "debian", "vpn"]

  node_name = var.proxmox_node
  vm_id     = 201

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
    enabled = true
  }

  operating_system {
    type = "l26"
  }

  # net0: обычная домашняя сеть / uplink / management
  # внутри VM будет 192.168.1.10/24, gateway 192.168.1.1
  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }

  # net1: VPN-сеть VLAN 100
  # внутри VM будет 192.168.100.1/24, gateway НЕ указываем
  network_device {
    bridge  = "vmbr0"
    model   = "virtio"
    vlan_id = 100
  }

  initialization {
    datastore_id = "local-lvm"

    dns {
      domain = "onikdam.local"

      # DNS самой VPN-VM на этапе установки.
      # Лучше использовать DNS из обычной сети/uplink, а не 192.168.100.254.
      servers = ["192.168.1.1", "1.1.1.1"]
    }

    # ip_config[0] -> первая network_device, то есть net0 / LAN
    ip_config {
      ipv4 {
        address = "192.168.1.10/24"
        gateway = "192.168.1.1"
      }
    }

    # ip_config[1] -> вторая network_device, то есть net1 / VLAN 100
    ip_config {
      ipv4 {
        address = "192.168.100.1/24"
      }
    }

    user_account {
      username = "onikdam"
      keys     = [trimspace(file(var.ssh_public_key_path))]
    }
  }

  serial_device {}
}