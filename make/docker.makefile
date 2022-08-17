# Makefile for Docker
#
# https://makefiletutorial.com

# Project variables for Docker

DOCKER_SRC_HOST_DIR		:= $(shell pwd)/docker
DOCKER_AUTHORS			:= "stuart@stuartellis.name"

# Docker Commands

DKR_CMD = docker

# Docker Targets

.PHONY dkr:build
dkr\:build:
	@$(DKR_CMD) build ./python/makedb -f ./docker/pgtoolbox.dockerfile -t pgtoolbox:$(PROJECT_VERSION) \
	--label org.opencontainers.image.version=$(PROJECT_VERSION) \
	--label org.opencontainers.image.authors=$(DOCKER_AUTHORS)

.PHONY dkr:info
dkr\:info:
	@$(DKR_CMD) --version
