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
