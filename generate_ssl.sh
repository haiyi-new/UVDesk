#!/bin/bash

docker run -it \
    -p 80:80 \
    -v ./docker/nginx/ssl/etc/letsencrypt:/etc/letsencrypt \
    -v ./docker/nginx/ssl/lib/letsencrypt:/var/lib/letsencrypt \
    certbot/certbot certonly --standalone \
    --non-interactive --agree-tos --email saiful@teknoniaga.com \
    -d istana.labkami.com.my

