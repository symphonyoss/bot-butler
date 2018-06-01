//
//
//
// Copyright 2016 Symphony Communication Services, LLC
//
// Licensed to Symphony Communication Services, LLC under one
// or more contributor license agreements.  See the NOTICE file
// distributed with this work for additional information
// regarding copyright ownership.  The ASF licenses this file
// to you under the Apache License, Version 2.0 (the
// "License"); you may not use this file except in compliance
// with the License.  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.
//
//
// Description
//   Listen for cash tags and look up market data at Yahoo Finance
//
// Author:
// Symphony Integration by Vinay Mistry (mistryvinay)
//
const Entities = require('html-entities').XmlEntities;
const entities = new Entities();

//apikey = process.env.HUBOT_BARCHARTS_API_KEY

const _lookupPrice = (robot, msg, ticker) =>
    robot.http(`https://query1.finance.yahoo.com/v7/finance/quote?symbols=${ticker}`)
    .header('Accept', 'application/json')
    .get()(function(err, res, body) {
        if (err) {
            return msg.send(`Failed to look up ${ticker}`);
        } else {
            try {
                const json = JSON.parse(body);
                return msg.send({
                    text: '<messageML><div class="entity" data-entity-id="tabletable"><table><tr><th>Symbol</th><th>Name</th><th>Bid Ask</th>
<th>Change</th><th>% Change</th><th>Open</th><th>Days Range</th><th>Previous Close</th></tr><#list entity["tabletable"].tr as tr><tr><td>${tr
.col1}</td><td>${tr.col2}</td><td>${tr.col3}</td><td>${tr.col4}</td><td>${tr.col5}</td><td>${tr.col6}</td><td>${tr.col7}</td><td>${tr.col8}</
td></tr></#list></table></div></messageML>',
                    data: JSON.stringify({
                        "tabletable": {
                            "tr": [{
                                "col1": `<cash tag=\"${json.quoteResponse.result[0].symbol}\"/>`,
                                "col2": `${json.quoteResponse.result[0].longName}`,
                                "col3": `${json.quoteResponse.result[0].bid}`,
                                "col4": `${json.quoteResponse.result[0].regularMarketChange}`,
                                "col5": `(${json.quoteResponse.result[0].regularMarketChangePercent}%)`,
                                "col6": `${json.quoteResponse.result[0].regularMarketOpen}`,
                                "col7": `${json.quoteResponse.result[0].regularMarketDayRange}`,
                                "col8": `${json.quoteResponse.result[0].regularMarketPreviousClose}`
                            }]
                        }
                    })
                });
            } catch (error) {}
        }
    });

module.exports = robot =>
    robot.hear(/<cash tag=".*"\/>/i, function(msg) {
        const regex = /(?:<cash tag=["'])([^"']+)(?:["']\/>)/gi;
        return (() => {
            let match;
            const result = [];
            while ((match = regex.exec(msg.match))) {
                result.push(_lookupPrice(robot, msg, match[1]));
            }
            return result;
        })();
    });
