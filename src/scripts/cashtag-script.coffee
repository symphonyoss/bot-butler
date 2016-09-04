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
#   Listen for cash tags and look up latest price from MarkIt
#
# Author:
#   jonfreedman
#

_lookupPrice = (robot, msg, ticker) ->
  robot.http("http://dev.markitondemand.com/MODApis/Api/v2/Quote/json?symbol=#{ticker}")
    .header('Accept', 'application/json')
    .get() (err, res, body) ->
      if err
        msg.send "Failed to look up #{ticker}"
      else
        try
          data = JSON.parse body
          msg.send {
            format: 'MESSAGEML'
            text: "<messageML><cash tag=\"#{ticker.toUpperCase()}\"/> @ #{data.LastPrice}</messageML>"
          }
        catch error
          msg.send "Failed to parse JSON response '#{body}' - #{error}"

module.exports = (robot) ->
  robot.hear /<cash tag=".*"\/>/i, (msg) ->
    regex = /(?:<cash tag=["'])([^"']+)(?:["']\/>)/gi
    while match = regex.exec msg.match
      _lookupPrice(robot, msg, match[1])
