*This project has been created as part of the 42 curriculum by gorg.*

# Inception

## Description

Inception is a system administration project focused on building a small Docker-based infrastructure inside a virtual machine. The goal is to understand how multiple services can be isolated, configured, connected, and persisted through Docker Compose instead of being installed directly on the host.

This repository currently implements the mandatory three-service stack:

- NGINX as the only public HTTPS entrypoint on port `443`
- WordPress with `php-fpm`
- MariaDB for the WordPress database

Each service runs in its own dedicated container, is built from a custom Dockerfile, and is connected through a dedicated Docker network.

## Project Description

This project uses Docker to package each service with its own filesystem, startup logic, and configuration. Instead of configuring everything directly on the host machine, the infrastructure is described with versioned files so it can be rebuilt consistently.

### Included Sources

The main sources in this repository are:

- [Makefile](/home/gorg/Inception/Makefile) for orchestration commands
- [srcs/docker-compose.yml](/home/gorg/Inception/srcs/docker-compose.yml) for service, volume, network, and secret definitions
- [srcs/.env.example](/home/gorg/Inception/srcs/.env.example) as the environment template
- [srcs/requirements/nginx/Dockerfile](/home/gorg/Inception/srcs/requirements/nginx/Dockerfile) and related config/scripts for NGINX
- [srcs/requirements/wordpress/Dockerfile](/home/gorg/Inception/srcs/requirements/wordpress/Dockerfile) and related config/scripts for WordPress and PHP-FPM
- [srcs/requirements/mariadb/Dockerfile](/home/gorg/Inception/srcs/requirements/mariadb/Dockerfile) and related config/scripts for MariaDB
- [srcs/secrets](/home/gorg/Inception/srcs/secrets) for local secret-file templates

### Main Design Choices

- Each mandatory service runs in its own dedicated container.
- The images are built from custom Dockerfiles based on Alpine.
- NGINX is the only service exposed to the host and serves HTTPS traffic.
- WordPress and MariaDB communicate over an internal Docker network.
- Persistent data is stored outside the containers through mounted volumes.
- Non-sensitive settings are kept in `.env`, while passwords are intended to be provided through Docker secrets.

### Comparisons

#### Virtual Machines vs Docker

A virtual machine emulates a full operating system, while Docker containers share the host kernel and isolate processes in a lighter-weight way. For this project, Docker makes the infrastructure faster to rebuild, easier to version, and simpler to reproduce from configuration files.

#### Secrets vs Environment Variables

Environment variables are useful for non-sensitive values such as ports, domain names, usernames, and service settings. Docker secrets are better suited to confidential values such as passwords because they can be mounted as files and kept out of image layers and command histories. In this project, configuration belongs in `.env`, while secret values are intended to be passed through secret files mounted into the containers.

#### Docker Network vs Host Network

A Docker bridge network lets the containers talk to each other privately by service name while keeping non-public services off the host network. Host networking removes that isolation and is forbidden by the subject. Using a dedicated Docker network also keeps the architecture closer to the intended service boundaries.

#### Docker Volumes vs Bind Mounts

Docker-managed volumes are portable and abstract away the exact host path. Bind mounts map a precise host directory into the container, which makes the stored files easy to inspect directly from the host. This project persists data under `/home/<login>/data`, matching the subject requirement and making the website files and database data survive container recreation.

## Instructions

### Prerequisites

- A Linux virtual machine
- Docker and Docker Compose installed in the VM
- A host entry for `<login>.42.fr` pointing to the machine running the stack
- A real `srcs/.env` created from `srcs/.env.example`
- Local secret files created from the examples in `srcs/secrets/`

### Setup

1. Copy `srcs/.env.example` to `srcs/.env` and fill in the required values.
2. Create the local secret files expected by the project.
3. Ensure your domain, such as `gorg.42.fr`, resolves to your local machine.
4. Build and start the stack with:

```sh
make
```

### Secret Mapping

The Compose secret names used by the containers are:

- `db_user_password`
- `db_root_password`
- `wp_user_password`
- `wp_admin_password`

They are currently backed by these local files:

- `srcs/secrets/db_pw.txt`
- `srcs/secrets/db_root_pw.txt`
- `srcs/secrets/wp_pw.txt`
- `srcs/secrets/wp_admin_pw.txt`

### Useful Commands

```sh
make
make build
make down
make stop
make restart
make ps
make logs
make clean
make fclean
```

### Access

- Website: `https://<login>.42.fr`
- WordPress admin panel: `https://<login>.42.fr/wp-admin`

## Resources

### Classic References

- Docker documentation: https://docs.docker.com/
- Docker Compose documentation: https://docs.docker.com/compose/
- NGINX documentation: https://nginx.org/en/docs/
- MariaDB documentation: https://mariadb.com/kb/en/documentation/
- WordPress documentation: https://wordpress.org/documentation/
- PHP-FPM documentation: https://www.php.net/manual/en/install.fpm.php
- Alpine Linux documentation: https://wiki.alpinelinux.org/

### AI Usage

AI was used as a support tool for repetitive and documentation-oriented tasks, including:

- reviewing configuration consistency between Compose and entrypoint scripts
- identifying subject-compliance gaps after the subject update
- drafting and refining repository documentation

All AI-generated suggestions were reviewed against the project files and adjusted to match the actual repository structure and service behavior.

## More Information

- User-facing operating instructions are documented in [USER_DOC.md](/home/gorg/Inception/USER_DOC.md).
- Developer-focused setup and maintenance notes are documented in [DEV_DOC.md](/home/gorg/Inception/DEV_DOC.md).
