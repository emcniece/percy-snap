#!/bin/bash

LOG="${LOG:-/app/cron.log}"
date | tee -a $LOG
/app/node_modules/.bin/percy exec -- /usr/local/bin/node /app/index.js 2>&1 | tee -a $LOG
