#!/bin/bash

echo "Checking certificates."
if [[ ! -e /etc/letsencrypt/live/$HOSTNAME/privkey.pem ]]
then
  DOMAIN_CMD=$(echo $LETS_ENCRYPT_DOMAINS | sed 's/,/ -d /')
  echo certbot -n certonly --agree-tos --standalone -t -m "$LETS_ENCRYPT_EMAIL" -d $(hostname -f) -d $DOMAIN_CMD
else
  certbot renew
fi

echo "Launcing nginx."
eval nginx -g 'daemon off';
