#!/bin/bash

mkdir -p /var/timetrex/storage
mkdir /var/log/timetrex
chgrp -R www-data /var/timetrex/
chmod 775 -R /var/timetrex
chgrp www-data /var/log/timetrex/
chmod 775 /var/log/timetrex

exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf 1>/dev/null
