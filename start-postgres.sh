#!/bin/bash
set -e
set -x
chown -R postgres: /var/lib/postgresql/9.3/main
chown -R postgres: /var/log/postgresql
if [ ! "$(ls -A /var/lib/postgresql/9.3/main)" ]; then
    su postgres -c "/usr/lib/postgresql/9.3/bin/initdb /var/lib/postgresql/9.3/main"
    su postgres -c "/usr/lib/postgresql/9.3/bin/postgres --single -c config-file=/etc/postgresql/9.3/main/postgresql.conf" <<< "alter user postgres with password '$PASSWORD';"
fi
su postgres -c "/usr/lib/postgresql/9.3/bin/postgres -c config-file=/etc/postgresql/9.3/main/postgresql.conf -c listen-addresses=*" & wait $!
