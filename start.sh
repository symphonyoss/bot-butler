#!/bin/bash
#
#Define Environment Variables Here
export HUBOT_SYMPHONY_HOST=pod.symphony.com:443
export HUBOT_SYMPHONY_KM_HOST=keymanager.symphony.com:8444
export HUBOT_SYMPHONY_AGENT_HOST=agent.symphony.com
export HUBOT_SYMPHONY_PUBLIC_KEY=/home/butler/certs/bot.user5-PublicCert.pem
export HUBOT_SYMPHONY_PRIVATE_KEY=/home/butler/certs/bot.user5-PrivateKey.pem
export HUBOT_SYMPHONY_PASSPHRASE=changeit
export HUBOT_LOG_LEVEL=debug
export PORT=8080

#REDIS Brain - onfigure the below if you would like to use a database to store session state
#export REDIS_URL=redis://27d6e48e14775276ddfd8fb13f5d398df1b6f1e1c5d4731ac7147f14de4d12f0@127.0.0.1:16379/butler

#Define JIRA variables here
export HUBOT_JIRA_URL=
export HUBOT_JIRA_USERNAME=
export HUBOT_JIRA_PASSWORD=

#Define ZenDesk variables here
export HUBOT_ZENDESK_USER=
export HUBOT_ZENDESK_PASSWORD=
export HUBOT_ZENDESK_SUBDOMAIN=

#Start Hubot Bot
bin/hubot -a symphony --name butler
