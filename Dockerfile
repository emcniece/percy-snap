FROM node:10-slim

ADD package.json package-lock.json /app/

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-unstable fonts-freefont-ttf \
      --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    && cd /app \
    && npm install

ADD index.js capture.js /app/

ENTRYPOINT ["node"]
CMD ["/app/index.js"]
