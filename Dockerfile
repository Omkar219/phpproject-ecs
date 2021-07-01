FROM php:7.4-apache
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        openssh-client \
        git
   
RUN apt-get -y install cron

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

RUN mkdir -p -m 0400 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts
RUN rm -rf /var/www/html/* && mkdir -p /var/www/html 
RUN touch /var/www/html/index.php 
#RUN curl ${ECS_CONTAINER_METADATA_URI_V4}/task >> /var/www/html/index.php 
RUN echo "____________________" >> /var/www/html/index.php 
#RUN cat $${ECS_CONTAINER_METADATA_URI_V4}/task >> /var/www/html/index.php 

RUN (crontab -l ; echo "* * * * * curl http://172.31.45.40:51678/v1/metadata >> /var/www/html/index.php") | crontab
#copy src/ /var/www/html
RUN chmod -R a+r /var/www/html/
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
RUN a2enmod rewrite
CMD cron && tail -f /var/log/cron.log
# Copy this repo into place.

# https://github.com/tandfgroup/routledgesw.git



WORKDIR /var/www/html/
RUN touch .htaccess
RUN echo "DirectoryIndex index.php" >> .htaccess

#ADD apache-config.conf /etc/apache2/sites-enabled/000-default.conf
#ADD dir.conf /etc/apache2/mods-enabled/dir.conf

# Expose apache.
EXPOSE 80
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]

######
COPY start.sh /usr/local/bin/
RUN ln -s usr/local/bin/start.sh / # backwards compat
ENTRYPOINT ["start.sh"]
# Run the command on container startup
