node_name            = "mabuza-proxmox"
ssh_private_key_path = "/root/.ssh/id_ed25519_pve_provisioner"
ssh_authorized_key   = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINvuOd3ylrolutYjMw6OiPP89cifpZ5bolQeMb/oBJ2e ansible@homelab-proxmox-platform"
template_id          = 9000

vlans = {
  minecraft = {
    vlan_id = 200
    cidr    = "10.10.101.0/24"
  }
}

vms = {
  minecraft = {
    vlan       = "minecraft"
    vm_id      = 120
    host_index = 50
    cores      = 6
    memory     = 16384
    disk_size  = 60
    packages   = ["openjdk-21-jre-headless"]
  }
}
