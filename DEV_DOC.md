# Developer Documentation

## Purpose

This document explains how to set up, build, launch, and maintain the project from a developer point of view.

## Prerequisites

Before starting, make sure the environment provides:

- a Linux virtual machine
- Docker and Docker Compose
- permission to run Docker commands
- a valid host entry or DNS mapping for `<login>.42.fr`

## Project Layout

Important paths in this repository:

- `Makefile`: main command entrypoint
- `srcs/docker-compose.yml`: service orchestration
- `srcs/.env`: local environment configuration
- `srcs/.env.example`: environment template
- `srcs/requirements/nginx/`: NGINX Dockerfile, config, and entrypoint
- `srcs/requirements/wordpress/`: WordPress and PHP-FPM Dockerfile, config, and entrypoint
- `srcs/requirements/mariadb/`: MariaDB Dockerfile, config, and entrypoint
- `srcs/secrets/`: local secret files used by Docker secrets

## Setup From Scratch

### 1. Create The Environment File

Create `srcs/.env` from the example template:

```sh
cp srcs/.env.example srcs/.env
```

Then fill in the required values for your login, domain, database, and WordPress users.

### 2. Create The Secret Files

Create local secret files from the examples in `srcs/secrets/`:

```sh
cp srcs/secrets/db_pw.txt.example srcs/secrets/db_pw.txt
cp srcs/secrets/db_root_pw.txt.example srcs/secrets/db_root_pw.txt
cp srcs/secrets/wp_pw.txt.example srcs/secrets/wp_pw.txt
cp srcs/secrets/wp_admin_pw.txt.example srcs/secrets/wp_admin_pw.txt
```

Docker Compose maps those files to these secret names inside the containers:

- `db_user_password`
- `db_root_password`
- `wp_user_password`
- `wp_admin_password`

Then replace the placeholder values with real local credentials.

### 3. Prepare Host Storage

The current Makefile creates the following directories automatically when running `make`:

- `/home/gorg/data/wordpress`
- `/home/gorg/data/mariadb`

These directories store persistent website and database data.

### 4. Configure Local Domain Resolution

Make sure `<login>.42.fr` resolves to the host or VM IP that serves the stack.

## Build And Launch

The main commands are provided by the Makefile.

### Build And Start

```sh
make
```

### Rebuild Without Cache

```sh
make build
```

### Stop Containers

```sh
make stop
```

### Remove Running Stack

```sh
make down
```

### Restart Cleanly

```sh
make restart
```

## Runtime Management

Useful maintenance commands:

```sh
make ps
make logs
make clean
make fclean
make wipe
make volumes
```

### Notes About Cleanup

- `make clean` stops the stack and prunes unused Docker objects.
- `make fclean` also removes persisted contents under the configured host data directories.
- `make wipe` recreates the empty data directories after `fclean`.

## Service Behavior

### NGINX

- built from `srcs/requirements/nginx/`
- listens on port `443`
- terminates TLS
- proxies PHP requests to the WordPress container

### WordPress

- built from `srcs/requirements/wordpress/`
- runs `php-fpm`
- installs WordPress content into the shared web volume if needed
- configures WordPress and creates users through `wp-cli`

### MariaDB

- built from `srcs/requirements/mariadb/`
- initializes the database on first startup
- creates the configured database and SQL user
- stores data in the database volume

## Data Persistence

Persistent project data is currently intended to live under:

- `/home/gorg/data/wordpress`
- `/home/gorg/data/mariadb`

Those host paths are mounted into the containers so data survives rebuilds and container recreation.

## Credentials And Secrets

This project separates configuration from secrets:

- non-sensitive variables belong in `srcs/.env`
- passwords belong in Docker secret files under `srcs/secrets/`

The Docker secret names used by the services are:

- `db_user_password`
- `db_root_password`
- `wp_user_password`
- `wp_admin_password`

No password should be hardcoded in Dockerfiles or committed to the repository.

## Validation Tips

Before evaluation, check at least the following:

- the domain resolves correctly
- only NGINX is reachable from the host on port `443`
- WordPress opens over HTTPS
- the WordPress admin panel is accessible
- MariaDB data persists after restarting the stack
- the required secret files exist locally and are not committed
