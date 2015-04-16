FROM phusion/baseimage:0.9.16

MAINTAINER Nicolas Delaby <ticosax@free.fr>

RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list
RUN apt-get update && apt-get install wget ca-certificates
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
RUN apt-get update &&\
    apt-get -qq install postgresql-9.4 postgresql-contrib-9.4 postgresql-9.4-postgis-2.1 &&\
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD syslog-ng.postgresql.conf /etc/syslog-ng/conf.d/postgresql.conf

RUN echo 'host all all 0.0.0.0/0 md5' >> /etc/postgresql/9.4/main/pg_hba.conf
RUN echo "log_destination = 'stderr,syslog'" >> /etc/postgresql/9.4/main/postgresql.conf
RUN echo "syslog_facility = 'LOCAL0'" >> /etc/postgresql/9.4/main/postgresql.conf
RUN echo "syslog_ident = 'postgres'" >> /etc/postgresql/9.4/main/postgresql.conf

VOLUME /var/lib/postgresql/9.4/main/
VOLUME /var/log/

RUN echo -n en_US.UTF-8 > /etc/container_environment/LANG

EXPOSE 5432

RUN mkdir /var/run/postgresql/9.4-main.pg_stat_tmp/ && chown postgres: /var/run/postgresql/9.4-main.pg_stat_tmp/
RUN mkdir /etc/service/postgresql
ADD postgresql.sh /etc/service/postgresql/run
RUN chmod +x /etc/service/postgresql/run
CMD ["/sbin/my_init"]
