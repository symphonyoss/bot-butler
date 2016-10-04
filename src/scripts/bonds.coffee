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
#   Respond to Bond pricing requests and look up market data at XigniteBondMaster https://www.xignite.com/product/bond-master-data
#
# Author:
# Symphony Integration by Vinay Mistry (mistryvinay)
#
Entities = require('html-entities').XmlEntities
entities = new Entities()

apikey = process.env.HUBOT_XIGNITE_BONDMASTER_API_KEY

module.exports = (robot) ->
  robot.hear /bond ([A-Z]{2}[0-9A-Z]{9}[0-9])\b/i, (msg) ->
    ticker = escape(msg.match[1])
    msg.http("http://bonds.xignite.com/xBonds.json/GetLastSale?IdentifierType=ISIN&Identifier=#{ticker}&PriceSource=FINRA&_Token=5F987D97485F485EACEF6106FBA70BD0")
      .get() (err, res, body) ->
        if err
           msg.send "Failed to look up #{ticker}"
        else
           json = JSON.parse(body)
           msg.send {
             format: 'MESSAGEML'
             text: "<messageML><b>#{json.BondLastSale.Symbol}</b><br/>#{json.BondLastSale.ShortName}<br/>Source: #{json.BondLastSale.PriceSource}<br/>Last Sale: $#{json.BondLastSale.LastSale} Size: #{json.BondLastSale.LastSaleSize}<br/>Date: #{json.BondLastSale.LastSaleDate} Time: #{json.BondLastSale.LastSaleTime}<br/>Yield: #{json.BondLastSale.YieldToMaturity}</messageML>"
           }
