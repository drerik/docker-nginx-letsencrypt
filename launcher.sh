#!/bin/sh

echo "Checking certificates ( if /etc/letsencrypt/live/$(hostname -f)/privkey.pem exist )."
if [[ ! -e /etc/letsencrypt/live/$(hostname -f)/privkey.pem ]]
then
  if [[ ! "x$LETS_ENCRYPT_DOMAINS" == "x" ]]; then
    DOMAIN_CMD="-d $(echo $LETS_ENCRYPT_DOMAINS | sed 's/,/ -d /')"
  fi

  certbot -n certonly --agree-tos --standalone -t -m "$LETS_ENCRYPT_EMAIL" -d $(hostname -f) $DOMAIN_CMD
  ls -s /etc/letsencrypt/live/$(hostname -f) /etc/letsencrypt/certs
else
  certbot renew
fi

echo "Launcing nginx."
nginx -g "daemon off;"
