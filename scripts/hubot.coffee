# Description:
#   Allows to deploy projects
#
# Dependencies:
#   None
#
# Configuration:
#
# Commands:
#   deploy <project> <env> - deployes project to environment
#   projects - lists all available projects
#
# Author:
#   mpeschke

fs = require 'fs'
util  = require 'util'
proc = require 'child_process'
starttime = new Date()
module.exports = (robot) ->
  robot.hear /projects/i, (msg) ->
    fs.readdir "../repos", (err, data) ->
      data.forEach (f) ->
        msg.send(f)

  robot.hear /deploy ([0-9a-zA-Z_-]*) ([0-9a-zA-Z_-]*)/i, (msg) ->
    if msg.match[1] and msg.match[2]
        msg.send "Okay Boss, getting right on it!"
        p = proc.spawn 'fab', ['-u', 'www-data', '-i', '../../../../deploy_key', '-H', 'bellerophon', 'deploy:env=dev'], {cwd: ('../repos/wines/deploy/')}
        p.stderr.on 'data', (data) -> msg.send 'stderr: ' + data
        p.on 'exit', (code) ->
          if code
            msg.send 'Deployment FAILED with ' + code
          else
            msg.send('Deploying '+msg.match[1]+'/'+msg.match[2]+' SUCCEEDED in '+ (( new Date().getTime() - starttime ) / 1000) + 's')
    else
        msg.send "Something is missing!"
