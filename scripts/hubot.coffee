# Description:
#   Allows to deploy projects
#
# Dependencies:
#   None
#
# Configuration:
#
# Commands:
#   who did it? - you did, boss
#   projects - lists all available projects
#   deploy <project> <env> <target-host> - deploys project to environment
#
# Author:
#   mpeschke

fs = require 'fs'
util  = require 'util'
proc = require 'child_process'

module.exports = (robot) ->
  robot.hear /who did it\?/i, (msg) ->
      msg.send("You did it, Boss! You did it again!")
      msg.send("Who else? Really...")
  robot.hear /who did it again\?/i, (msg) ->
      msg.send("You, Boss, no question! Is there anyone else?")

  robot.respond /projects/i, (msg) ->
    fs.readdir "../repos", (err, data) ->
      data.forEach (f) ->
        msg.send(f)

  robot.respond /deploy ([0-9a-zA-Z_-]*) ([0-9a-zA-Z_-]*) ([0-9a-zA-Z_-]*)/i, (msg) ->
    if msg.match[1] and msg.match[2]
        starttime = new Date()
        
        project = msg.match[1]
        env = msg.match[2]
        host = msg.match[3]
        
        msg.send "Okay Boss, getting right on it!"
        up =  proc.spawn "git", ["pull"], {cwd: "../repos/#{project}"}
        up.on "exit", (code) ->
            if code
              msg.send "Deployment FAILED no repo found by that name"
            else
              p = proc.spawn "fab", ["-u", "www-data", "-i", "../../../deploy_key", "-H", host, "deploy:env=#{env}"], {cwd: ("../repos/#{project}/deploy/")}
              p.stderr.on "data", (data) -> msg.send "stderr: " + data
              p.on "exit", (code) ->
                if code
                  msg.send "Deployment FAILED with " + code
                else
                  msg.send("Deploying #{project} / #{env} to #{host} SUCCEEDED in #{(( new Date().getTime() - starttime ) / 1000)} s")
    else
        msg.send "Something is missing!"
