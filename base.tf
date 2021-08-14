terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "2.7.4"
    }
  }
}

variable"PROXMOX_HOST" {
  default = "https://172.16.100.3:8006/api2/json"
}

provider "proxmox" {
  pm_api_url = var.PROXMOX_HOST
  pm_tls_insecure = true
  pm_parallel = 8
}

module "gitlab" {
  source = "./modules/gitlab"
}

module "proxy" {
  source = "./modules/proxy"
}
