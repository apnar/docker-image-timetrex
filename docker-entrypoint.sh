#!/bin/bash

mkdir -p /storage
mkdir /logs
chgrp -R www-data /storage
chmod 775 -R /storage
chgrp www-data /logs
chmod 775 /logs
chown -R postgres: /database

if [[ ! -s /var/www/html/timetrex/timetrex.ini.php ]]
then
  cat /timetrex.ini.php.dist > /var/www/html/timetrex/timetrex.ini.php
fi
chgrp www-data /var/www/html/timetrex/timetrex.ini.php
chmod 664 /var/www/html/timetrex/timetrex.ini.php

if [ ! -f /database/PG_VERSION ]
then
  su - postgres -c "/usr/lib/postgresql/9.5/bin/initdb /database/" 
  su - postgres -c "sleep 10; psql -c \"CREATE USER timetrex WITH CREATEDB CREATEROLE LOGIN PASSWORD 'timetrex';\"; psql -c \"CREATE DATABASE timetrex;\"" &
else
  CUR_VER=`ls /var/www/html/timetrex/classes/modules/install/sql/postgresql/ | tail -1 | sed 's/.sql//'`
  DB_VER=`su - postgres -c "psql timetrex -q -t -c \"select value from system_setting where name='schema_version_group_A'\""`
  if [[ "$CUR_VER" != "$DB_VER" ]]
  then
    sed -i 's/installer_enabled =.*/installer_enabled = TRUE/' /var/www/html/timetrex/timetrex.ini.php
    echo "New version detected!!!!"
    echo "Connect to http://[host]:[port]/timetrex/interface/install/install.php to finish upgrade."
  fi
fi

exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf 1>/dev/null
