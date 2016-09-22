# Nginx-letsencrypt
This is a nginx docker image with letsencrypt implemented. Before starting the nginx deamon, this image will check if certificates for the hostname domain. If there is a certificate, it will do a `certbot renew` command to check if the certificates needs to renew it and renew it when needed. If the certificate is not the it will create it and other domains in the environment variable `LETS_ENCRYPT_DOMAINS` with the email in the `LETS_ENCRYPT_EMAIL` variable as the lets encrypt registration and recovery contact. The environment variable `LETS_ENCRYPT_DOMAINS` can be a comma separated list of domains that should be in the certificate.


## Setup

### Setting up with docker
You can specify the variables
```
docker run -d -v /etc/letsencrypt -v /var/lib/letsencrypt --name nginxstorage busybox

docker run -d --volumes-from nginxstorage --restart always \
  -e LETS_ENCRYPT_EMAIL="your@email.com" \
  -e LETS_ENCRYPT_DOMAINS="yourserver.com,site2.yourserver.com" \
  -p "80:80" -p "443:443" \
  --name nginx enoniccloud/nginx-letsencrypt
```

### Setting up with docker-compose
There are multiple ways of setting up a docker-compose, here is an example of how to set it up with custom configuration.
- Add the following code to your docker-compose setup:
```
nginx:
  build: nginx
  hostname: www.yourserver.com
  restart: always
  links:
    - linx
  volumes_from:
    - nginxstorage
  ports:
    - "80:80"
    - "443:443"
  environment:
    LETS_ENCRYPT_EMAIL: "your@email.com"
    LETS_ENCRYPT_DOMAINS: "yourserver.com,site2.yourserver.com"
  nginxstorage:
    image: busybox
    volumes:
      - "/etc/letsencrypt"
      - "/var/lib/letsencrypt"
```
- Create the folder `nginx` in your docker-compose setup, add a `Dockerfile` that Uses the `enoniccloud/nginx-letsencrypt` image and other modifications to your setup.
```
FROM enoniccloud/nginx-letsencrypt

COPY nginx-default.conf /etc/nginx/conf.d/default.conf

```
