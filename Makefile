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

# Project variables

ENVIRONMENT		?= dev
TF_STACK		?= hello_lambda

# Docker variables

SRC_BIND_DIR			:= /src
FILE_AWS_CREDS_DOCKER 	:= /tmp/aws-credentials
FILE_AWS_CREDS_HOST		:= $(HOME)/.aws/credentials

ifneq (,$(wildcard $(FILE_AWS_CREDS_HOST)))
	MOUNT_AWS_CREDS_FILE := -v $(FILE_AWS_CREDS_HOST):$(FILE_AWS_CREDS_DOCKER)
endif

# Default target

.DEFAULT_GOAL := test

## Project Targets

.PHONY: clean
clean:
	git clean -fdx

.PHONY: test
test:
	@echo "Not implemented" 

## Other Targets

include make/terraform.makefile
