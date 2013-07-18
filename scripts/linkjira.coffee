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
starttime = new Date()
module.exports = (robot) ->
  robot.hear /^([A-Z0-9]+-[0-9]+)$/i, (msg) ->
      msg.send("http://hackjira.cloudapp.net/browse/#{msg.match[1]}")
