IMAGE := fpga-dev:latest
USERNAME := ubuntu
HOME_DIR := $(HOME)
HOST_UID := $(shell id -u)
HOST_GID := $(shell id -g)

MOUNTPOINT := /proj/cad
REMOTE := ebw220000@giant.utdallas.edu:/proj/cad

.PHONY: help build mount unmount run debug


help: # Show help for each of the makefile recipes
	@grep -E '^[a-zA-Z0-9 -]+:.*#'  Makefile | sort | while read -r l; do printf "\033[1;32m$$(echo $$l | cut -f 1 -d':')\033[00m:$$(echo $$l | cut -f 2- -d'#')\n"; done

build: # Build the docker image
	docker build -t $(IMAGE) .

mount: # Mounts the cad tool directory specified by MOUNTPOINT on local machine
	@sudo mkdir -p $(MOUNTPOINT)
	@if mountpoint -q $(MOUNTPOINT); then \
		if timeout 5 ls $(MOUNTPOINT) >/dev/null 2>&1; then \
			echo "$(MOUNTPOINT) is already mounted and responsive."; \
		else \
			echo "$(MOUNTPOINT) appears stale. Unmounting..."; \
			sudo umount -f $(MOUNTPOINT) 2>/dev/null || true; \
		fi; \
	fi
	@if ! mountpoint -q $(MOUNTPOINT); then \
		echo "Mounting $(REMOTE) at $(MOUNTPOINT)..."; \
		sudo sshfs \
			$(REMOTE) \
			$(MOUNTPOINT) \
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
			-o compression=no; \
	fi

unmount: # unmounts existing filesystem located at MOUNTPOINT 
	sudo umount -f $(MOUNTPOINT) 2>/dev/null || true

run: mount # Runs the docker container 
	docker run --rm -it \
		-w /home/$(USERNAME) \
		--user $(HOST_UID):$(HOST_GID) \
		-v "$(HOME_DIR)/.config/nvim":/home/$(USERNAME)/.config/nvim \
		-v "$(HOME_DIR)/.local/share/nvim":/home/$(USERNAME)/.local/share/nvim \
		-v "$(HOME_DIR)/.local/state/nvim":/home/$(USERNAME)/.local/state/nvim \
		-v "/opt/uvm/1800.2-2020.3.1/src/":/opt/uvm/1800.2-2020.3.1/src:ro \
		-v "$(HOME_DIR)/projects/FPGA_Projects/UVMA_1_2_6/":/home/$(USERNAME)/UVM_1_2_6 \
		-v "$(HOME_DIR)/OpenLab/":/home/$(USERNAME)/OpenLab \
		-v "$(MOUNTPOINT)":$(MOUNTPOINT):ro \
		$(IMAGE)

debug: # Shows user ID and home directory path
	@echo "Home directory = $(HOME_DIR)"
	@echo "[HOST_UID:HOST_GID]: $(HOST_UID):$(HOST_GID)"
	@echo "[USERNAME]: $(USERNAME)"


