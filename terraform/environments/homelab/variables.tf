variable "proxmox_node_name" {
  type        = string
  description = "Node name"
}

variable "ubuntu_2404_url" {
  type        = string
  description = "Adres cloud image Ubuntu 24.04"
  default     = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
}

variable "ubuntu_2404_sha256" {
  type        = string
  description = "Checksum control for current version"
  default     = "d0fe84bb5f80853425fa6be28e2c106f30104c3cfe8611933f2e65c9b63f0e30"
}
