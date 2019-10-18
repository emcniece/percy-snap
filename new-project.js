/**
 * Percy.io New Project Automation Script
 * Ensure vars are populated in .env, then run:
 *   node new-project.js project1 project2 ...
 */

require('dotenv').config()
const puppeteer = require('puppeteer');

const projectNames = process.argv.slice(2);
const processed = {};

(async () => {
  const browser = await puppeteer.launch({
    //headless: false,
    //slowMo: 250
  });
  const page = await browser.newPage();

  console.log('login')
  await page.goto(`https://percy.io/login`)
  await page.waitFor('[type="email"]', {visible: true})
  await page.type('[type="email"]', process.env.PERCY_EMAIL)
  await page.type('[type="password"]', process.env.PERCY_PASSWORD)
  await page.click('.auth0-lock-submit')
  await page.waitForNavigation()

  for (const name of projectNames) {
    await page.goto(`https://percy.io/organizations/${process.env.PERCY_ORG}/projects/new`);

    // // New project page
    await page.waitFor('[placeholder="widgets-web-app"]', {visible: true})
    await page.type('[placeholder="widgets-web-app"]', name)
    await page.click('.FormsProjectNew .FormFieldsSubmit button')
    await page.waitForNavigation()

    page.on('response', async (response) => {
      if (response.url() == `https://percy.io/api/v1/projects/${process.env.PERCY_ORG}/${name}/tokens`){
        res = await response.json();
        console.log(name, res.data[0].attributes.token)
        processed[name] = res.data[0].attributes.token
      }
    }); 

    await page.goto(`https://percy.io/api/v1/projects/${process.env.PERCY_ORG}/${name}/tokens`, {waitUntil: 'networkidle2'});
  }

  await browser.close();
  console.log(processed)  
})();