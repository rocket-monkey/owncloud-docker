# owncloud

- ownCloud image with permissions optimized for OpenShift v3. 
- Uses supervisor to run php5-fpm along with nginx in the container. This makes it easier to maintain ownCloud specific PHP extensions in contrast of running php5-fpm in it's own Pod.
- Configuration file is soft linked from data volume so only one volume is needed.

##### TODO:
- Link apps directory to the volume so installed apps will persist.

