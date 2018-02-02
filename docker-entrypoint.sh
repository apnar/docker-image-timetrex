#!/bin/bash

mkdir -p /var/timetrex/storage
mkdir /var/log/timetrex
chgrp -R www-data /var/timetrex/
chmod 775 -R /var/timetrex
chgrp www-data /var/log/timetrex/
chmod 775 /var/log/timetrex

if [ ! -f /database/PG_VERSION ]
then
  su - postgres -c "/usr/lib/postgresql/9.5/bin/initdb /database/" 
  su - postgres -c "psql -c \"CREATE USER timetrex WITH CREATEDB CREATEROLE LOGIN PASSWORD 'timetrex';\""
  su - postgres -c "psql -c \"CREATE DATABASE timetrex;\""
fi

exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf 1>/dev/null
