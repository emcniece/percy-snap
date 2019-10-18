require('dotenv').config()
const pkg = require('./package.json')
const cron = require('node-cron')
const { spawn } = require('child_process')
const fetch = require('node-fetch')
const path = require('path')

const cwd = path.dirname(require.main.filename)

async function getIp() {
    let res = await fetch('https://ifconfig.co/ip')
    let data = await res.text()
    return data.trim()
}

function randomDailyCrontime() {
    let hour = Math.floor(Math.random() * Math.floor(23));
    let minute = Math.floor(Math.random() * Math.floor(59));
    return `${minute} ${hour} * * *`
}

function runCapture() {
    getIp().then(ip => {
        spawn(cwd+'/node_modules/.bin/percy', ['exec', '--', 'node', cwd+'/capture.js'], {
            env: {
                ...process.env,
                PERCY_BRANCH: ip
            },
            stdio: 'inherit'
        });
    });
}

console.log('PercySnap version', pkg.version)
console.log('CRON_TIME:', process.env.CRON_TIME)

let cronTime = process.env.CRON_TIME
if(cronTime == 'daily') {
    cronTime = randomDailyCrontime()
    console.log('Rendered Cron schedule:', cronTime)
}

// Trigger on boot, then schedule future runs
runCapture();
cron.schedule(cronTime, runCapture);
