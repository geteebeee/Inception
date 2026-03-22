#!/bin/sh
set -eu

MYSQL_PASSWORD="$(cat /run/secrets/db_user_password)"
export MYSQL_PASSWORD

WP_ADMIN_PASSWORD="$(cat /run/secrets/wp_admin_password)"
WP_USER_PASSWORD="$(cat /run/secrets/wp_user_password)"
export WP_ADMIN_PASSWORD WP_USER_PASSWORD

WP_DIR=/var/www/wordpress
CFG="$WP_DIR/wp-config.php"

chown -R www:www /var/www

if [ ! -f "$WP_DIR/wp-settings.php" ]; then
  curl -fsSL https://wordpress.org/latest.tar.gz -o /tmp/wp.tgz
  tar -xzf /tmp/wp.tgz -C /tmp
  cp -R /tmp/wordpress/* "$WP_DIR/"
  rm -rf /tmp/wp.tgz /tmp/wordpress
  chown -R www:www "$WP_DIR"
fi

for i in $(seq 1 30); do
  mariadb-admin -h mariadb -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" ping >/dev/null 2>&1 && break
  sleep 1
done


if [ ! -f "$CFG" ]; then
  cat > "$CFG" <<'PHP'
<?php
define('DB_NAME',     getenv('MYSQL_DATABASE'));
define('DB_USER',     getenv('MYSQL_USER'));
define('DB_PASSWORD', getenv('MYSQL_PASSWORD'));
define('DB_HOST',     'mariadb:3306');
$table_prefix = 'wp_';
define('WP_DEBUG', false);
if ( !defined('ABSPATH') ) define('ABSPATH', __DIR__ . '/');
require_once ABSPATH . 'wp-settings.php';
PHP
  chown www:www "$CFG"
fi

if ! wp core is-installed --path="$WP_DIR" --allow-root >/dev/null 2>&1; then
  wp core install \
    --path="$WP_DIR" \
    --url="https://${DOMAIN_NAME}" \
    --title="${WP_TITLE}" \
    --admin_user="${WP_ADMIN_USER}" \
    --admin_password="${WP_ADMIN_PASSWORD}" \
    --admin_email="${WP_ADMIN_EMAIL}" \
    --skip-email \
    --allow-root

  wp user create "${LOGIN}" "${WP_USER_EMAIL}" \
    --user_pass="${WP_USER_PASSWORD}" \
    --role=subscriber \
    --path="$WP_DIR" \
    --allow-root
fi

exec "$@"

