resource "proxmox_download_file" "ubuntu_2404" {
  content_type = "import"
  datastore_id = "local"
  node_name    = var.proxmox_node_name

  url       = var.ubuntu_2404_url
  file_name = "noble-server-cloudimg-amd64.qcow2"

  checksum           = var.ubuntu_2404_sha256
  checksum_algorithm = "sha256"

  overwrite = false
}


resource "proxmox_virtual_environment_vm" "ubuntu_2404_template" {
  name      = "ubuntu-2404-cloudimg-base"
  node_name = var.proxmox_node_name
  vm_id     = 9000

  template = true
  started  = false

  description = "Base template for ubuntu 24.04."

  cpu {
    cores   = 2
    sockets = 1
    type    = "host"
  }

  memory {
    dedicated = 2048
  }

  agent {
    enabled = true
  }

  operating_system {
    type = "l26"
  }

  scsi_hardware = "virtio-scsi-single"
  tablet_device = false

  disk {
    datastore_id = "local-lvm"
    import_from  = proxmox_download_file.ubuntu_2404.id
    interface    = "scsi0"
    size         = 20
    discard      = "on"
    iothread     = true
    ssd          = true
  }

  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }

  serial_device {}

}
