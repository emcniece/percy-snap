FROM node:10-slim

ENV CRON_TIME="0 0 * * *"
ENV LOG="/app/cron.log"

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    # Debug:
    # && apt-get install -y vim rsyslog procps \
    # Continue:
    && apt-get install -y cron google-chrome-unstable fonts-freefont-ttf \
      --no-install-recommends \
    && ln -s $(which node) /usr/bin/node \
    && rm -rf /var/lib/apt/lists/*


ADD package.json package-lock.json index.js cron.sh /app/

RUN groupadd -r pptruser && useradd -r -g pptruser -G audio,video,root pptruser \
    && mkdir -p /home/pptruser/Downloads \
    && chown -R pptruser:pptruser /home/pptruser \
    && cd /app \
    && npm install \
    && touch "$LOG" \
    && chown -R pptruser:pptruser /app \
    && (crontab -u pptruser -l; echo "${CRON_TIME} bash -l -c '/app/cron.sh'") | crontab -u pptruser -

# Run everything after as non-privileged user.
# Not needed for production?
#USER pptruser

ADD ./entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
