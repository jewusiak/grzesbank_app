#!/bin/sh

openssl req -x509 -newkey rsa:4096 -nodes -keyout docker_resources/private.key -out docker_resources/cert.crt -sha256 -days 30 -subj "/C=PL/ST=Mazowieckie/L=Warsaw/O=Grzesbank/OU=Grzesbank24/CN=localhost"

docker compose up -d