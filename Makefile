ENV_FILE := secrets/homelab.env
# environment under terraform/environments, override with: make plan ENV=prod
ENV    ?= dev
TF_DIR := terraform/environments/$(ENV)

# which vm (key in var.vms) cloud-init / rebuild act on, override with: make rebuild VM=name
VM ?= minecraft

# loads the token from ENV_FILE and runs terraform inside TF_DIR
TF := set -a; . ./$(ENV_FILE); set +a; cd $(TF_DIR) && terraform

.PHONY: init plan apply apply-debug destroy output validate fmt cloud-init rebuild

init:
	$(TF) init

plan:
	$(TF) plan

apply:
	$(TF) apply

# provider debug log goes to a file, watch with: tail -f terraform/state/$(ENV)/apply.log
apply-debug:
	export TF_LOG_PROVIDER=DEBUG TF_LOG_PATH=$(CURDIR)/terraform/state/$(ENV)/apply.log; $(TF) apply

destroy:
	$(TF) destroy

output:
	$(TF) output

validate:
	cd $(TF_DIR) && terraform validate

fmt:
	terraform fmt -recursive terraform

cloud-init:
	$(TF) apply -replace='module.vm["$(VM)"].proxmox_virtual_environment_file.cloud_init'

rebuild:
	$(TF) apply -refresh=false -replace='module.vm["$(VM)"].proxmox_virtual_environment_file.cloud_init' -replace='module.vm["$(VM)"].proxmox_virtual_environment_vm.this'
