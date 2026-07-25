#!/bin/bash

cd QuarnAPIServer

docker compose down  

# docker volume rm -f 

docker compose pull app

docker compose up --build -d
