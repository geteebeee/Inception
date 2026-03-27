# User Documentation

## Overview

This stack provides three services:

- `nginx`: the public HTTPS entrypoint on port `443`
- `wordpress`: the application service running WordPress on PHP-FPM
- `mariadb`: the database service used by WordPress

Only NGINX is exposed to the host. WordPress and MariaDB stay internal to the Docker network.

## Start The Project

From the repository root, run:

```sh
make
```

This builds the images if needed, creates the required host data directories, and starts the stack in detached mode.

## Stop The Project

To stop the running containers without removing them:

```sh
make stop
```

To stop and remove the containers:

```sh
make down
```

To rebuild and restart everything:

```sh
make restart
```

## Access The Website

Open the configured domain in a browser over HTTPS:

```text
https://<login>.42.fr
```

For this repository, the default example domain is:

```text
https://gorg.42.fr
```

Your local machine or VM must resolve this hostname to the host running the stack.

## Access The Administration Panel

The WordPress administration panel is available at:

```text
https://<login>.42.fr/wp-admin
```

Use the administrator username defined in `srcs/.env` together with the administrator password stored in the relevant secret file.

## Locate And Manage Credentials

Credentials are split into two categories:

- configuration values in `srcs/.env`
- sensitive passwords in files under `srcs/secrets/`

Docker Compose exposes the following secret names to the containers:

- `db_user_password`
- `db_root_password`
- `wp_user_password`
- `wp_admin_password`

Those secret names are currently backed by these local files:

- `srcs/secrets/db_user_password.txt`
- `srcs/secrets/db_root_password.txt`
- `srcs/secrets/wp_user_password.txt`
- `srcs/secrets/wp_admin_password.txt`

The repository includes example files with the `.example` suffix that can be copied and filled locally.

## Persistent Data

Project data is intended to persist on the host under:

- `/home/<login>/data/wordpress`
- `/home/<login>/data/mariadb`

For this repository's default example values, those paths are:

- `/home/gorg/data/wordpress`
- `/home/gorg/data/mariadb`

These paths are used for the website files and database data so the content survives container recreation.
