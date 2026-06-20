variable "proxmox_endpoint" {
  description = "Proxmox API endpoint"
  type        = string
}

variable "proxmox_api_token" {
  description = "Proxmox API token"
  type        = string
  sensitive   = true
}

variable "proxmox_node" {
  description = "Proxmox node name"
  type        = string
}

variable "template_vmid" {
  description = "Debian cloud-init template VMID"
  type        = number
  default     = 1000
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

variable "ubuntu_template_vmid" {
  description = "Ubuntu cloud-init template VMID for Kubernetes nodes"
  type        = number
  default     = 1001
}

variable "k8s_nodes" {
  description = "Kubernetes VM nodes"
  type = map(object({
    vm_id     = number
    ip        = string
    cores     = number
    memory    = number
    disk_size = number
    role      = string
  }))


  default = {
    control1 = {
      vm_id     = 181
      ip        = "192.168.1.181"
      cores     = 2
      memory    = 4096
      disk_size = 40
      role      = "control-plane"
    }

    control2 = {
      vm_id     = 182
      ip        = "192.168.1.182"
      cores     = 2
      memory    = 4096
      disk_size = 40
      role      = "control-plane"
    }

    control3 = {
      vm_id     = 183
      ip        = "192.168.1.183"
      cores     = 2
      memory    = 4096
      disk_size = 40
      role      = "control-plane"
    }

    worker1 = {
      vm_id     = 184
      ip        = "192.168.1.184"
      cores     = 2
      memory    = 4096
      disk_size = 50
      role      = "worker"
    }

    worker2 = {
      vm_id     = 185
      ip        = "192.168.1.185"
      cores     = 2
      memory    = 4096
      disk_size = 50
      role      = "worker"
    }

    worker3 = {
      vm_id     = 186
      ip        = "192.168.1.186"
      cores     = 2
      memory    = 4096
      disk_size = 50
      role      = "worker"
    }
  }
}