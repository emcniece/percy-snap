#!/bin/sh
#

set_cronjob(){
  echo "=> Init Cron Time: $CRON_TIME"

  if [ $( grep backup /etc/crontabs/root | wc -l ) -gt 0 ]; then
    echo "  - Cron job installed properly."
  else
    echo "  - Installing cron job"
    (crontab -u root -l; echo "${CRON_TIME} cd /app && /usr/local/bin/npx percy exec -- node index.js" ) | crontab -u root -
  fi
}

# Intro
PKG_VERSION=`node -p "require('./package.json').version"`
echo "=> PercySnap $PKG_VERSION"

# Do some jobs
set_cronjob

# Run cron in foreground
echo "=> Starting cron jobs!"
/usr/sbin/crond -f -l 8
