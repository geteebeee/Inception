SRC_DIR := srcs
ENV_FILE := $(SRC_DIR)/.env
WP_PATH := $(shell sed -n 's/^WP_PATH=//p' "$(ENV_FILE)")
DB_PATH := $(shell sed -n 's/^DB_PATH=//p' "$(ENV_FILE)")

NAME := inception

all: up

up:
	@mkdir -p "$(WP_PATH)" "$(DB_PATH)"
	@docker compose --env-file "$(ENV_FILE)" -f "$(SRC_DIR)/docker-compose.yml" up -d --build

build:
	@docker compose --env-file "$(ENV_FILE)" -f "$(SRC_DIR)/docker-compose.yml" build --no-cache

down:
	@docker compose --env-file "$(ENV_FILE)" -f "$(SRC_DIR)/docker-compose.yml" down

stop:
	@docker compose --env-file "$(ENV_FILE)" -f "$(SRC_DIR)/docker-compose.yml" stop

restart: down up

clean: down
	@docker system prune -f

fclean: clean
	@doas rm -rf "/home/gorg/data"

re: fclean up

.PHONY: all up build down clean fclean re stop restart 
