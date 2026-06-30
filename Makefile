IMAGE := fpga-dev:latest
USERNAME := ubuntu
HOME_DIR := $$HOME
HOST_UID := $(shell id -u)
HOST_GID := $(shell id -g)

--user $(HOST_UID):$(HOST_GID)

build:
	docker build -t $(IMAGE) .

run:
	docker run --rm -it \
		-w /home/$(USERNAME) \
		--user $(HOST_UID):$(HOST_GID) \
		-v "$(HOME_DIR)/.config/nvim":/home/$(USERNAME)/.config/nvim \
		-v "$(HOME_DIR)/.local/share/nvim":/home/$(USERNAME)/.local/share/nvim \
		-v "$(HOME_DIR)/.local/state/nvim":/home/$(USERNAME)/.local/state/nvim \
		-v "/opt/uvm/1800.2-2020.3.1/src/":/opt/uvm/1800.2-2020.3.1/src:ro \
		$(IMAGE)

debug:
	@echo "Home directory = $(HOME_DIR)"
	@echo "[HOST_UID:HOST_GID]: $(HOST_UID):$(HOST_GID)"
	@echo "[USERNAME]: $(USERNAME)"
