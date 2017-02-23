#!/bin/bash

# Runs the Hubot butler bot, using 'symphony' adapter

BUILD_FOLDER=./butler-build

BOT_NAME=$1

cd $BUILD_FOLDER

. ./env.sh
./bin/hubot -a symphony --name $BOT_NAME
