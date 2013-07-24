# Description:
#   Allows to deploy projects
#
# Dependencies:
#   None
#
# Configuration:
#
# Commands:
#   projects - lists all available projects
#   deploy <project> <env> <target-host> - deploys project to environment
#
# Author:
#   mpeschke

fs = require 'fs'
util  = require 'util'
proc = require 'child_process'

module.exports = (robot) ->
  robot.hear /who did it?/i, (msg) ->
      sender = msg.message.user.name.toLowerCase()
      msg.send("@"+sender+" You did it, Boss! You did it again!")
