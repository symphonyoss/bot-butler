#!/bin/bash

# Generates the Hubot butler bot, only if BUILD_FOLDER doesn't exist
# It also prepares the BUILD_FOLDER for bot execution, copying 'env.sh' and 'certs' items

BUILD_FOLDER=./butler-build

CONFIG_OWNER=$1
BOT_NAME=$2

if [[ -d $BUILD_FOLDER ]]; then
  echo "skipping build, $BUILD_FOLDER already exists"
else

  # Create the BUILD_FOLDER, with certs and env.sh
  mkdir $BUILD_FOLDER
  cp -Rf env.sh certs $BUILD_FOLDER
  pushd $BUILD_FOLDER

  # Install and run Yeoman, to generate the bot project
  npm install yo generator-hubot --save-dev
  yo hubot --owner="$CONFIG_OWNER" --no-color --name="$BOT_NAME" --adapter='symphony' --defaults  --no-insight

  # Force hubot-help to version 0.1.3, since version 0.2.0 has a bug on message formatting
  sed 's/"hubot-help": "^0.2.0"/"hubot-help": "^0.1.3"/g' package.json > package.json.new
  mv package.json.new package.json
  popd

  # Use the script definitions defined in src/script
  cp -Rf src/scripts $BUILD_FOLDER
fi
