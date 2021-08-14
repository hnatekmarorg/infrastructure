terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
    }
  }
}

resource "proxmox_lxc" "proxy" {
  target_node  = "ps0"
  hostname     = "proxy"
  ostemplate   = "nas:vztmpl/ubuntu-21.04-standard_21.04-1_amd64.tar.gz"
  unprivileged = true

  onboot = true
  start = true

  // Terraform will crash without rootfs defined
  rootfs {
    storage = "zfs_storage"
    size    = "4G"
  }

  ssh_public_keys = file("~/.ssh/id_ed25519.pub")

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "172.16.100.61/24"
    gw = "172.16.100.1"
  }

  provisioner "local-exec" {
    command = "sleep 60 && ansible-playbook -i inventory.ini init.yaml"
    working_dir = "./modules/proxy"
  }
}

