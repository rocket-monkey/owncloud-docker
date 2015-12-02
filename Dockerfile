FROM jubicoy/nginx:latest
MAINTAINER Matti Rita-Kasari "matti.rita-kasari@jubic.fi"
ENV OC_VERSION 8.2.1

# Unstable repo for certain packages.
ADD ./apt/unstable.pref /etc/apt/preferences.d/unstable.pref
ADD ./apt/unstable.list /etc/apt/sources.list.d/unstable.list

RUN apt-get update && apt-get install -y \
    curl wget bzip2 supervisor \
    php5-fpm \
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

# nss-wrapper for OpenShift user management.
RUN apt-get update && apt-get install -y -t unstable libnss-wrapper gettext

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p /var/www/
RUN curl -k https://download.owncloud.org/community/owncloud-$OC_VERSION.tar.bz2 | tar jx -C /var/www/

# Create some needed directories
RUN mkdir -p /workdir/sv-child-logs
RUN mkdir -p /var/www/owncloud/data

# Add configuration files
ADD config/default.conf /etc/nginx/conf.d/default.conf
ADD config/nginx.conf /etc/nginx/nginx.conf
ADD config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD config/php-fpm.conf /etc/php5/fpm/php-fpm.conf
ADD config/www.conf /etc/php5/fpm/pool.d/www.conf
ADD passwd.template /workdir/passwd.template

# Add entrypoint script
ADD entrypoint.sh /workdir/entrypoint.sh

# We'll link configuration file from data folder
# so only one volume mount is needed
RUN touch /var/www/owncloud/data/config.php && ln -s /var/www/owncloud/data/config.php /var/www/owncloud/config/config.php

# Fix permissions issues
RUN chown -R 104:0 /workdir && chown -R 104:0 /var/www/owncloud
RUN chmod -R g+rw /workdir && chmod -R a+x /workdir && chmod -R g+rw /var/www/owncloud

WORKDIR /workdir

USER 104

VOLUME ["/var/www/owncloud/data"]
EXPOSE 5000

ENTRYPOINT ["/workdir/entrypoint.sh"]
