terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
    }
  }
}

resource "proxmox_vm_qemu" "k8s-0" {
  name = "k8s-0"
  desc = "Master server for k8s"
  target_node = "ps2"
  agent = 1
  clone = "debian-base"
  full_clone = true
  boot = "order=scsi0"
  os_type = "cloud-init"
  cpu = "host"
  ciuser = "root"
  memory = 8096
  ipconfig0 = "ip=172.16.100.99/24,gw=172.16.100.1"
  sshkeys = file("~/.ssh/id_ed25519.pub")
  provisioner "local-exec" {
    command = "ansible-playbook -i inventory.ini init.yaml"
    working_dir = "./modules/kubernetes"
  }
  provisioner "local-exec" {
    command = "k3sup install --ip 172.16.100.99 --ssh-key ~/.ssh/id_ed25519 --user root --k3s-extra-args '--no-deploy traefik' --local-path ~/.kube/config"
  }
}

