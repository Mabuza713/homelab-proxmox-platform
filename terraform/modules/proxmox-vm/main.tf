locals {
  cloud_init_template = coalesce(var.cloud_init_template, "${path.module}/cloud-init/${var.os}.yaml.tftpl")
}

resource "proxmox_virtual_environment_file" "cloud_init" {
  content_type = "snippets"
  datastore_id = var.snippets_datastore
  node_name    = var.node_name

  source_raw {
    file_name = "${var.name}.yaml"
    data = templatefile(local.cloud_init_template, {
      hostname           = var.name
      admin_user         = var.admin_user
      ssh_authorized_key = var.ssh_authorized_key
      apt_mirror         = var.apt_mirror
      packages           = jsonencode(concat(["qemu-guest-agent"], var.extra_packages))
    })
  }
}

resource "proxmox_virtual_environment_vm" "this" {
  name        = var.name
  node_name   = var.node_name
  vm_id       = var.vm_id
  description = var.description
  tags        = var.tags

  clone {
    vm_id = var.template_id
    full  = true
  }

  started = true
  on_boot = true

  cpu {
    cores   = var.cores
    sockets = var.sockets
    type    = var.cpu_type
  }

  memory {
    dedicated = var.memory
  }

  agent {
    enabled = true
  }

  disk {
    datastore_id = var.disk_datastore
    interface    = "scsi0"
    size         = var.disk_size
    discard      = "on"
    iothread     = true
    ssd          = true
  }

  initialization {
    datastore_id = var.disk_datastore

    ip_config {
      ipv4 {
        address = var.ipv4_address
        gateway = var.ipv4_gateway
      }
    }

    dns {
      servers = var.dns_servers
    }

    user_data_file_id = proxmox_virtual_environment_file.cloud_init.id
  }

  network_device {
    bridge   = var.bridge
    model    = "virtio"
    vlan_id  = var.vlan_id
    firewall = var.firewall
  }

  serial_device {}

  lifecycle {
    ignore_changes = [clone]
  }
}

resource "proxmox_virtual_environment_firewall_rules" "this" {
  count = var.firewall_security_group == null ? 0 : 1

  node_name = var.node_name
  vm_id     = proxmox_virtual_environment_vm.this.vm_id

  rule {
    security_group = var.firewall_security_group
  }
}

resource "proxmox_virtual_environment_firewall_options" "this" {
  count = var.firewall_security_group == null ? 0 : 1

  node_name     = var.node_name
  vm_id         = proxmox_virtual_environment_vm.this.vm_id
  enabled       = true
  input_policy  = "DROP"
  output_policy = "DROP"

  depends_on = [proxmox_virtual_environment_firewall_rules.this]
}
