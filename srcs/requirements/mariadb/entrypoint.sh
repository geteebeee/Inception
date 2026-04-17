#!/bin/sh
set -eu

MYSQL_ROOT_PASSWORD="$(cat /run/secrets/db_root_password)"
MYSQL_PASSWORD="$(cat /run/secrets/db_user_password)"
export MYSQL_ROOT_PASSWORD MYSQL_PASSWORD

DATADIR=/var/lib/mysql

if [ ! -d "$DATADIR/mysql" ]; then
  echo "[mariadb] initializing data directory"
  mariadb-install-db \
    --user=mysql \
    --datadir="$DATADIR" \
    --auth-root-authentication-method=normal >/dev/null

  cat <<EOF >/tmp/init.sql
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

  echo "[mariadb] scheduling first-start database configuration"
  set -- "$@" --init-file=/tmp/init.sql
fi

echo "[mariadb] starting mysqld"
exec "$@"
