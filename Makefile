# Makefile
#
# https://makefiletutorial.com

# Variables

TF_DIR := terraform
TF_CMD := @terraform -chdir=$(TF_DIR)

# Targets

.PHONY: clean tf\:init

tf\:init:
	$(TF_CMD) init

clean:
	rm -fr tmp
