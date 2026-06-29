IMAGE := fpga-dev:latest
USERNAME := ubuntu
WORKDIR := /home/fpga-dev

build:
	docker build -t $(IMAGE) .

run:
	docker run --rm -it \
		-w /home/$(USERNAME) \
		--user 1000:1000 \
		-v "/home/evan/.config/nvim":/home/$(USERNAME)/.config/nvim:ro \
		-v "/home/evan/.local/share/nvim":/home/$(USERNAME)/.local/share/nvim \
		-v "/home/evan/.local/state/nvim":/home/$(USERNAME)/.local/state/nvim \
		$(IMAGE) bash
