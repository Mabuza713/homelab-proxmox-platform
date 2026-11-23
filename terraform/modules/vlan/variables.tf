variable "zone" {
  description = "Id of the sdn simple zone the vnet lives in."
  type        = string
}

variable "vlan_id" {
  description = "VLAN tag (2-4094)."
  type        = number
}

variable "cidr" {
  description = "VLAN subnet, e.g. 10.10.101.0/24. The host takes .1 as the gateway."
  type        = string
}

variable "comment" {
  description = "Alias of the vnet."
  type        = string
  default     = null
}

variable "snat" {
  description = "Masquerade the subnet behind the host so guests reach the internet."
  type        = bool
  default     = true
}

variable "isolated" {
  description = "true: create a firewall group that allows internet only. false: plain vlan, guests can reach each other."
  type        = bool
  default     = true
}
