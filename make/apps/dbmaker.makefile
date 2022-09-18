APP_NAME					:= dbmaker				

APP_DOCKER_IMAGE_BASE 		:= python:3.9-slim-bullseye
APP_SOURCE_HOST_DIR			:= $(shell pwd)/python/dbmaker
APP_BUILD_DIR				:= $(shell pwd)/tmp/build/dbmaker
APP_VERSION					:= $(shell grep 'version' $(APP_SOURCE_HOST_DIR)/pyproject.toml | cut -d'=' -f2 | tr -d '"\ ') 
DOCKER_FILE					:= $(shell pwd)/python/dbmaker_default.dockerfile
DOCKER_IMAGE_TAG			:= $(APP_NAME):$(APP_VERSION)

APP_RUN_CMD := --rm \
		--user $(shell id -u) \
		--mount type=bind,source=$(TF_SRC_HOST_DIR),destination=$(SRC_BIND_DIR) \
		-w $(SRC_BIND_DIR) \
		--env AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID) \
		--env AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY) \
		--env AWS_SESSION_TOKEN=$(AWS_SESSION_TOKEN) \
		--env AWS_PROFILE=$(AWS_PROFILE) \
		--env TF_DATA_DIR=$(TF_DATA_DIR) \
		$(MOUNT_AWS_CREDS_FILE) \
		$(APP_DOCKER_IMAGE_BASE)

# App Targets

.PHONY dbmaker:build
dbmaker\:build:
	@$(DOCKER_BUILD_CMD) $(APP_SOURCE_HOST_DIR) --platform $(TARGET_CPU_ARCH) -f $(DOCKER_FILE) -t $(DOCKER_IMAGE_TAG) \
	--build-arg DOCKER_IMAGE_BASE=$(APP_DOCKER_IMAGE_BASE) \
	--label org.opencontainers.image.version=$(APP_VERSION) \
	--label org.opencontainers.image.authors=$(PROJECT_MAINTAINERS)

.PHONY dbmaker:info
dbmaker\:info:
	@echo Name: $(APP_NAME)
	@echo Version: $(APP_VERSION)
	@echo Maintainers: $(PROJECT_MAINTAINERS)

.PHONY dbmaker:compile
dbmaker\:compile:
	@mkdir -p $(APP_BUILD_DIR)
	@cp -r $(APP_SOURCE_HOST_DIR)/dbmaker/* $(APP_BUILD_DIR)
	@pip3 install -r $(APP_SOURCE_HOST_DIR)/requirements.txt --python 3.9 --implementation cp --platform manylinux2014_x86_64 --only-binary=:all: --target $(APP_BUILD_DIR)

.PHONY dbmaker:shell
dbmaker\:shell:
	$(DOCKER_SHELL_CMD) $(APP_RUN_CMD) \
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
