variable "node_name" {
  description = "Proxmox node."
  type        = string
}

variable "sdn_zone" {
  description = "Id of the sdn simple zone (max 8 chars)."
  type        = string
  default     = "labnat"
}

variable "ssh_private_key_path" {
  description = "Key the provider uses to ssh to the node."
  type        = string
}

variable "ssh_authorized_key" {
  description = "Public key for the admin user on every vm."
  type        = string
}

variable "template_id" {
  description = "VM id of the cloud-init template to clone."
  type        = number
}

variable "vlans" {
  description = "Vlans, key = name used by vms. isolated = internet only, false = vms can talk to each other."
  type = map(object({
    vlan_id  = number
    cidr     = string
    isolated = optional(bool, true)
    snat     = optional(bool, true)
  }))
  default = {}
}

variable "vms" {
  description = "VMs to create, key = vm name and ansible group."
  type = map(object({
    vlan       = string
    vm_id      = number
    host_index = number
    os         = optional(string, "ubuntu")
    cores      = optional(number, 2)
    memory     = optional(number, 2048)
    disk_size  = optional(number, 20)
    packages   = optional(list(string), [])
  }))
  default = {}
}
