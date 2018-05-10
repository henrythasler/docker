#!/bin/bash

if [ -z "${USER}" ]; then
  echo "We need USER to be set!"; exit 100
fi

# if both not set we do not need to do anything
if [ -z "${HOST_USER_ID}" -a -z "${HOST_USER_GID}" ]; then
    echo "Nothing to do here." ; exit 0
fi

# reset user_?id to either new id or if empty old (still one of above
# might not be set)
USER_ID=${HOST_USER_ID:=$USER_ID}
USER_GID=${HOST_USER_GID:=$USER_GID}

sed -i -e "s/^${USER}:\([^:]*\):[0-9]*:[0-9]*/${USER}:\1:${USER_ID}:${USER_GID}/"  /etc/passwd
sed -i -e "s/^${USER}:\([^:]*\):[0-9]*/${USER}:\1:${USER_GID}/"  /etc/group

exec su -c "${1}" - "${USER}"