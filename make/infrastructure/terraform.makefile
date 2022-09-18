# Makefile for Terraform
#
# https://makefiletutorial.com

# Project variables for Terraform

TF_VERSION			:= $(shell grep 'terraform' ./.tool-versions | cut -d' ' -f2)

TF_SRC_HOST_DIR		:= $(shell pwd)
TF_BACKENDS_DIR		:= terraform/backends
TF_BACKEND_FILE		:= $(SRC_BIND_DIR)/$(TF_BACKENDS_DIR)/$(ENVIRONMENT)/$(TF_STACK).backend
TF_STACKS_DIR		:= terraform/stacks
TF_STACK_DIR		:= $(SRC_BIND_DIR)/$(TF_STACKS_DIR)/$(TF_STACK)
TF_DATA_DIR         := $(SRC_BIND_DIR)/$(TF_STACKS_DIR)/$(TF_STACK)/.terraform
TF_PLAN_FILE		:= plan-$(ENVIRONMENT)-$(TF_STACK).tfstate
TF_VARS_DIR			:= terraform/variables
TF_VARS_FILES		:= -var-file=$(SRC_BIND_DIR)/$(TF_VARS_DIR)/project/project.tfvars -var-file=$(SRC_BIND_DIR)/$(TF_VARS_DIR)/environments/$(ENVIRONMENT).tfvars -var-file=$(SRC_BIND_DIR)/$(TF_VARS_DIR)/stacks/$(TF_STACK).tfvars

# Terraform Docker container

TF_CMD_DOCKER_IMAGE		:= hashicorp/terraform:$(TF_VERSION)
TF_CMD = docker run \
		--rm \
		--user $(shell id -u) \
		--mount type=bind,source=$(TF_SRC_HOST_DIR),destination=$(SRC_BIND_DIR) \
		-w $(SRC_BIND_DIR) \
		--env AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID) \
		--env AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY) \
		--env AWS_SESSION_TOKEN=$(AWS_SESSION_TOKEN) \
		--env AWS_PROFILE=$(AWS_PROFILE) \
		--env TF_DATA_DIR=$(TF_DATA_DIR) \
		$(MOUNT_AWS_CREDS_FILE) \
		$(TF_CMD_DOCKER_IMAGE)

# Terraform Targets

.PHONY terraform:apply
terraform\:apply:
	$(TF_CMD) -chdir=$(TF_STACK_DIR) apply \
	$(TF_PLAN_FILE)

.PHONY terraform:check
terraform\:check:
	$(TF_CMD) fmt -diff -check $(TF_STACK_DIR)

.PHONY terraform:destroy
terraform\:destroy:
	$(TF_CMD) -chdir=$(TF_STACK_DIR) plan -destroy $(TF_VARS_FILES) \
	-out=destroy-$(TF_PLAN_FILE) && \
    $(TF_CMD) -chdir=$(TF_STACK_DIR) apply destroy-$(TF_PLAN_FILE)

.PHONY terraform:fmt
terraform\:fmt:
	$(TF_CMD) fmt $(TF_STACK_DIR)

.PHONY terraform:info
terraform\:info:
	$(TF_CMD) -version

.PHONY terraform:init
terraform\:init:
	$(TF_CMD) -chdir=$(TF_STACK_DIR) init -backend-config=$(TF_BACKEND_FILE)

.PHONY terraform:plan
terraform\:plan:
	$(TF_CMD) -chdir=$(TF_STACK_DIR) plan $(TF_VARS_FILES) \
	-out=$(TF_PLAN_FILE)

.PHONY terraform:shell
terraform\:shell:
	docker run -it --entrypoint sh \
		--rm \
		--user $(shell id -u) \
		--mount type=bind,source=$(TF_SRC_HOST_DIR),destination=$(SRC_BIND_DIR) \
		-w $(SRC_BIND_DIR) \
		--env AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID) \
		--env AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY) \
		--env AWS_SESSION_TOKEN=$(AWS_SESSION_TOKEN) \
		--env AWS_PROFILE=$(AWS_PROFILE) \
		--env TF_DATA_DIR=$(SRC_BIND_DIR)/.terraform \
		$(MOUNT_AWS_CREDS_FILE) \
		$(TF_CMD_DOCKER_IMAGE)

.PHONY terraform:validate
terraform\:validate:
	$(TF_CMD) -chdir=$(TF_STACK_DIR) validate
