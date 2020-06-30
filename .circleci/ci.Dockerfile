# This Dockerfile represents the CI environment 

FROM node:12.18.1-buster-slim

WORKDIR /app

COPY install-elm.sh .

RUN npm -g config set user root && \
    npm install -g elm-format && \
    apt-get update && \
    apt-get install -y curl && \
    ./install-elm.sh

