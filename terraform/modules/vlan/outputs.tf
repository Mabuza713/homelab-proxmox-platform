output "vlan_id" {
  value = var.vlan_id
}

output "cidr" {
  value = var.cidr
}

output "prefix" {
  value = local.prefix
}

output "gateway" {
  value = local.gateway
}

output "bridge" {
  description = "vnet to attach the vm nic to, ready only after the sdn apply."
  value       = proxmox_sdn_vnet.this.id

  depends_on = [proxmox_sdn_applier.this]
}

output "security_group" {
  description = "group name for proxmox-vm firewall_security_group, null when not isolated."
  value       = one(proxmox_virtual_environment_cluster_firewall_security_group.this[*].name)
}
