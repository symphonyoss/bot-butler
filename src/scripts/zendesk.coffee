#
#    Copyright 2016 The Symphony Software Foundation
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
#
# Description
#   Queries Zendesk for information about support tickets
#
# Configuration:
#   HUBOT_ZENDESK_USER
#   HUBOT_ZENDESK_PASSWORD
#   HUBOT_ZENDESK_SUBDOMAIN
#
# Commands:
#   hubot zd (all) - returns the total count of all unsolved tickets. The 'all' keyword is optional. \n
#   hubot zd new - returns the count of all new (unassigned) tickets
#   hubot zd open - returns the count of all open tickets
#   hubot zd escalated - returns a count of tickets with escalated tag that are open or pending
#   hubot zd pending - returns a count of tickets that are pending
#   hubot zd list (all) - returns a list of all unsolved tickets. The 'all' keyword is optional.
#   hubot zd list new - returns a list of all new tickets
#   hubot zd list open - returns a list of all open tickets
#   hubot zd list pending - returns a list of pending tickets
#   hubot zd list escalated - returns a list of escalated tickets
#   hubot zd-<ID> - returns information about the specified ticket
# Author:
# Symphony Integration by Vinay Mistry
Entities = require('html-entities').XmlEntities
entities = new Entities()

sys = require 'sys' # Used for debugging
tickets_url = "https://#{process.env.HUBOT_ZENDESK_SUBDOMAIN}.zendesk.com/tickets"
queries =
  unsolved: "search.json?query=status<solved+type:ticket"
  open: "search.json?query=status:open+type:ticket"
  new: "search.json?query=status:new+type:ticket"
  escalated: "search.json?query=tags:escalated+status:open+status:pending+type:ticket"
  pending: "search.json?query=status:pending+type:ticket"
  tickets: "tickets"
  users: "users"


zendesk_request = (msg, url, handler) ->
  zendesk_user = "#{process.env.HUBOT_ZENDESK_USER}"
  zendesk_password = "#{process.env.HUBOT_ZENDESK_PASSWORD}"
  auth = new Buffer("#{zendesk_user}:#{zendesk_password}").toString('base64')
  zendesk_url = "https://#{process.env.HUBOT_ZENDESK_SUBDOMAIN}.zendesk.com/api/v2"

  msg.http("#{zendesk_url}/#{url}")
    .headers(Authorization: "Basic #{auth}", Accept: "application/json")
      .get() (err, res, body) ->
        if err
          msg.send "Zendesk says: #{err}"
          return

        content = JSON.parse(body)

        if content.error?
          if content.error?.title
            msg.send "Zendesk says: #{content.error.title}"
          else
            msg.send "Zendesk says: #{content.error}"
          return

        handler content

# FIXME this works about as well as a brick floats
zendesk_user = (msg, user_id) ->
  zendesk_request msg, "#{queries.users}/#{user_id}.json", (result) ->
    if result.error
      msg.send result.description
      return
    result.user


module.exports = (robot) ->

  robot.hear /(?:zendesk|zd-)([\d]+)$/i, (msg) ->
    ticket_id = msg.match[1]
    zendesk_request msg, "#{queries.tickets}/#{ticket_id}.json", (result) ->
      if result.error
        msg.send result.description
        return

      msg.send {
       format: 'MESSAGEML'
       text: "<messageML><b>#{result.ticket.id}</b> <b>#{result.ticket.subject}</b><br/><i>Status: #{result.ticket.status.toUpperCase()}</i><br/><a href=\"#{entities.encode(tickets_url)}/#{result.ticket.id}\"/></messageML>"
      }

  robot.respond /(?:zendesk|zd) (all)/i, (msg) ->
    zendesk_request msg, queries.unsolved, (results) ->
      ticket_count = results.count
      msg.send "#{ticket_count} unsolved tickets"

  robot.respond /(?:zendesk|zd) pending/i, (msg) ->
    zendesk_request msg, queries.pending, (results) ->
      ticket_count = results.count
      msg.send "#{ticket_count} unsolved tickets"

  robot.respond /(?:zendesk|zd) new/i, (msg) ->
    zendesk_request msg, queries.new, (results) ->
      ticket_count = results.count
      msg.send "#{ticket_count} new tickets"

  robot.respond /(?:zendesk|zd) escalated/i, (msg) ->
    zendesk_request msg, queries.escalated, (results) ->
      ticket_count = results.count
      msg.send "#{ticket_count} escalated tickets"

  robot.respond /(?:zendesk|zd) open/i, (msg) ->
    zendesk_request msg, queries.open, (results) ->
      ticket_count = results.count
      msg.send "#{ticket_count} open tickets"

  robot.respond /(?:zendesk|zd) list (all)/i, (msg) ->
    zendesk_request msg, queries.unsolved, (results) ->
      for result in results.results
        msg.send {
        format: 'MESSAGEML'
        text: "<messageML><b>#{result.id}</b> <b>#{result.subject}</b> is <b>#{result.status.toUpperCase()}</b><br/><a href=\"#{entities.encode(tickets_url)}/#{result.id}\"/></messageML>"
        }

  robot.respond /(?:zendesk|zd) list new/i, (msg) ->
    zendesk_request msg, queries.new, (results) ->
      for result in results.results
        msg.send {
        format: 'MESSAGEML'
        text: "<messageML><b>#{result.id}</b> <b>#{result.subject}</b> is <b>#{result.status.toUpperCase()}</b><br/><a href=\"#{entities.encode(tickets_url)}/#{result.id}\"/></messageML>"
        }

  robot.respond /(?:zendesk|zd) list pending/i, (msg) ->
    zendesk_request msg, queries.pending, (results) ->
      for result in results.results
        msg.send {
        format: 'MESSAGEML'
        text: "<messageML><b>#{result.id}</b> <b>#{result.subject}</b> is <b>#{result.status.toUpperCase()}</b><br/><a href=\"#{entities.encode(tickets_url)}/#{result.id}\"/></messageML>"
        }

  robot.respond /(?:zendesk|zd) list escalated/i, (msg) ->
    zendesk_request msg, queries.escalated, (results) ->
      for result in results.results
        msg.send {
        format: 'MESSAGEML'
        text: "<messageML><b>#{result.id}</b> <b>#{result.subject}</b> is <b>#{result.status.toUpperCase()}</b><br/><a href=\"#{entities.encode(tickets_url)}/#{result.id}\"/></messageML>"
        }

  robot.respond /(?:zendesk|zd) list open/i, (msg) ->
    zendesk_request msg, queries.open, (results) ->
      for result in results.results
        msg.send {
        format: 'MESSAGEML'
        text: "<messageML><b>#{result.id}</b> <b>#{result.subject}</b> is <b>#{result.status.toUpperCase()}</b><br/><a href=\"#{entities.encode(tickets_url)}/#{result.id}\"/></messageML>"
        }

  robot.respond /(?:zendesk|zd-)([\d]+)$/i, (msg) ->
    ticket_id = msg.match[1]
    zendesk_request msg, "#{queries.tickets}/#{ticket_id}.json", (result) ->
      if result.error
        msg.send result.description
        return

       msg.send {
       format: 'MESSAGEML'
       text: "<messageML><b>#{result.ticket.id}</b> <b>#{result.ticket.subject}</b><br/><a href=\"#{entities.encode(tickets_url)}/#{result.ticket.id}\"/><br/>Status: #{result.ticket.status.toUpperCase()}</messageML>"
       }
