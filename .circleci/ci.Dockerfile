# This Dockerfile represents the CI environment 

FROM node:12.18.1-buster-slim

WORKDIR /app

COPY install-elm.sh .

RUN npm -g config set user root && \
    npm install -g elm-format elm-test && \
    apt-get update && \
    apt-get install -y curl && \
    ./install-elm.sh && \
    #
    # Installing Cypress-related deps
    apt-get install -y xvfb && \
    #
    # Installing puppeteer-related deps
    # https://github.com/puppeteer/puppeteer/blob/main/docs/troubleshooting.md#running-puppeteer-on-circleci
    apt-get install -y wget gnupg && \
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' && \
    apt-get update && \
    apt-get install -y google-chrome-unstable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

