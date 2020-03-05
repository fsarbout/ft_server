#!/bin/bash

chown -R mysql: /var/lib/mysql
service mysql  start
echo "CREATE DATABASE fz;" | mysql -u root
echo "CREATE DATABASE phpmyadmin;" | mysql -u root
echo "CREATE USER 'fsarbout'@localhost IDENTIFIED BY '1234';" | mysql -u root
echo "GRANT ALL PRIVILEGES ON *.* TO 'fsarbout'@'localhost';" | mysql -u root
mysql -u root fz < /root/fz.sql
mysql -u root phpmyadmin < /root/phpmyadmin.sql

chown -R www-data:www-data /var/www/*
chmod -R 755 /var/www/*
service php7.3-fpm start 
service nginx start

