#!/bin/sh
set -eu

SSL_DIR=/etc/nginx/ssl
CRT="$SSL_DIR/server.crt"
KEY="$SSL_DIR/server.key"
CN="${DOMAIN_NAME:-localhost}"

echo "[entrypoint] ensure ssl dir"
mkdir -p "$SSL_DIR"

if [ ! -f "$CRT" ] || [ ! -f "$KEY" ]; then
  echo "[entrypoint] generate self-signed cert for CN=$CN"
  openssl req -x509 -nodes -newkey rsa:2048 -days 365 \
    -subj "/C=FI/ST=Helsinki/L=Helsinki/O=42/OU=student/CN=${CN}" \
    -keyout "$KEY" -out "$CRT"
  chmod 600 "$KEY"
fi

envsubst '${DOMAIN_NAME} ${WP_FPM_PORT}' \
  < /etc/nginx/templates/default.conf.template \
  > /etc/nginx/http.d/default.conf

# sanity check config before starting
echo "[entrypoint] nginx -t"
nginx -t

# make sure webroot exists (and give you a test page if empty)
mkdir -p /var/www/wordpress
if [ ! -f /var/www/wordpress/index.html ]; then
  echo "hello from nginx ✅" > /var/www/wordpress/index.html
fi

echo "[entrypoint] start: $*"
exec "$@"
