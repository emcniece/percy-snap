FROM node:10-slim

ENV CRON_TIME="0 0 * * *"

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y vim cron google-chrome-unstable fonts-freefont-ttf \
      --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

ADD package.json package-lock.json index.js /app/

RUN groupadd -r pptruser && useradd -r -g pptruser -G audio,video pptruser \
    && mkdir -p /home/pptruser/Downloads \
    && chown -R pptruser:pptruser /home/pptruser \
    && cd /app \
    && npm install \
    && chown -R pptruser:pptruser /app

# Run everything after as non-privileged user.
USER pptruser

ADD ./entrypoint.sh /

RUN ls -al /app

#ENTRYPOINT ["/entrypoint.sh"]
