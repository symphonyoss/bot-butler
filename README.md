[![Symphony Software Foundation - Active](https://cdn.rawgit.com/symphonyoss/contrib-toolbox/master/images/ssf-badge-incubating.svg)](https://symphonyoss.atlassian.net/wiki/display/FM/Incubating)

[![Dependencies](https://www.versioneye.com/user/projects/58ac50944ca76f0047de1847/badge.svg?style=flat-square)](https://www.versioneye.com/user/projects/58ac50944ca76f0047de1847?child=summary)

# Bot Butler
The Bot Butler is a collection of scripts for [Hubot](https://hubot.github.com/) that have been built and tested against [Symphony](http://www.symphony.com), using the [Hubot Symphony adapter](https://github.com/symphonyoss/hubot-symphony).

Scripts can be tested locally or deployed as a Docker container; additional scripts can be easily defined and distributed.

## Local run
1. Checkout the bot-butler project - `git clone https://github.com/symphonyoss/bot-butler.git ; cd bot-butler`
2. Configure environment variables (see below) - `cp env.sh.sample env.sh`
3. Generate the Hubot - `npm run generate-hubot`
4. Run it - `npm run start-bot-butler`

If you want to clean the generated Hubot, simply type `rm -r ./build` from the project root folder; to know more about what scripts do, checkout [package.json](package.json).

## Docker run
1. Checkout project and set environment variables (as in local run)
2. Create the Docker image - `docker build -t butler:v0.9.0 .`
3. Run the Docker image - `docker run butler:v0.9.0`

By default, the following folders will be mounted:
- `src/scripts` into `/home/butler/scripts`
- `./certs` into `/home/butler/certs`

To override default values, use the following syntax:
```
docker run -v /myscripts:/home/butler/scripts -v /mycerts:/home/butler/certs butler:v1.0.0
```

## Configuration
Bot configurations are defined by environment variables in `env.sh` file, located in the root folder of the project; since the file may contain sensitive information, it is [ignored by github](.gitignore); a `env.sh.sample` file is provided to copy from.

Below are the configuration items:
1. Symphony Pod coordinates: the Symphony API endpoint coordinates; make sure they point to the Symphony Pod you want to use and that you have access to it:
```
FOUNDATION_API_URL=https://foundation-dev-api.symphony.com
FOUNDATION_POD_URL=https://foundation-dev.symphony.com
export HUBOT_SYMPHONY_HOST=$FOUNDATION_POD_URL/pod
export HUBOT_SYMPHONY_KM_HOST=$FOUNDATION_API_URL/keyauth
export HUBOT_SYMPHONY_AGENT_HOST=$FOUNDATION_API_URL/agent
```
2. Bot Certificates: Ensure that you load your Bot user certificate and PrivateKey into the folder butler/config/certs. Which ever name you choose for your certificates ensure that the /butler/start.sh also references this certificate name as well.
```
export HUBOT_SYMPHONY_PUBLIC_KEY=./certs/bot-PublicCert.pem
export HUBOT_SYMPHONY_PRIVATE_KEY=./certs/bot-PrivateKey.pem
export HUBOT_SYMPHONY_PASSPHRASE=changeit
```
3. Bot butler parameters: name of the bot, log level and port to expose (for container deployment)
```
export BOT_NAME=butler
export HUBOT_LOG_LEVEL=debug
export PORT=8080
```

## Installing
Once you have Hubot installed, you should already have hubot-scripts installed. Check package.json to be sure. If that is the case, you update hubot-scripts.json to list any scripts from this repository you want to load. The default hubot-scripts.json looks like:

```
["redis-brain.coffee", "shipit.coffee"]
```

If you update hubot-scripts in package.json, you will automatically get updates to your scripts listed here.

Alternatively, you can copy files from this repository into your scripts directory. Note that you would not get updates from the hubot-scripts repository unless you copy them yourself.

Any third-party dependencies for scripts need the addition of your package.json otherwise a lot of errors will be thrown during the start up of your hubot. You can find a list of dependencies for a script in the documentation header at the top of the script.

Restart your robot, and you're good to go.

All the scripts in this repository are located in [src/scripts](src/scripts).

## Writing a custom script
Want to write your own Hubot script? The best way is to take a look at [an existing script](src/scripts) and see how things are set up. Hubot scripts are written in CoffeeScript, a higher-level implementation of JavaScript.

### Distributing the script
There is a new system for distributing scripts, and adding them to your own hubot. Locate the appropriate script in the [hubot-scripts organization](https://github.com/hubot-scripts) or on [npm tagged as *hubot-scripts*](https://www.npmjs.org/browse/keyword/hubot-scripts), and follow the script's documentation. In general, this will be something like:

1. Add a line to external-scripts.json
2. Add a line to package.json
3. Add environment variables, depending on the script
4. Discovering

## Project dependencies
Bot Butler scripts depend on the following components:
- [Hubot](https://hubot.github.com/)
- [Hubot Symphony adapter](https://github.com/symphonyoss/hubot-symphony)
- Other NPM dependencies defined in [package.json](package.json)

Transitive dependencies are list in the [yarn.lock](yarn.lock) file, which is "manually" updated by running the command `npm run generate-yarn-lockfile`; the [Versioneye dashboard]() provides a license and security check.

## Documentation
All scripts in hubot-symphony-scripts should contain a documentation header so people know everything about the script.
