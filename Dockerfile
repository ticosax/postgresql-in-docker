FROM ubuntu:12.04
MAINTAINER Nicolas Delaby <nicolas.delaby@ezeep.com>

RUN apt-get update
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" > /etc/apt/sources.list.d/pgdg.list
RUN apt-get -qq install curl
RUN curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update
RUN apt-get -qq install postgresql-9.3 postgresql-contrib-9.3
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN echo 'host all all 0.0.0.0/0 md5' >> /etc/postgresql/9.3/main/pg_hba.conf

VOLUME /var/lib/postgresql/9.3/main/
VOLUME /var/log/postgresql/

EXPOSE 5432

ADD start-postgres.sh start-postgres.sh
ENTRYPOINT ["./start-postgres.sh"]
