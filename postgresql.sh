#!/bin/sh
set -e
set -x
chown -R postgres: /var/lib/postgresql/9.3/main
chown -R postgres: /var/log/postgresql
chmod 700 /var/lib/postgresql/9.3/main
if [ ! "$(ls -A /var/lib/postgresql/9.3/main)" ]; then
    su postgres -c "/usr/lib/postgresql/9.3/bin/initdb -E utf8 --locale=en_US.UTF-8 /var/lib/postgresql/9.3/main"
    su postgres -c "/usr/lib/postgresql/9.3/bin/postgres --single -c config-file=/etc/postgresql/9.3/main/postgresql.conf <<< 'alter user postgres with password '\''$PG_PASSWORD'\'';'"
fi
exec /sbin/setuser postgres /usr/lib/postgresql/9.3/bin/postgres -c config-file=/etc/postgresql/9.3/main/postgresql.conf -c listen-addresses=*
