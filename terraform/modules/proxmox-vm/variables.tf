variable "name" {
  description = "VM name."
  type        = string
}

variable "node_name" {
  description = "Proxmox node the VM runs on."
  type        = string
}

variable "vm_id" {
  description = "Proxmox VM id."
  type        = number
}

variable "description" {
  description = "VM description."
  type        = string
  default     = "managed by terraform"
}

variable "tags" {
  description = "Proxmox tags."
  type        = list(string)
  default     = ["terraform"]
}

variable "template_id" {
  description = "VM id of the template to full-clone."
  type        = number
}

variable "cores" {
  type    = number
  default = 2
}

variable "sockets" {
  type    = number
  default = 1
}

variable "cpu_type" {
  type    = string
  default = "host"
}

variable "memory" {
  description = "RAM in MiB."
  type        = number
  default     = 2048
}

variable "disk_size" {
  description = "Disk size in GiB."
  type        = number
  default     = 20
}

variable "disk_datastore" {
  description = "Datastore for the disk and the cloud-init drive."
  type        = string
  default     = "local-lvm"
}

variable "snippets_datastore" {
  description = "Datastore with snippets enabled, holds the cloud-init file."
  type        = string
  default     = "local"
}

variable "bridge" {
  type    = string
  default = "vmbr0"
}

variable "vlan_id" {
  description = "VLAN tag on the nic, null for untagged."
  type        = number
  default     = null
}

variable "firewall" {
  description = "Enable the proxmox firewall on the nic."
  type        = bool
  default     = true
}

variable "ipv4_address" {
  description = "Static address in CIDR form, e.g. 10.10.101.50/24."
  type        = string
}

variable "ipv4_gateway" {
  type = string
}

variable "dns_servers" {
  type    = list(string)
  default = ["1.1.1.1", "9.9.9.9"]
}

variable "os" {
  description = "Picks cloud-init/<os>.yaml.tftpl, must match the cloned template."
  type        = string
  default     = "ubuntu"
}

variable "cloud_init_template" {
  description = "Own user-data template path, overrides os."
  type        = string
  default     = null
}

variable "admin_user" {
  type    = string
  default = "admin"
}

variable "ssh_authorized_key" {
  description = "Public key for the admin user (ansible)."
  type        = string
}

variable "apt_mirror" {
  type    = string
  default = "http://de.archive.ubuntu.com/ubuntu"
}

variable "extra_packages" {
  description = "Packages installed on top of qemu-guest-agent."
  type        = list(string)
  default     = []
}

variable "firewall_security_group" {
  description = "Cluster firewall group to attach. Setting it turns the vm firewall on with DROP in/out policies."
  type        = string
  default     = null
}
