#!/bin/zsh

flutter build web

docker build -t us-west1-docker.pkg.dev/grzesbank-pamiw/gb24-repo/grzesbank-app:latest .
docker push us-west1-docker.pkg.dev/grzesbank-pamiw/gb24-repo/grzesbank-app:latest
gcloud run deploy grzesbank-app --image us-west1-docker.pkg.dev/grzesbank-pamiw/gb24-repo/grzesbank-app:latest --region us-west1 --allow-unauthenticated --port=80