require('dotenv').config()
const PercyScript = require('@percy/script');

PercyScript.run(async (page, percySnapshot) => {
  await page.goto(process.env.PERCY_TARGET_URL);
  
  // ensure the page has loaded before capturing a snapshot
  if(process.env.PERCY_WAITFOR){
    wait = isNaN(parseInt(process.env.PERCY_WAITFOR)) ? process.env.PERCY_WAITFOR : parseInt(process.env.PERCY_WAITFOR);
    await page.waitFor(wait);
  }
  
  await percySnapshot('homepage');
},{
  executablePath: '/usr/bin/google-chrome-unstable',
  args: ['--disable-dev-shm-usage', '--no-sandbox']
});