#!/bin/sh
set -e

cd ~/OtlohaSah
/usr/local/bin/docker-compose run --rm certbot certbot renew
/usr/local/bin/docker-compose down
/usr/local/bin/docker-compose up --build -d

