FROM alpine:3.22

RUN apk add --no-cache nginx openssl

RUN mkdir -p /run/nginx /run/nginx/ssl /var/www/wordpress

COPY default.conf /etc/nginx/http.d/default.conf

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

EXPOSE 443

ENTRYPOINT ["/entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]
