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
#   Updated script to capture and render help commands
#
# Author:
#
#

Entities = require('html-entities').XmlEntities
entities = new Entities()

module.exports = (robot) ->

  robot.respond /help(?:\s+(.*))?$/i, (msg) ->
    cmds = getHelpCommands(robot)
    filter = msg.match[1]

    if filter
      cmds = cmds.filter (cmd) ->
        cmd.match new RegExp(filter, 'i')
      if cmds.length is 0
        msg.send "No available commands match #{filter}"
        return

    msg.send cmds.join '<br/>'

getHelpCommands = (robot) ->
  help_commands = robot.helpCommands()

  robot_name = robot.alias or robot.name

  if hiddenCommandsPattern()
    help_commands = help_commands.filter (command) ->
      not hiddenCommandsPattern().test(command)

  help_commands = help_commands.map (command) ->
    if robot_name.length is 1
      command.replace /^hubot\s*/i, robot_name
    else
      command.replace /^hubot/i, robot_name

  help_commands.sort().map (cmd) ->
    entities.encode(cmd)

hiddenCommandsPattern = ->
  hiddenCommands = process.env.HUBOT_HELP_HIDDEN_COMMANDS?.split ','
  new RegExp "^hubot (?:#{hiddenCommands?.join '|'}) - " if hiddenCommands
