#!/bin/sh
# Utilizes $LOG from environment, initd in Dockerfile

set_cronjob(){
  echo "=> Init Cron Time: $CRON_TIME"
  user=$(whoami)

  if [ $( crontab -l | grep percy | wc -l ) -gt 0 ]; then
    echo "  - Cron job installed properly."
  else
    echo "  - Installing cron job"
    #(crontab -u root -l; echo "${CRON_TIME} cd /app && /usr/local/bin/npx percy exec -- node index.js" ) | crontab -u root -
    (crontab -u root -l; echo "${CRON_TIME} /app/cron.sh") | crontab -u root -
  fi
}

# Intro
PKG_VERSION=`node -p "require('/app/package.json').version"`
echo "=> PercySnap v$PKG_VERSION"

# Do some jobs
set_cronjob

# Populate .env for cron happiness
printenv > /app/.env

# Run cron in foreground
echo "=> Monitoring cron..."
service cron start
touch /app/cron.log
tail -f /app/cron.log
