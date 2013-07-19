# Description:
#   An HTTP Listener for notifications on deployments
#
# Dependencies:
#   "url": ""
#   "querystring": ""
#
# Configuration:
#   Just post to this url <HUBOT_URL>:<PORT>/deploy/project?room=<room>
#
# Commands:
#   None
#
# URLS:
#   POST /deploy/project?room=<room>
#
# Authors:
#   nesQuick

url = require('url')
querystring = require('querystring')

module.exports = (robot) ->

  robot.router.post "/deploy/project", (req, res) ->
    query = querystring.parse(url.parse(req.url).query)
    res.end
    user = {}
    user.room = query.room if query.room
    user.type = query.type if query.type

    try
      payload = req.body
      if payload.commits.length > 0
        payload.commits.forEach (commit) ->
          robot.send user, "DEPLOYED: #{commit.date}:#{commit.name}:#{commit.subject}"
      else
        robot.send user, "DEPLOYED, but got nothing new"

    catch error
      console.log "postdeploy error: #{error}. Payload: #{req.body.payload}"
