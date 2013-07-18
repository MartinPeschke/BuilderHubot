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

  robot.router.get "/deploy/project", (req, res) ->
    query = querystring.parse(url.parse(req.url).query)

    res.end
    user = {}
    user.room = query.room if query.room
    user.type = query.type if query.type

    try
      payload = JSON.parse req.body.payload

      robot.send user, "DEPLOYED # new commits"


    catch error
      console.log "github-commits error: #{error}. Payload: #{req.body.payload}"
