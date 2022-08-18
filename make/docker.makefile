# Makefile for Docker
#
# https://makefiletutorial.com

# Project variables for Docker

DOCKER_SRC_HOST_DIR		:= $(shell pwd)/docker
DOCKER_AUTHORS			:= "stuart@stuartellis.name"
DOCKER_IMAGE			:= pgrunner

# Docker Commands

DKR_CMD = docker

# Docker Targets

.PHONY dkr:build
dkr\:build:
	@$(DKR_CMD) build ./python/makedb -f ./docker/$(DOCKER_IMAGE).dockerfile -t $(DOCKER_IMAGE):$(PROJECT_VERSION)-$(GIT_BRANCH) \
	--build-arg DOCKER_IMAGE_BASE=$(PY_DOCKER_IMAGE_BASE) \
	--label org.opencontainers.image.revision=$(GIT_COMMIT) \
	--label org.opencontainers.image.version=$(PROJECT_VERSION) \
	--label org.opencontainers.image.authors=$(DOCKER_AUTHORS)

.PHONY dkr:info
dkr\:info:
	@$(DKR_CMD) --version

.PHONY dkr:run
dkr\:run:
	@$(DKR_CMD) run --rm $(DOCKER_IMAGE):$(PROJECT_VERSION)
