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
#
# Description
#   An Out of Office responder which auto-responds when a user is @mentioned
#
# Commands:
#   hubot away <msg> - Turn ON Out Of Office auto-responder
#   hubot return - Turn OFF Out Of Office auto-responder
#
# Author:
# Symphony Integration by Vinay Mistry
#
Entities = require('html-entities').XmlEntities
entities = new Entities()

going_away = [
  "You really do deserve the time off. I'll let everyone know when you're mentioned. Just let me know when you're back by using 'butler return'.",
  "Another holiday. I'll let everyone know when you're mentioned. Just let me know when you're back by using 'butler return'."
]

module.exports = (robot) ->

  robot.respond /away (.*)/i, (msg) ->
    msg.send msg.random going_away
    userId = msg.message.user.id
    existing = robot.brain.userForId(userId);
    existing.outOfOffice = {
      away: true
      awaymsg: msg.match[1]
    }
    robot.brain.userForId(userId, existing);

  robot.respond /return/i, (msg) ->
    msg.send "Well...it's about time! Now get back to work!"
    userId = msg.message.user.id
    existing = robot.brain.userForId(userId);
    existing.outOfOffice = {
      away: false
    }
    robot.brain.userForId(userId, existing);

  _lookupAway = (robot, msg, userId) ->
    existing = robot.brain.userForId(userId);
    if existing?.outOfOffice?.away
        robot.adapter._sendDirectMessageToUserId(msg.message.user.id,
        {
          format: 'MESSAGEML'
          text: "<messageML>Hey <mention uid=\"#{msg.message.user.id}\"/><br/><b>Auto-Reply from</b> #{existing.displayName}<br/>#{existing?.outOfOffi
ce?.awaymsg}</messageML>"
        })
        msg.send {
          format: 'MESSAGEML'
          text: "<messageML>Hey <mention uid=\"#{msg.message.user.id}\"/><br/><b>Auto-Reply from</b> #{existing.displayName}<br/>#{existing?.outOfOffi
ce?.awaymsg}</messageML>"
        }

  robot.hear /<mention uid=".*"\/>/i, (msg) ->
    regex = /(?:<mention uid=["'])(\d+)(?:["']\/>)/gi
    while match = regex.exec msg.match
        _lookupAway(robot, msg, match[1])
