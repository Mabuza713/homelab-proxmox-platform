ENV_FILE := secrets/homelab.env
TF_DIR := terraform/environments/homelab
PK_DIR := packer/ubuntu-2404

.PHONY: plan apply destroy image fmt init

plan:
	set -a; . ./$(ENV_FILE); set +a; cd $(TF_DIR) && terraform plan

apply:
	set -a; . ./$(ENV_FILE); set +a; cd $(TF_DIR) && terraform apply

destroy:
	set -a; . ./$(ENV_FILE); set +a; cd $(TF_DIR) && terraform destroy

image:
	set -a; . ./$(ENV_FILE); set +a; cd $(PK_DIR) && packer build .

init:
	set -a; . ./$(ENV_FILE); set +a; cd $(TF_DIR) && terraform init

fmt:
	terraform fmt -recursive terraform/
	packer fmt $(PK_DIR)
