#!/bin/sh

sed -i -e "s/<UPLOAD_MAX_SIZE>/$UPLOAD_MAX_SIZE/g" /nginx/conf/nginx.conf /php/etc/php-fpm.conf \
       -e "s/<MEMORY_LIMIT>/$MEMORY_LIMIT/g" /php/etc/php-fpm.conf

# Create folder for php sessions if not exists
if [ ! -d /data/session ]; then
  mkdir -p /data/session;
fi

echo "Updating permissions..."
for dir in /var/log /php /nginx /tmp /etc/s6.d; do
  if $(find $dir ! -user $UID -o ! -group $GID|egrep '.' -q); then
    echo "Updating permissions in $dir..."
    chown -R $UID:$GID $dir
  else
    echo "Permissions in $dir are correct."
  fi
done
echo "Done updating permissions."

exec su-exec $UID:$GID /bin/s6-svscan /etc/s6.d
