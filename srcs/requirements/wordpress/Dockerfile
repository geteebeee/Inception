FROM alpine:3.22

# core php + fpm + mysqli (for MariaDB later)
RUN apk add --no-cache php82 php82-fpm php82-mysqli

# runtime dirs + non-login user
RUN adduser -D -H -s /sbin/nologin www && \
    mkdir -p /var/www/wordpress /run/php

# php-fpm pool config: listen on TCP 9000
COPY www.conf /etc/php82/php-fpm.d/www.conf

# simple entrypoint: just start php-fpm in foreground
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 9000
ENTRYPOINT ["/entrypoint.sh"]
CMD ["php-fpm82", "-F"]

