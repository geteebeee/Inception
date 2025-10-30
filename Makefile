# ===== config =====
SRC_DIR := srcs
ENV_FILE := .env

# Pull LOGIN from .env if it exists; otherwise fall back to current user
ifneq ("$(wildcard $(ENV_FILE))","")
include $(ENV_FILE)
export $(shell sed -n 's/^\([A-Za-z_][A-Za-z0-9_]*\)=.*/\1/p' $(ENV_FILE))
endif
LOGIN ?= $(shell id -un)

WP_PATH := /home/$(LOGIN)/data/wordpress
DB_PATH := /home/$(LOGIN)/data/mariadb

# ===== phony targets =====
.PHONY: all up build down clean fclean re ps logs stop restart wipe volumes env

# ===== main =====
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

# remove stopped containers, unused nets/images (safe-ish)
clean: down
	@docker system prune -f

# nuke persisted data (careful!)
fclean: clean
	@rm -rf "$(WP_PATH)"/* "$(DB_PATH)"/*

re: fclean up

# handy helpers
wipe: fclean ## wipe + recreate dirs (no up)
	@mkdir -p "$(WP_PATH)" "$(DB_PATH)"

volumes:
	@echo "WP: $(WP_PATH)"
	@echo "DB: $(DB_PA_

