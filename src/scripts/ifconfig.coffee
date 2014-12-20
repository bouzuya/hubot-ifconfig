# Description
#   A Hubot script to respond hubot's ip address
#
# Configuration:
#   None
#
# Commands:
#   hubot ifconfig - respond hubot's ip address
#
# Author:
#   bouzuya <m@bouzuya.net>
#
module.exports = (robot) ->
  robot.respond /ifconfig$/i, (res) ->
    res.http('http://checkip.amazonaws.com').get() (err, _, body) ->
      return res.send('hubot-ifconfig: error') if err?
      res.send body.trim()
