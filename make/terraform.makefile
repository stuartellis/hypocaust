# Makefile for Terraform
#
# https://makefiletutorial.com

# Project variables for Terraform

TF_VERSION			:= $(shell grep 'terraform' ./.tool-versions | cut -d' ' -f2)

TF_BACKENDS_DIR		:= ./backends
TF_BACKEND_FILE		:= $(TF_BACKENDS_DIR)/$(ENVIRONMENT)/$(TF_STACK).backend
TF_SRC_HOST_DIR		:= $(shell pwd)/terraform
TF_STACKS_DIR		:= ./stacks
TF_STACK_DIR		:= $(TF_STACKS_DIR)/$(TF_STACK)
TF_PLAN_FILE		:= plan-$(ENVIRONMENT)-$(TF_STACK).tfstate
TF_VARS_DIR			:= ./variables
TF_VARS_FILES		:= -var-file=$(TF_VARS_DIR)/project.tfvars -var-file=$(TF_VARS_DIR)/$(ENVIRONMENT).tfvars

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
		--env TF_DATA_DIR=$(SRC_BIND_DIR)/.terraform \
		$(MOUNT_AWS_CREDS_FILE) \
		$(TF_CMD_DOCKER_IMAGE)

# Terraform Targets

.PHONY tf:apply
tf\:apply:
	$(TF_CMD) -chdir=$(TF_STACK_DIR) apply \
	$(TF_PLAN_FILE)

.PHONY tf:check
tf\:check:
	$(TF_CMD) fmt -diff -check $(TF_STACK_DIR)

.PHONY tf:destroy
tf\:destroy:
	$(TF_CMD) -chdir=$(TF_STACK_DIR) destroy -auto-approve \
	$(TF_PLAN_FILE)

.PHONY tf:info
tf\:info:
	$(TF_CMD) -version

.PHONY tf:init
tf\:init:
	$(TF_CMD) -chdir=$(TF_STACK_DIR) init \
	-backend-config=$(TF_BACKEND_FILE)

.PHONY tf:plan
tf\:plan:
	$(TF_CMD) -chdir=$(TF_STACK_DIR) plan \
	-out=$(TF_PLAN_FILE)

.PHONY tf:shell
tf\:shell:
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