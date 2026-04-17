FROM alpine:3.22

RUN apk add --no-cache php82 php82-fpm php82-mysqli php82-phar curl tar mariadb-client gnupg php82-cli php82-mbstring php82-mbstring

WORKDIR /tmp

RUN curl -fsSLO https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
 && curl -fsSLO https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar.asc \
 && curl -fsSL https://raw.githubusercontent.com/wp-cli/builds/gh-pages/wp-cli.pgp | gpg --import \
 && gpg --verify wp-cli.phar.asc wp-cli.phar \
 && mv wp-cli.phar /usr/local/bin/wp-cli.phar \
 && printf '#!/bin/sh\nexec /usr/bin/php82 /usr/local/bin/wp-cli.phar "$@"\n' > /usr/local/bin/wp \
 && chmod +x /usr/local/bin/wp \
 && rm -rf /tmp/*


RUN adduser -D -H -s /sbin/nologin www && \
    mkdir -p /var/www/wordpress /run/php

COPY www.conf /etc/php82/php-fpm.d/www.conf.template

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 9000
ENTRYPOINT ["/entrypoint.sh"]
CMD ["php-fpm82", "-F"]
