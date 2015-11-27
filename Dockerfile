FROM debian:jessie
MAINTAINER Matti Rita-Kasari "matti.rita-kasari@jubic.fi"
ENV OC_VERSION 8.2.0

RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62
RUN echo "deb http://nginx.org/packages/mainline/debian/ jessie nginx" >> /etc/apt/sources.list

ENV NGINX_VERSION 1.9.7-1~jessie
RUN apt-get update && \
    apt-get install --fix-missing -y ca-certificates nginx=${NGINX_VERSION} \
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

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p /var/www/
RUN curl -k https://download.owncloud.org/community/owncloud-$OC_VERSION.tar.bz2 | tar jx -C /var/www/
RUN chown -R 104:104 /var/www/owncloud

# Fix permissions issues
RUN touch /var/cache/nginx/client_temp
RUN chmod -R 777 /var/log/nginx/
RUN chmod -R 777 /var/cache/nginx/
RUN mkdir -p /workdir/sv-child-logs

ADD ./default.conf /etc/nginx/conf.d/default.conf
ADD ./nginx.conf /etc/nginx/nginx.conf
ADD ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD ./php-fpm.conf /etc/php5/fpm/php-fpm.conf
ADD ./www.conf /etc/php5/fpm/pool.d/www.conf
ADD ./config.php /var/www/owncloud/config/config.php

ADD ./entrypoint.sh /workdir/entrypoint.sh
ADD ./nginx.sh /workdir/nginx.sh
ADD ./php5-fpm.sh /workdir/php5-fpm.sh

RUN chmod -R 777 /workdir
WORKDIR /workdir

USER 104

VOLUME ["/var/www/owncloud/data", "/var/www/owncloud/config"]
EXPOSE 5000

ENTRYPOINT ["/workdir/entrypoint.sh"]
