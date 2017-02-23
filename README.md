[![Symphony Software Foundation - Active](https://cdn.rawgit.com/symphonyoss/contrib-toolbox/master/images/ssf-badge-incubating.svg)](https://symphonyoss.atlassian.net/wiki/display/FM/Incubating) [![Build Status](https://travis-ci.org/symphonyoss/bot-butler.svg)](https://travis-ci.org/symphonyoss/bot-butler) [![Dependencies](https://www.versioneye.com/user/projects/58ac50944ca76f0047de1847/badge.svg?style=flat-square)](https://www.versioneye.com/user/projects/58ac50944ca76f0047de1847?child=summary)

# Bot Butler
The Bot Butler is a collection of scripts for [Hubot](https://hubot.github.com/) that have been built and tested against [Symphony](http://www.symphony.com), using the [Hubot Symphony adapter](https://github.com/symphonyoss/hubot-symphony).

Scripts can be tested locally or deployed as a Docker container; additional scripts can be easily defined and distributed.

## Local run
1. `git clone https://github.com/symphonyoss/bot-butler.git ; cd bot-butler` - Checkout the bot-butler project
2. `cp env.sh.sample env.sh` - Configure environment variables (see below)
3. [Install NodeJS](https://nodejs.org/en/download/) 4.0 or higher
4. [Install yarn](https://yarnpkg.com/en/docs/install), a NodeJS build tool
5. `yarn install --pure-lockfile` - Install all project dependencies (in `./node_modules` folder)
6. `yarn generate-hubot` - Generate the hubot butler bot in `./butler-build` folder
7. `yarn run start-bot-butler` - Run it

To clean the generated bot simply type `yarn run clean`; Yarn will delegate script execution to bash scripts located in the [./bootstrap](bootstrap) folder; to know more, checkout [package.json](package.json).

## Docker run
1. Checkout project and set environment variables (as above, steps 1 and 2)
2. Create the Docker image - `docker build -t butler:v0.9.0 .`
3. Run the Docker image - `docker run butler:v0.9.0`

The root folder of the project will be mounted on `/home/butler`; as such, the following folder will be inherited by default:
- `src/scripts` into `/home/butler/butler-build/scripts`
- `./env.sh` into `/home/butler/butler-build/env.sh`
- `./certs` into `/home/butler/butler-build/certs`

To override default values, use the following syntax:
```
docker run -v /myscripts:/home/butler/scripts -v /mycerts:/home/butler/certs butler:v0.9.0
```

## Configuration
Bot configurations are defined by environment variables in `env.sh` file, located in the root folder of the project; since the file may contain sensitive information, it is [ignored by github](.gitignore); a `env.sh.sample` file is provided to copy from.

Below are the configuration items:

- Symphony Pod coordinates: the Symphony API endpoint coordinates; make sure they point to the Symphony Pod you want to use and that you have access to it; default values are pointing to the [Foundation Open Developer Platform](https://symphonyoss.atlassian.net/wiki/display/FM/Open+Developer+Platform):
```
export HUBOT_SYMPHONY_HOST=foundation-dev.symphony.com
export HUBOT_SYMPHONY_KM_HOST=foundation-dev-api.symphony.com
export HUBOT_SYMPHONY_SESSIONAUTH_HOST=foundation-dev-api.symphony.com
export HUBOT_SYMPHONY_AGENT_HOST=foundation-dev-api.symphony.com
```
Read more on [hubot-symphony](https://github.com/symphonyoss/hubot-symphony).

- Bot Certificates: Ensure that you load your Bot user certificate and PrivateKey into the `./certs` folder
```
export HUBOT_SYMPHONY_PUBLIC_KEY=./certs/bot-PublicCert.pem
export HUBOT_SYMPHONY_PRIVATE_KEY=./certs/bot-PrivateKey.pem
export HUBOT_SYMPHONY_PASSPHRASE=changeit
```

If you want to know more about how to generate and register a certificate for your Symphony pod, checkout the [Foundation certificate-toolbox](http://github.com/symphonyoss/certificate-toolbox); bear in mind that:
1. `HUBOT_SYMPHONY_PUBLIC_KEY` must point to `user/<bot-name>-cert.pem`
2. `HUBOT_SYMPHONY_PRIVATE_KEY` must point to `user/<bot-name>-key.pem`
3. `user/<bot-name>-key.pem` have no password; set it using `openssl rsa-in ./user/<bot-name>-key.pem -out ./user/<bot-name>.key.pem -des3`

## Customise scripts

### Using a script
Hubot scripts can be automatically referenced if:
- listed in the [hubot-scripts organization](https://github.com/hubot-scripts) page
- [tagged on npmjs as *hubot-scripts*](https://www.npmjs.org/browse/keyword/hubot-scripts)

You can add them into [package.json](package.json) as `dependencies` and they'll be automatically added into `external-scripts.json` file.

### Writing a custom script
Want to write your own Hubot script? The best way is to take a look at [an existing script](src/scripts) and follow the [hubot-scripts documentation](https://www.npmjs.com/package/hubot-scripts).

All custom Hubot scripts in [src/scripts](src/scripts) are included in the bot; to define a sub-set of them, you can define a `hubot-scripts.json` file, which is created by `npm run generate-hubot` command and is empty by default.

Any third-party dependencies for scripts need the addition of your package.json otherwise a lot of errors will be thrown during the start up of your hubot. You can find a list of dependencies for a script in the documentation header at the top of the script.

### Distributing a custom script
The easiest way is to [publish the npm package](https://docs.npmjs.com/getting-started/publishing-npm-packages) using *hubot-scripts* as tag; read more on https://www.npmjs.org/browse/keyword/hubot-scripts

## Project dependencies
Bot Butler scripts depend on the following components:
- [Hubot](https://hubot.github.com/)
- [Hubot Symphony adapter](https://github.com/symphonyoss/hubot-symphony)
- Other NPM dependencies defined in [package.json](package.json); please note that dependency versions are snapshotted by the [yarn.lock](yarn.lock) file, ensuring that the runtime node modules being used across different environments are the same.

In order to update dependency versions to their latest allowed values (as specified by `package.json`), simply run the command `yarn install` without `--pure-lockfile`; read more on Yarn [install](https://yarnpkg.com/en/docs/cli/install) command.

The [Versioneye dashboard](https://www.versioneye.com/user/projects/58ac50944ca76f0047de1847?child=summary) reads the yarn.lock version available on github and provides license/security checks and notifications.

## Documentation
All scripts in hubot-symphony-scripts should contain a documentation header so people know everything about the script.
