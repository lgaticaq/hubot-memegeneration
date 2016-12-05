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
#   hubot meme templates - Get all templates availables
#   hubot meme generate <template_name> <text> - Generate a meme
#   hubot meme add <name> <id> - Add new template with name and id
#
# Author:
#   lgaticaq

templates = require "./templates.json"

module.exports = (robot) ->
  robot.respond /meme generate ([\d\w\.\-\_]+) ([\w\W\d\s]+)/, (res) ->
    templateName = res.match[1]
    rTemplate = "meme:templates:#{templateName}"
    templateId = robot.brain.get(rTemplate) or templates[templateName]
    text = res.match[2]
    username = process.env.IMGFLIP_USERNAME
    password = process.env.IMGFLIP_PASSWORD
    unless templateId?
      res.reply "the template does not exist"
      return
    if not username or not password
      res.reply "unset the IMGFLIP_USERNAME and IMGFLIP_PASSWORD " +
      "environment variables"
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
    storeTemplates = (k for k, v of templates)
    brainTemplates = []
    for k, v of robot.brain.data._private
      if /^meme:templates:/.test(k)
        brainTemplates.push(k.split("meme:templates:")[1])
    _templates = storeTemplates.concat brainTemplates
    res.send _templates.join(", ")

  robot.respond /meme add ([\d\w\.\-\_]+) (\d+)/, (res) ->
    name = res.match[1]
    templateId = res.match[2]
    robot.brain.set "meme:templates:#{name}", templateId
    res.send "Template #{name} saved :ok_hand:"
