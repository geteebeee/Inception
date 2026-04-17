FROM alpine:3.22

RUN apk add --no-cache nginx openssl gettext

RUN mkdir -p /run/nginx /run/nginx/ssl /var/www/wordpress /etc/nginx/templates

COPY default.conf /etc/nginx/templates/default.conf.template

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

EXPOSE 443

ENTRYPOINT ["/entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]
