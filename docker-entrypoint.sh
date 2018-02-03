#!/bin/bash

mkdir -p /storage
mkdir /logs
chgrp -R www-data /storage
chmod 775 -R /storage
chgrp www-data /logs
chmod 775 /logs

if [ ! -f /database/PG_VERSION ]
then
  su - postgres -c "/usr/lib/postgresql/9.5/bin/initdb /database/" 
  su - postgres -c "psql -c \"CREATE USER timetrex WITH CREATEDB CREATEROLE LOGIN PASSWORD 'timetrex';\""
  su - postgres -c "psql -c \"CREATE DATABASE timetrex;\""
fi

if [[ ! -s /var/www/html/timetrex/timetrex.ini.php ]]
then
  cat /var/www/html/timetrex/timetrex.ini.php.dist > /var/www/html/timetrex/timetrex.ini.php
fi
chgrp www-data /var/www/html/timetrex/timetrex.ini.php
chmod 664 /var/www/html/timetrex/timetrex.ini.php

exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf 1>/dev/null
