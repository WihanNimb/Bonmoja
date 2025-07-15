SHELL := /bin/bash

.PHONY: apply destroy

init:
	export TF_REGISTRY_CLIENT_TIMEOUT=20; \
	cd components/${component}; \
	cp ../../variables.tf .

validate:
	cd components/${component}; \
	cp backend/${env}-backend.tf .; \
	tflocal init -upgrade -reconfigure; \
	tflocal validate; \
	rm ${env}-backend.tf

fmt-check:
	cd components/${component}; \
	cp backend/${env}-backend.tf .; \
	tflocal init -upgrade -reconfigure; \
	tflocal fmt; \
	mv ${env}-backend.tf backend/

plan:
	cd components/${component}; \
	cp backend/${env}-backend.tf .; \
	tflocal init -upgrade -reconfigure; \
	tflocal plan -input=false -var-file="../../vars/${env}.tfvars" -compact-warnings; \
	TERRAFORM_PLAN_EXIT_CODE=$$?; \
	rm ${env}-backend.tf; \
	echo "Terraform Plan Exit Code: $$TERRAFORM_PLAN_EXIT_CODE"; \
	exit $$TERRAFORM_PLAN_EXIT_CODE

apply:
	cd components/${component}; \
	cp backend/${env}-backend.tf .; \
	terraform init -upgrade -reconfigure; \
	terraform apply -input=false -var-file="../../vars/${env}.tfvars" -auto-approve; \
	TERRAFORM_APPLY_EXIT_CODE=$$?; \
	rm ${env}-backend.tf; \
	echo "Terraform Apply Exit Code: $$TERRAFORM_APPLY_EXIT_CODE"; \
	exit $$TERRAFORM_APPLY_EXIT_CODE

destroy:
	cd components/${component}; \
	cp backend/${env}-backend.tf .; \
	tflocal init -upgrade -reconfigure; \
	tflocal destroy -input=false -var-file="../../vars/${env}.tfvars" -auto-approve; \
	TERRAFORM_DESTROY_EXIT_CODE=$$?; \
	rm ${env}-backend.tf; \
	echo "Terraform Destroy Exit Code: $$TERRAFORM_DESTROY_EXIT_CODE"; \
	exit $$TERRAFORM_DESTROY_EXIT_CODE


# Variables
env ?= dev
TFVARS_FILE := ../../vars/$(env).tfvars
BACKEND_FILE := backend/$(env)-backend.tf

# Macro to run terraform apply in a given module
define terraform_apply
	cd components/$(1); \
	cp $(BACKEND_FILE) .; \
	terraform init -upgrade -reconfigure; \
	terraform apply -input=false -var-file="$(TFVARS_FILE)" -auto-approve; \
	EXIT_CODE=$$?; \
	rm $(env)-backend.tf; \
	if [ $$EXIT_CODE -ne 0 ]; then \
		echo "❌ Terraform apply failed in $(1) with exit code $$EXIT_CODE"; \
		exit $$EXIT_CODE; \
	fi
endef

# Macro to run terraform destroy in a given module
define terraform_destroy
	cd components/$(1); \
	cp $(BACKEND_FILE) .; \
	terraform init -upgrade -reconfigure; \
	terraform destroy -input=false -var-file="$(TFVARS_FILE)" -auto-approve; \
	EXIT_CODE=$$?; \
	rm $(env)-backend.tf; \
	if [ $$EXIT_CODE -ne 0 ]; then \
		echo "❌ Terraform destroy failed in $(1) with exit code $$EXIT_CODE"; \
		exit $$EXIT_CODE; \
	fi
endef

# Macro to run terraform fmt in a given module
define terraform_fmt_check
	cd components/$(1); \
	cp $(BACKEND_FILE) .; \
	terraform init -upgrade -reconfigure; \
	terraform fmt; \
	mv $(env)-backend.tf $(BACKEND_FILE)
endef

# Macro to run terraform validate in a given module
define terraform_validate_check
	cd components/$(1); \
	cp $(BACKEND_FILE) .; \
	terraform init -upgrade -reconfigure; \
	terraform validate; \
	rm $(env)-backend.tf
endef

# Apply all modules in order - make apply_all env=dev
apply_all:
	$(call terraform_apply,vpc)
	$(call terraform_apply,ecs)
	$(call terraform_apply,rds)
	$(call terraform_apply,dynamoDB)
	$(call terraform_apply,sns_sqs)
	@echo "✅ All Terraform modules applied successfully."

# Destroy all modules in reverse order - make destroy_all env=dev
destroy_all:
	$(call terraform_apply,vpc)
	@echo "🧹 All Terraform modules destroyed successfully."

# Format all modules - make fmt_all env=dev
fmt_all:
	$(call terraform_apply,vpc)
	@echo "✨ All Terraform modules formatted successfully."

# Validate all components - make validate_all env=dev
validate_all:
	$(call terraform_apply,vpc)
	@echo "✅ All Terraform modules validated successfully."