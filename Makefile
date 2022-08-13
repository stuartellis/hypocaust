# Makefile
#
# https://makefiletutorial.com

# Configuration for Make

SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.ONESHELL:
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

# Variables

TF_STACKS_DIR := ./terraform/stacks
TF_STACK_DIR := $(TF_STACKS_DIR)/$(TF_STACK)
TF_CMD := @terraform -chdir=$(TF_STACK_DIR)

# Targets

.DEFAULT_GOAL := tf:info

## Project Targets

clean:
	git clean -fdx
.PHONY: clean

test:
	@echo "Not implemented" 
.PHONY: test

## Terraform Targets

tf\:info:
	@terraform -version
.PHONY tf\:info

tf\:init:
	echo STACK: $(TF_STACK)
	$(TF_CMD) init
.PHONY tf\:init
