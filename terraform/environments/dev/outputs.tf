output "ssh_commands" {
  description = "how to get into the vms (only from the proxmox host)"
  value       = { for k, m in module.vm : k => "ssh admin@${m.ip}" }
}

output "ansible_inventory" {
  description = "goes into ansible/inventory/inventory.ini"
  value       = join("\n", [for k, m in module.vm : "[${k}]\n${m.ip} ansible_user=admin"])
}
