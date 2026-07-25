#!/bin/bash

cd QuranAPIServer

docker compose down  

docker ps -a --filter volume=quranapiserver_app-dir -q | xargs -r docker rm -f


docker volume rm -f quranapiserver_app-dir

docker compose -f docker-compose.prod.yml pull app

docker compose -f docker-compose.prod.yml run --rm app bash -c "python manage.py compilemessages"

docker compose -f docker-compose.prod.yml run --rm app bash -c "python manage.py collectstatic --no-input --clear"

docker compose -f docker-compose.prod.yml up --build -d
