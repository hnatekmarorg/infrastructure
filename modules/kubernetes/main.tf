terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
    }
  }
}

resource "proxmox_vm_qemu" "k8s-0" {
  name = "k8s-${each.value}"
  desc = "K8s node for ${each.value}"
  target_node = "${each.value}"
  agent = 1
  clone = "debian-base"
  full_clone = true
  boot = "order=scsi0"
  os_type = "cloud-init"
  cpu = "host"
  ciuser = "root"
  memory = 8096
  ipconfig0 = "ip=${each.key}/24,gw=172.16.100.1"
  sshkeys = file("~/.ssh/id_ed25519.pub")
  for_each = {
   "172.16.100.91": "ps1",
   "172.16.100.92": "ps2",
   "172.16.100.93": "ps0"
  }
}
