# Makefile for Docker
#
# https://makefiletutorial.com

# Project variables for Docker

DOCKER_SRC_HOST_DIR		:= $(shell pwd)/docker
DOCKER_AUTHORS			:= "Stuart Ellis <stuart@stuartellis.name>"
DOCKER_LICENSE			:= MIT
DOCKER_TITLE			:= "Toolbox Container"
DOCKER_DESCRIPTION		:= "Linux shell and tools"

# Docker Commands

DKR_CMD = docker

# Docker Targets

.PHONY dkr:build
dkr\:build:
	@$(DKR_CMD) build ./python/makedb -f ./docker/pgtoolbox.dockerfile -t pgtoolbox:$(PROJECT_VERSION) \
	--label org.opencontainers.image.version=\"$(PROJECT_VERSION)\" \
	--label org.opencontainers.image.authors=\"$(DOCKER_AUTHORS)\" \
	--label org.opencontainers.image.licenses=\"$(DOCKER_LICENSE)\" \
	--label org.opencontainers.image.title=\"$(DOCKER_TITLE)\" \ 
  	--label org.opencontainers.image.description=\"$(DOCKER_DESCRIPTION)\"

.PHONY dkr:info
dkr\:info:
	@$(DKR_CMD) --version
