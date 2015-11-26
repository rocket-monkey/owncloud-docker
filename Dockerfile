FROM debian:jessie
MAINTAINER Matti Rita-Kasari "matti.rita-kasari@jubic.fi"
ENV OC_VERSION 8.2.0

RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62
RUN echo "deb http://nginx.org/packages/mainline/debian/ jessie nginx" >> /etc/apt/sources.list

ENV NGINX_VERSION 1.9.7-1~jessie
RUN apt-get update && \
    apt-get install -y ca-certificates nginx=${NGINX_VERSION} \
    curl wget bzip2 php5-fpm php5-mysql && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p /var/www/
RUN curl -k https://download.owncloud.org/community/owncloud-$OC_VERSION.tar.bz2 | tar jx -C /var/www/
RUN mkdir -p /workdir && chmod -R 777 /workdir

ADD ./entrypoint.sh /workdir/entrypoint.sh
RUN chmod +x /workdir/entrypoint.sh

ADD ./default.conf /etc/nginx/conf.d/default.conf

WORKDIR /workdir

VOLUME ["/var/www/owncloud/data", "/var/www/owncloud/config"]
EXPOSE 5000

CMD ["nginx", "-g", "daemon off;"]
#ENTRYPOINT ["/workdir/entrypoint.sh"]
