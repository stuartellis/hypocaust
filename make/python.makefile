# Makefile for Python
#
# https://makefiletutorial.com

# Project variables for Python

PY_VERSION				:= $(shell grep 'python' ./.tool-versions | cut -d' ' -f2)
PY_DOCKER_IMAGE_BASE 	:= python:$(PY_VERSION)-slim-$(DEBIAN_RELEASE)
PY_SRC_HOST_DIR			:= $(shell pwd)/python

# Python Docker container

PY_DKR_IMAGE		:= python:$(PY_VERSION)-slim-$(DEBIAN_RELEASE)
PY_DKR_CMD = docker run \
		--rm \
		--user $(shell id -u) \
		--mount type=bind,source=$(PY_SRC_HOST_DIR),destination=$(SRC_BIND_DIR) \
		-w $(SRC_BIND_DIR) \
		--env AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID) \
		--env AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY) \
		--env AWS_SESSION_TOKEN=$(AWS_SESSION_TOKEN) \
		--env AWS_PROFILE=$(AWS_PROFILE) \
		--env TF_DATA_DIR=$(SRC_BIND_DIR)/.terraform \
		$(MOUNT_AWS_CREDS_FILE) \
		$(PY_DKR_IMAGE)

# Python Targets

.PHONY py:info
py\:info:
	@$(PY_DKR_CMD) python --version

.PHONY py:shell
py\:shell:
	docker run -it --entrypoint sh \
		--rm \
		--user $(shell id -u) \
		--mount type=bind,source=$(PY_SRC_HOST_DIR),destination=$(SRC_BIND_DIR) \
		-w $(SRC_BIND_DIR) \
		--env AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID) \
		--env AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY) \
		--env AWS_SESSION_TOKEN=$(AWS_SESSION_TOKEN) \
		--env AWS_PROFILE=$(AWS_PROFILE) \
		$(MOUNT_AWS_CREDS_FILE) \
		$(PY_DKR_IMAGE)
