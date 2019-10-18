# PercySnap - Automated Visual Regression + Notifications

[![Github version](https://img.shields.io/github/package-json/v/emcniece/percy-snap)](https://github.com/emcniece/percy-snap) [![Docker Stars](https://img.shields.io/docker/stars/emcniece/percysnap.svg)](https://cloud.docker.com/repository/docker/emcniece/percysnap) [![Docker Pulls](https://img.shields.io/docker/pulls/emcniece/percysnap.svg)](https://cloud.docker.com/repository/docker/emcniece/percysnap)

Automate website screenshot uploads to [Percy.io](https://percy.io) for visual regression testing with this parameterized Docker container. Designed to work locally or in remote clusters. Enable Slack notifications to get pinged when a site changes.


## Usage

### Docker CLI

Set environment variables and run:

```sh
docker run -d \
  -e PERCY_TOKEN=xxx \
  -e PERCY_TARGET_URL=https://google.com \
  -e CRON_TIME=daily \
  --name percysnap

docker logs -f percysnap
```

### Docker-Compose

Create `.env` from the sample, then run with Docker Compose:

```sh
docker pull emcniece/percysnap:latest
cp .env.sample .env
# ... edit .env
docker-compose up
```

## Behaviour

- Runs a snapshot on container start
- Reads `CRON_TIME` env for job scheduling
- `CRON_TIME` can be set to `"daily"` for a random time
- Scheduled runs are managed by [node-cron](https://www.npmjs.com/package/node-cron)


## Development

```sh
npm install
node index.js
```

## New Project Automation

The `new-project.js` script uses Puppeteer to automate the bulk creation of projects. Dumps a list of project names and `PERCY_TOKEN`s.

Populate the email, password, and org variables in `.env` and execute. Requires a Percy account that has the email/password login method enabled.

```sh
node new-project.js project1 project2 ...
# { 'project1': 'xxx', 'project2': 'yyy' }
```

## Todo

- [ ] Optimize image, reduce size
