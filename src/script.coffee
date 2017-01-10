# Description
#   A Hubot script to meme generation with imgflip API
#
# Dependencies:
#   None
#
# Configuration:
#   IMGFLIP_USERNAME, IMGFLIP_PASSWORD - https://imgflip.com/signup
#
# coffeelint: disable=max_line_length
#
# Commands:
#   hubot meme templates - Get all templates availables
#   hubot meme generate <template_name> <text> - Generate a meme with text on the bottom
#   hubot meme generate <template_name> <text 1>|<text 2> - Generate a meme with text on the top (text1) and text on the bottom (text2)
#   hubot meme add <name> <id> - Add new template with name and id
#
# coffeelint: enable=max_line_length
#
# Author:
#   lgaticaq

templates = require "./templates.json"

module.exports = (robot) ->
  robot.respond /meme generate ([\d\w\.\-\_]+) ([\w\W\d\s]+)/, (res) ->
    templateName = res.match[1]
    rTemplate = "meme:templates:#{templateName}"
    templateId = robot.brain.get(rTemplate) or templates[templateName]
    [top, bottom] = (res.match[2]).split "|"
    username = process.env.IMGFLIP_USERNAME
    password = process.env.IMGFLIP_PASSWORD
    unless templateId?
      res.reply "the template does not exist"
      return
    if not username or not password
      res.reply "unset the IMGFLIP_USERNAME and IMGFLIP_PASSWORD " +
      "environment variables"
      return
    query =
      template_id: templateId,
      username: username,
      password: password,
    if bottom
      query.text0 = top
      query.text1 = bottom
    else
      query.text1 = top
    res.http("https://api.imgflip.com/caption_image")
    .query(query)
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
