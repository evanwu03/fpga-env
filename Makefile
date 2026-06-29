IMAGE := fpga-dev:latest
USERNAME := ubuntu
HOME_DIR := $(HOME)


build:
	docker build -t $(IMAGE) .

run:
	docker run --rm -it \
		-w /home/$(USERNAME) \
		--user 1000:1000 \
		-v "/$(HOME)/.config/nvim":/home/$(USERNAME)/.config/nvim:ro \
		-v "/$(HOME)/.local/share/nvim":/home/$(USERNAME)/.local/share/nvim \
		-v "/$(HOME)/.local/state/nvim":/home/$(USERNAME)/.local/state/nvim \
		-v "/opt/uvm/1800.2-2020.3.1/src/":/home/$(USERNAME)/opt/uvm:ro \
		$(IMAGE) bash
