# Makefile
#
# https://makefiletutorial.com

# Variables

TF_STACKS_DIR := ./terraform/stacks
TF_STACK_DIR := $(TF_STACKS_DIR)/$(TF_STACK)
TF_CMD := @terraform -chdir=$(TF_STACK_DIR)

# Targets

.DEFAULT_GOAL := tf:info
.PHONY: clean tf\:init

tf\:info:
	@terraform -version

tf\:init:
	echo STACK: $(TF_STACK)
	$(TF_CMD) init

clean:
	git clean -fdx
