#!/bin/bash

# Generates the Hubot butler bot, only if BUILD_FOLDER doesn't exist
# It also prepares the BUILD_FOLDER for bot execution, copying 'env.sh' and 'certs' items

BUILD_FOLDER=./butler-build

CONFIG_OWNER=$1
BOT_NAME=$2

if [[ -d $BUILD_FOLDER ]]; then
  echo "skipping build, $BUILD_FOLDER already exists"
else
  mkdir $BUILD_FOLDER
  # cp -Rf package.json env.sh certs $BUILD_FOLDER
  cp -Rf env.sh certs $BUILD_FOLDER
  # mv node_modules $BUILD_FOLDER
  pushd "$_"
  export PATH=$PATH:$PWD/node_modules/.bin
  yo hubot --owner="$CONFIG_OWNER" --no-color --name="$BOT_NAME" --adapter='symphony' --defaults  --no-insight
  popd
fi
