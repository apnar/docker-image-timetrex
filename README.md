# Docker Container for TimeTrex Workforce Management 

This is a Docker image for running the TimeTrex open source
time tracking and payroll system.  It contains apache, php,
postgres database, and TimeTrex Community Edition.

More details at https://www.timetrex.com/community-edition

This container has no affiliation with TimeTrex, I'm just a happy
user for my one employee a year.

Run quickly:
```
docker run -d \
           --name timetrex \
           -p 8080:80 \
           apnar/timetrex
```


To use bind mounts and presistant data run more like this:
```
mkdir -p /docker/timetrex/storage
mkdir /docker/timetrex/logs
mkdir /docker/timetrex/database
touch /docker/timetrex/timetrex.ini.php
docker run -d \
           --name timetrex \
           -p 8080:80 \
           -v /docker/timetrex/storage:/storage \
           -v /docker/timetrex/logs:/logs \
           -v /docker/timetrex/database:/database \
           -v /docker/timetrex/timetrex.ini.php:/var/www/html/timetrex/timetrex.ini.php \
           apnar/timetrex
```

On first run it'll initialize the postgres database as well as the config file.

Then finish install at:  http://docker.host:8080/timetrex/interface/install/install.php


