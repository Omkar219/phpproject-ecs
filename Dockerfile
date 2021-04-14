FROM php:7.4-apache
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        openssh-client \
        git
   

RUN mkdir -p -m 0400 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts
RUN rm -rf /var/www/html/* && mkdir -p /var/www/html 
ADD src /var/www/html

ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
RUN a2enmod rewrite

# Copy this repo into place.

# https://github.com/tandfgroup/routledgesw.git


WORKDIR /var/www/html/
RUN touch .htaccess
RUN echo "DirectoryIndex index.php" >> .htaccess

#ADD apache-config.conf /etc/apache2/sites-enabled/000-default.conf
#ADD dir.conf /etc/apache2/mods-enabled/dir.conf

# Expose apache.
EXPOSE 80
CMD ["/usr/sbin/apache2", "-D",  "FOREGROUND"]