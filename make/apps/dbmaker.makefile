APP_NAME					:= dbmaker				

APP_DOCKER_IMAGE_BASE 		:= python:3.9-slim-bullseye
APP_SOURCE_HOST_DIR			:= $(shell pwd)/python/dbmaker
APP_VERSION					:= $(shell grep 'version' $(APP_SOURCE_HOST_DIR)/pyproject.toml | cut -d'=' -f2 | tr -d '"\ ') 
DOCKER_FILE					:= $(shell pwd)/python/dbmaker_default.dockerfile
DOCKER_IMAGE_TAG			:= $(APP_NAME):$(APP_VERSION)

# App Targets

.PHONY dbmaker:build
dbmaker\:build:
	@$(DOCKER_COMMAND) build $(APP_SOURCE_HOST_DIR) --platform $(TARGET_CPU_ARCH) -f $(DOCKER_FILE) -t $(DOCKER_IMAGE_TAG) \
	--build-arg DOCKER_IMAGE_BASE=$(APP_DOCKER_IMAGE_BASE) \
	--label org.opencontainers.image.version=$(APP_VERSION) \
	--label org.opencontainers.image.authors=$(PROJECT_MAINTAINERS)

.PHONY dbmaker:info
dbmaker\:info:
	@echo App name: $(APP_NAME)
	@echo App version: $(APP_VERSION)

.PHONY dbmaker:shell
dbmaker\:shell:
	docker run -it --entrypoint /bin/bash \
		--rm \
		--user $(shell id -u) \
		--mount type=bind,source=$(APP_SOURCE_HOST_DIR),destination=$(SRC_BIND_DIR) \
		-w $(SRC_BIND_DIR) \
		--env AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID) \
		--env AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY) \
		--env AWS_SESSION_TOKEN=$(AWS_SESSION_TOKEN) \
		--env AWS_PROFILE=$(AWS_PROFILE) \
		$(MOUNT_AWS_CREDS_FILE) \
		$(APP_DOCKER_IMAGE_BASE)
