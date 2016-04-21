FROM jubicoy/nginx-php:latest
MAINTAINER Matti Rita-Kasari "matti.rita-kasari@jubic.fi"
ENV OC_VERSION 9.0.1

RUN apt-get update && apt-get install -y \
    curl wget bzip2 supervisor \
    php-apc \
    php5-apcu \
    php5-cli \
    php5-curl \
    php5-gd \
    php5-gmp \
    php5-imagick \
    php5-intl \
    php5-ldap \
    php5-mcrypt \
    php5-mysqlnd \
    php5-pgsql \
    php5-sqlite && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/
RUN curl -k https://download.owncloud.org/community/owncloud-$OC_VERSION.tar.bz2 | tar jx -C /var/www/

# Add configuration files
ADD config/default.conf /etc/nginx/conf.d/default.conf

# Add entrypoint script
ADD entrypoint.sh /workdir/entrypoint.sh

# We'll link configuration file from data folder
# so only one volume mount is needed
RUN ln -s /volume/config.php /var/www/owncloud/config/config.php

RUN mv /var/www/owncloud/apps /tmp/apps
RUN mv /var/www/owncloud/themes /tmp/themes

# Fix permissions issues
RUN chown -R 104:0 /workdir && chown -R 104:0 /var/www/owncloud
RUN chmod -R g+rw /workdir && chmod -R a+x /workdir && chmod -R g+rw /var/www/owncloud


RUN rm -rf /var/www/owncloud/data/
RUN ln -s /volume/data/ /var/www/owncloud/data
RUN ln -s /volume/apps/ /var/www/owncloud/apps
RUN ln -s /volume/themes /var/www/owncloud/themes

WORKDIR /workdir

USER 104

VOLUME ["/volume"]
EXPOSE 5000
