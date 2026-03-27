SRC_DIR := srcs
ENV_FILE := .env
WP_PATH := /home/gorg/data/wordpress
DB_PATH := /home/gorg/data/mariadb

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

clean: down
	@docker system prune -f

fclean: clean
	@doas rm -rf "$(WP_PATH)"/* "$(DB_PATH)"/*

re: fclean up

.PHONY: all up build down clean fclean re ps logs stop restart wipe volumes env
