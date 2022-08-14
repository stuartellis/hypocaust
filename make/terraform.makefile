# Makefile for Terraform
#
# https://makefiletutorial.com

# Variables

TF_STACKS_DIR := ./terraform/stacks
TF_STACK_DIR := $(TF_STACKS_DIR)/$(TF_STACK)
TF_CMD := @terraform -chdir=$(TF_STACK_DIR)

## Terraform Targets

tf\:info:
	@terraform -version

.PHONY tf:info

tf\:init:
	echo STACK: $(TF_STACK)
	$(TF_CMD) init

.PHONY tf:init
