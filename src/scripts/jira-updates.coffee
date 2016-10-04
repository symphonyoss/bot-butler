#
#
#
# Copyright 2016 Symphony Communication Services, LLC
#
# Licensed to Symphony Communication Services, LLC under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#
#
# Description
#   Forward Jira updates and comments to Symphony users if they are watching Jira tickets.
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_JIRA_URL
#
# Commands:
#   None
#
# Author:
# Symphony Integration by Vinay Mistry (mistryvinay)
#

module.exports = (robot) ->
  robot.router.post '/butler/3hbr8sg5g5bcp39sxy733', (req, res) ->
    email = req.params.email
    message = req.message

  if message.webhookEvent == 'jira:issue_updated' && message.comment
    issue = "#{message.issue.key} #{message.issue.fields.summary}"
    url = "#{process.env.HUBOT_JIRA_URL}/browse/#{message.issue.key}"
    content = message.comment.body.replace(/\[~([a-zA-Z0-9]+)\]/g,'@$1')
    assignee = message.issue?.fields?.assignee?.name
    cc = if assignee then ' (cc @' + assignee + ')' else ''
   robot.adapter.sendDirectMessageToEmail(email, message)
#   robot.messageRoom room, "*#{issue}* _(#{url})_\n> @#{body.comment.author.name}'s comment#{cc}:\n> #{content}"
  res.send 'OK'
