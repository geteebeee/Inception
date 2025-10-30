#!/bin/sh
set -eu

DATADIR=/var/lib/mysql

if [ ! -d "$DATADIR/mysql" ]; then
  echo "[mariadb] initializing data directory"
  mariadb-install-db --user=mysql --datadir="$DATADIR" >/dev/null

  # start temporary server without networking
  mysqld --user=mysql --skip-networking &
  pid="$!"

  # wait for server to accept local connections
  for i in $(seq 1 30); do
    mariadb-admin ping >/dev/null 2>&1 && break
    sleep 1
  done

  echo "[mariadb] creating users and database"
  mariadb -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}'; FLUSH PRIVILEGES;"
  mariadb -uroot -p"${MYSQL_ROOT_PASSWORD}" -e "CREATE DATABASE ${MYSQL_DATABASE};"
  mariadb -uroot -p"${MYSQL_ROOT_PASSWORD}" -e "CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
  mariadb -uroot -p"${MYSQL_ROOT_PASSWORD}" -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%'; FLUSH PRIVILEGES;"

  mariadb-admin -uroot -p"${MYSQL_ROOT_PASSWORD}" shutdown
  wait "$pid"
fi

echo "[mariadb] starting mysqld"
exec "$@"

