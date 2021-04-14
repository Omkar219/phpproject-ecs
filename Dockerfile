FROM php:7.4-apache
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        openssh-client \
        git

RUN mkdir -p -m 0400 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
RUN a2enmod rewrite

# Copy this repo into place.

# https://github.com/tandfgroup/routledgesw.git

#RUN git clone https://AshwiniN-Shekar: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@github.com/tandfgroup/routledgesw.git /var/www/html/

WORKDIR /var/www/html/
RUN touch .htaccess
RUN echo "DirectoryIndex default.php" >> .htaccess

#ADD apache-config.conf /etc/apache2/sites-enabled/000-default.conf
#ADD dir.conf /etc/apache2/mods-enabled/dir.conf

# Expose apache.
EXPOSE 80
