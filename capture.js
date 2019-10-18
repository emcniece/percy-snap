require('dotenv').config()
const PercyScript = require('@percy/script');

const percyOpts = {
  executablePath: '/usr/bin/google-chrome-unstable',
  args: ['--disable-dev-shm-usage', '--no-sandbox']
};

console.log((new Date()), 'Starting capture...');

PercyScript.run(async (page, percySnapshot) => {
    await page.goto(process.env.PERCY_TARGET_URL);
  
    if(process.env.PERCY_WAITFOR){
        wait = isNaN(parseInt(process.env.PERCY_WAITFOR)) ? process.env.PERCY_WAITFOR : parseInt(process.env.PERCY_WAITFOR);
        await page.waitFor(wait);
    }

    await percySnapshot('homepage');
    console.log((new Date()), 'Capture complete');
}, percyOpts);
