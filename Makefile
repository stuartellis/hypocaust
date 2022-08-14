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

# Default target

.DEFAULT_GOAL := test

## Project Targets

clean:
	git clean -fdx
.PHONY: clean

test:
	@echo "Not implemented" 
.PHONY: test

## Other Targets

include make/terraform.makefile
