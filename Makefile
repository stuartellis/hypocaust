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

PROJECT_MAINTAINERS	?= "stuart@stuartellis.name"
ENVIRONMENT			?= dev
TF_STACK			?= app_config
TARGET_CPU_ARCH		?= $(shell uname -m)

# Docker variables

# Docker Commands

DOCKER_BUILD_CMD 		:= docker build
DOCKER_SHELL_CMD		:= docker run -it --entrypoint sh
DOCKER_RUN_CMD 			:= docker run
DOCKER_COMPOSE_CMD		:= docker-compose -f $(shell pwd)/docker/compose.yml
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

include make/apps/dbmaker.makefile
include make/infrastructure/terraform.makefile
