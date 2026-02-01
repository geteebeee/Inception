SRC_DIR := srcs
ENV_FILE := .env
LOGIN ?= $(shell id -un)
WP_PATH := /home/$(LOGIN)/data/wordpress
DB_PATH := /home/$(LOGIN)/data/mariadb

NAME := inception

all: up

up:
	@mkdir -p "$(WP_PATH)" "$(DB_PATH)"
	@docker compose -f "$(SRC_DIR)/docker-compose.yml" up -d --build

build:
	@docker compose -f "$(SRC_DIR)/docker-compose.yml" build --no-cache

down:
	@docker compose -f "$(SRC_DIR)/docker-compose.yml" down

stop:
	@docker compose -f "$(SRC_DIR)/docker-compose.yml" stop

restart: down up

ps:
	@docker compose -f "$(SRC_DIR)/docker-compose.yml" ps

logs:
	@docker compose -f "$(SRC_DIR)/docker-compose.yml" logs -f --tail=200

clean: down
	@docker system prune -f

fclean: clean
	@doas rm -rf "$(WP_PATH)"/* "$(DB_PATH)"/*

re: fclean up

wipe: fclean
	@mkdir -p "$(WP_PATH)" "$(DB_PATH)"

volumes:
	@echo "WP: $(WP_PATH)"
	@echo "DB: $(DB_PATH)"

.PHONY: all up build down clean fclean re ps logs stop restart wipe volumes env
