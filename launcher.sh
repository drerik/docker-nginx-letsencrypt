#!/bin/sh

echo "Checking certificates."
if [[ ! -e /etc/letsencrypt/live/$HOSTNAME/privkey.pem ]]
then
  DOMAIN_CMD=$(echo $LETS_ENCRYPT_DOMAINS | sed 's/,/ -d /')
  certbot -n certonly --agree-tos --standalone -t -m "$LETS_ENCRYPT_EMAIL" -d $(hostname -f) -d $DOMAIN_CMD
  ls -s /etc/letsencrypt/live/$HOSTNAME /etc/letsencrypt/certs
else
  certbot renew
fi

echo "Launcing nginx."
nginx -g "daemon off;"
