FROM mysql:8.0

ENV MYSQL_DATABASE=tcc_db
ENV MYSQL_ROOT_PASSWORD=root

COPY tcc_db.sql /docker-entrypoint-initdb.d/

EXPOSE 3306
