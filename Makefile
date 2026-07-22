IMAGE := fpga-dev:latest
USERNAME := ubuntu
HOME_DIR := $(HOME)
HOST_UID := $(shell id -u)
HOST_GID := $(shell id -g)


MOUNTPOINT := /proj/cad
SSH_USER := ebw220000
SSH_SERVER := giant.utdallas.edu
SSH_HOST := $(SSH_USER)@$(SSH_SERVER)
REMOTE :=  $(SSH_HOST):/proj/cad

.PHONY: help build check-ssh do-mount mount unmount dev quartus debug

help: # Show help for each of the makefile recipes
	@grep -E '^[a-zA-Z0-9 -]+:.*#'  Makefile | sort | while read -r l; do printf "\033[1;32m$$(echo $$l | cut -f 1 -d':')\033[00m:$$(echo $$l | cut -f 2- -d'#')\n"; done

build: # Build the docker image
	docker build -t $(IMAGE) .
	

mount: check-ssh do-mount # Mount the CAD tool directory

check-ssh:
	@echo "[INFO]: Checking SSH connectivity to $(SSH_SERVER)..."
	@nc -z -w 3 $(SSH_SERVER) 22 || { \
		echo "[ERROR]: Cannot reach $(SSH_SERVER) on port 22. Please check connection to network or VPN"; \
		exit 1; \
	}
	@echo "[SUCCESS]: $(SSH_HOST):22 is reachable."


do-mount:
	@sudo mkdir -p $(MOUNTPOINT); \
	if mountpoint -q $(MOUNTPOINT) && \
	   timeout 5 ls $(MOUNTPOINT) >/dev/null 2>&1; then \
		 echo "[INFO]: $(MOUNTPOINT) is already mounted and responsive."; \
		exit 0; \
	fi; \
	if mountpoint -q $(MOUNTPOINT); then \
	echo "[INFO]: $(MOUNTPOINT) appears stale. Unmounting..."; \
		sudo umount -f $(MOUNTPOINT) 2>/dev/null || true; \
	fi; \
	echo "[INFO]: Mounting $(REMOTE) at $(MOUNTPOINT)..."; \
	sudo sshfs -o ssh_command="ssh -vvv" $(REMOTE) $(MOUNTPOINT) \
		-o ro \
		-o allow_other \
		-o default_permissions \
		-o reconnect \
		-o ServerAliveInterval=15 \
		-o ServerAliveCountMax=3 \
		-o cache=yes \
		-o kernel_cache \
		-o attr_timeout=3600 \
		-o entry_timeout=3600 \
		-o negative_timeout=60 \
		-o compression=yes



unmount: # Unmounts existing filesystem located at MOUNTPOINT 
	sudo umount -f $(MOUNTPOINT) 2>/dev/null || true


dev: # Enters an interactive shell in fpga-dev container
	docker compose run --rm fpga-dev bash

quartus: # Enters an interactive shell in quartus container 
	docker compose run --rm quartus bash


# DEPRECATED: user docker compose up and docker compose attach instead
#run:  # Runs the docker container 
#	docker run --rm -it \
#		-w /home/$(USERNAME) \
#		--user $(HOST_UID):$(HOST_GID) \
#		-v "$(HOME_DIR)/.config/nvim":/home/$(USERNAME)/.config/nvim \
#		-v "$(HOME_DIR)/.local/share/nvim":/home/$(USERNAME)/.local/share/nvim \
#		-v "$(HOME_DIR)/.local/state/nvim":/home/$(USERNAME)/.local/state/nvim \
#		-v "/opt/uvm/1800.2-2020.3.1/src/":/opt/uvm/1800.2-2020.3.1/src:ro \
#		-v "$(HOME_DIR)/projects/FPGA_Projects/UVMA_1_2_6/":/home/$(USERNAME)/UVM_1_2_6 \
#		-v "$(HOME_DIR)/OpenLab/":/home/$(USERNAME)/OpenLab \
#		-v "$(MOUNTPOINT)":$(MOUNTPOINT):ro \
#		$(IMAGE)

debug: # Shows user ID and home directory path
	@echo "Home directory = $(HOME_DIR)"
	@echo "[HOST_UID:HOST_GID]: $(HOST_UID):$(HOST_GID)"
	@echo "[USERNAME]: $(USERNAME)"


