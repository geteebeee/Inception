FROM alpine:3.22

RUN apk add --no-cache mariadb mariadb-client

# runtime dirs + ownership
RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld /var/lib/mysql

COPY my.cnf /etc/my.cnf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

VOLUME ["/var/lib/mysql"]
EXPOSE 3306

ENTRYPOINT ["/entrypoint.sh"]
CMD ["mysqld", "--user=mysql", "--console"]

