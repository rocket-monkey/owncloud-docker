#!/bin/bash
export USER_ID=$(id -u)
export GROUP_ID=$(id -g)
envsubst < /workdir/passwd.template > /tmp/passwd
export LD_PRELOAD=libnss_wrapper.so
export NSS_WRAPPER_PASSWD=/tmp/passwd
export NSS_WRAPPER_GROUP=/etc/group

if [ ! -d /volume/data ]; then 
	mkdir -p /volume/data
fi

if [ ! -f /volume/config.php ]; then
	touch /volume/config.php
fi

if [ ! -d /volume/apps ]; then
	cp -r /tmp/apps /volume/apps
fi

if [ ! -d /volume/themes ]; then
	cp -r /tmp/themes /volume/themes
fi

exec "/usr/bin/supervisord"


