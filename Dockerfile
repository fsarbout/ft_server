FROM debian:buster
RUN apt-get update
RUN apt-get install wget gnupg vim nginx -y
RUN apt-get install php php-mysql php-fpm lsb-release php-mbstring php-zip php-gd php-xml php-pear php-gettext php-cgi -y
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN	export DEBIAN_FRONTEND=noninteractive; \
	wget https://dev.mysql.com/get/mysql-apt-config_0.8.15-1_all.deb; \
	echo "mysql-apt-config mysql-apt-config/select-server select mysql-5.7" | /usr/bin/debconf-set-selections; \
	dpkg -i mysql-apt-config_0.8.15-1_all.deb; \	
	apt-get update ;\
	apt-get install mysql-server -y ; \
	chown -R mysql: /var/lib/mysql; \
	rm -rf mysql-apt-config_0.8.15-1_all.deb

RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.1/phpMyAdmin-5.0.1-all-languages.tar.gz; \
	tar xzf phpMyAdmin-5.0.1-all-languages.tar.gz; \
	mv phpMyAdmin-5.0.1-all-languages /var/www/html/phpmyadmin; \
	rm -rf  phpMyAdmin-5.0.1-all-languages.tar.gz; \
	mkdir /var/www/html/phpmyadmin/tmp; \
    chmod 777 /var/www/html/phpmyadmin/tmp
RUN wget https://wordpress.org/latest.tar.gz; \
	tar xzf latest.tar.gz; \
	rm -rf latest.tar.gz; \
	mv wordpress /var/www/html/
COPY ./srcs/fz.sql /root/
COPY ./srcs/wp-config.php /var/www/html/wordpress/
COPY ./srcs/default /etc/nginx/sites-available/default
COPY ./srcs/ssl/ssl.key /root/
COPY ./srcs/ssl/ssl.crt /root/
COPY ./srcs/phpmyadmin.sql /root/
COPY ./srcs/index.php /var/www/html/
COPY ./srcs/config.inc.php /var/www/html/phpmyadmin/
COPY ./srcs/script.sh /
EXPOSE 80 443
ENTRYPOINT ["./script.sh"]
