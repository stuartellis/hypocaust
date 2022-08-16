# Makefile for Docker
#
# https://makefiletutorial.com

# Project variables for Docker

DOCKER_SRC_HOST_DIR		:= $(shell pwd)/docker

# Docker Commands

DKR_CMD = docker

# Docker Targets

.PHONY dkr:info
dkr\:info:
	@$(DKR_CMD) --version
