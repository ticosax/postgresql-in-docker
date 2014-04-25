FROM phusion/baseimage:latest

MAINTAINER Nicolas Delaby <nicolas.delaby@ezeep.com>

RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" > /etc/apt/sources.list.d/pgdg.list
RUN apt-get update
RUN apt-get -qq install curl
RUN curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update &&\
    apt-get -qq install postgresql-9.3 postgresql-contrib-9.3 &&\
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD syslog-ng.postgresql.conf /etc/syslog-ng/conf.d/postgresql.conf

RUN echo 'host all all 0.0.0.0/0 md5' >> /etc/postgresql/9.3/main/pg_hba.conf
RUN echo "log_destination = 'stderr,syslog'" >> /etc/postgresql/9.3/main/postgresql.conf
RUN echo "syslog_facility = 'LOCAL0'" >> /etc/postgresql/9.3/main/postgresql.conf
RUN echo "syslog_ident = 'postgres'" >> /etc/postgresql/9.3/main/postgresql.conf

VOLUME /var/lib/postgresql/9.3/main/
VOLUME /var/log/

RUN echo -n en_US.UTF-8 > /etc/container_environment/LANG

EXPOSE 5432

RUN mkdir /etc/service/postgresql
ADD postgresql.sh /etc/service/postgresql/run
RUN chmod +x /etc/service/postgresql/run
CMD ["/sbin/my_init"]
