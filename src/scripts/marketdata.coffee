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
#   Listen for cash tags and look up market data at Barcharts OnDemand http://barchartondemand.com/
#
# Author:
# Symphony Integration by Vinay Mistry (mistryvinay)
#
Entities = require('html-entities').XmlEntities
entities = new Entities()

apikey = process.env.HUBOT_BARCHARTS_API_KEY

_lookupPrice = (robot, msg, ticker) ->
  robot.http("http://marketdata.websol.barchart.com/getQuote.json?key=#{apikey}&symbols=#{ticker}")
    .header('Accept', 'application/json')
    .get() (err, res, body) ->
      if err
        msg.send "Failed to look up #{ticker}"
      else
        try
          json = JSON.parse(body)
          msg.send {
            format: 'MESSAGEML'
            text: "<messageML><cash tag=\"#{json.results[0].symbol}\"/> @ <b>#{json.results[0].lastPrice}</b> #{json.results[0].netChange} (#{json.results[0].percentChange}%) <br/>Open: #{json.results[0].open} High: #{json.results[0].high} Low: #{json.results[0].low} Close: #{json.results[0].close}</messageML>"
          }
        catch error
          msg.send "Failed to look up $#{ticker}"

module.exports = (robot) ->
  robot.hear /<cash tag=".*"\/>/i, (msg) ->
    regex = /(?:<cash tag=["'])([^"']+)(?:["']\/>)/gi
    while match = regex.exec msg.match
      _lookupPrice(robot, msg, match[1])
