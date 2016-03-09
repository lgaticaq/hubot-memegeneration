# Description
#   A Hubot script to meme generation with imgflip API
#
# Dependencies:
#   None
#
# Configuration:
#   IMGFLIP_USERNAME, IMGFLIP_PASSWORD - https://imgflip.com/signup
#
# Commands:
#   hubot meme squirtle <text> - Generate a meme with squirtle and text on the bottom
#   hubot meme templates - Get all templates availables
#
# Author:
#   lgaticaq

templates = require "./templates.json"

module.exports = (robot) ->
  robot.respond /meme (\w+) ([\w\W\d\s]+)/, (res) ->
    templateId = templates[res.match[1]]
    text = res.match[2]
    username = process.env.IMGFLIP_USERNAME or "lgaticaq"
    password = process.env.IMGFLIP_PASSWORD or "zuvngqtf"
    unless templateId?
      res.reply "the template does not exist"
      return
    if not username or not password
      res.reply "unset the IMGFLIP_USERNAME and IMGFLIP_PASSWORD environment variables"
      return
    res.http("https://api.imgflip.com/caption_image")
    .query
      template_id: templateId,
      username: username,
      password: password,
      text1: text
    .post() (err, response, body) ->
      if err
        res.reply "an error occurred while meme generation"
        robot.emit "error", err
        return
      result = JSON.parse(body)
      if not result.success
        res.reply "an error occurred while meme generation"
        robot.emit "error", new Error(result.error_message)
        return
      res.send result.data.url

  robot.respond /meme templates/, (res) ->
    res.send (k for k, v of templates).join(", ")
