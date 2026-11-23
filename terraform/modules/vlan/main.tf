locals {
  prefix  = split("/", var.cidr)[1]
  gateway = cidrhost(var.cidr, 1)

  private_ranges = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16", "100.64.0.0/10"]
}

resource "proxmox_sdn_vnet" "this" {
  id    = "v${var.vlan_id}"
  zone  = var.zone
  alias = var.comment
}

resource "proxmox_sdn_subnet" "this" {
  vnet    = proxmox_sdn_vnet.this.id
  cidr    = var.cidr
  gateway = local.gateway
  snat    = var.snat
}

resource "proxmox_sdn_applier" "this" {
  depends_on = [proxmox_sdn_vnet.this, proxmox_sdn_subnet.this]

  lifecycle {
    replace_triggered_by = [proxmox_sdn_vnet.this, proxmox_sdn_subnet.this]
  }
}

resource "proxmox_virtual_environment_cluster_firewall_security_group" "this" {
  count = var.isolated ? 1 : 0

  name    = "iso-${proxmox_sdn_vnet.this.id}"
  comment = "Isolated VLAN ${var.vlan_id}: internet only"

  rule {
    type    = "in"
    action  = "ACCEPT"
    source  = local.gateway
    macro   = "SSH"
    comment = "SSH from the host (ansible)"
  }

  dynamic "rule" {
    for_each = local.private_ranges
    content {
      type    = "out"
      action  = "DROP"
      dest    = rule.value
      comment = "no private networks"
    }
  }

  rule {
    type    = "out"
    action  = "ACCEPT"
    comment = "internet"
  }
}
