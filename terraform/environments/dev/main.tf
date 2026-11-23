terraform {
  required_version = ">= 1.9.0"

  backend "local" {
    path = "../../state/dev/terraform.tfstate"
  }

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.112"
    }
  }
}

provider "proxmox" {
  ssh {
    agent       = false
    username    = "root"
    private_key = file(var.ssh_private_key_path)
  }
}

resource "proxmox_virtual_environment_cluster_firewall" "this" {
  enabled       = true
  input_policy  = "ACCEPT"
  output_policy = "ACCEPT"
}

resource "proxmox_sdn_zone_simple" "this" {
  id    = var.sdn_zone
  nodes = [var.node_name]
}

module "vlan" {
  source   = "../../modules/vlan"
  for_each = var.vlans

  zone     = proxmox_sdn_zone_simple.this.id
  vlan_id  = each.value.vlan_id
  cidr     = each.value.cidr
  isolated = each.value.isolated
  snat     = each.value.snat
  comment  = "${each.value.isolated ? "isolated" : "open"} vlan for ${each.key}"

  depends_on = [proxmox_virtual_environment_cluster_firewall.this]
}

module "vm" {
  source   = "../../modules/proxmox-vm"
  for_each = var.vms

  name        = each.key
  node_name   = var.node_name
  vm_id       = each.value.vm_id
  description = "${each.key} vm provisioned by terraform"
  tags        = ["terraform", each.key]

  os          = each.value.os
  template_id = var.template_id
  cores       = each.value.cores
  memory      = each.value.memory
  disk_size   = each.value.disk_size

  bridge       = module.vlan[each.value.vlan].bridge
  ipv4_address = "${cidrhost(module.vlan[each.value.vlan].cidr, each.value.host_index)}/${module.vlan[each.value.vlan].prefix}"
  ipv4_gateway = module.vlan[each.value.vlan].gateway

  firewall_security_group = module.vlan[each.value.vlan].security_group

  ssh_authorized_key = var.ssh_authorized_key
  extra_packages     = each.value.packages
}
