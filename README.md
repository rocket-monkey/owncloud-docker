# ownCloud 
- ownCloud image with permissions optimized for OpenShift v3. 
- Base image jubicoy/nginx-docker extending Debian Jessie.
- Uses supervisor to run php5-fpm along with nginx in the container. This makes it easier to maintain ownCloud specific PHP extensions in contrast of running php5-fpm in it's own Pod.
- Configuration file is soft linked from data volume so only one volume is needed.
- Works with non-privileged containers and with arbitrary user id.

##### Usage:
- Build image or pull from Docker Hub.
- Mount volume to /var/www/owncloud/data
- Run web setup wizard.

##### TODO:
- Link apps directory to the volume so installed apps will persist.

