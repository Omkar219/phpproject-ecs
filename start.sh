#!/bin/bash

/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
curl http://172.31.45.40:51678/v1/metadata >> /var/www/html/index.php
