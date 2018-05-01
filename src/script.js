// Description
//   A Hubot script to meme generation with imgflip API
//
// Dependencies:
//   None
//
// Configuration:
//   IMGFLIP_USERNAME, IMGFLIP_PASSWORD - https://imgflip.com/signup
//
// Commands:
//   hubot meme templates - Get all templates availables
//   hubot meme generate <template_name> <text> - Generate a meme with text on the bottom
//   hubot meme generate <template_name> <text 1>|<text 2> - Generate a meme with text on the top (text1) and text on the bottom (text2)
//   hubot meme add <name> <id> - Add new template with name and id
//
// Author:
//   lgaticaq

'use strict'

const templates = require('./templates.json')

module.exports = robot => {
  if (!process.env.IMGFLIP_USERNAME) {
    robot.logger.warning('The IMGFLIP_USERNAME environment variable not set.')
  }
  if (!process.env.IMGFLIP_PASSWORD) {
    robot.logger.warning('The IMGFLIP_PASSWORD environment variable not set.')
  }

  robot.respond(/meme generate ([\d\w.\-_]+) ([\w\W\d\s]+)/, res => {
    const templateName = res.match[1]
    const rTemplate = `meme:templates:${templateName}`
    const templateId = robot.brain.get(rTemplate) || templates[templateName]
    const [top, bottom] = Array.from(res.match[2].split('|'))
    const username = process.env.IMGFLIP_USERNAME
    const password = process.env.IMGFLIP_PASSWORD
    if (!templateId) {
      return res.reply('the template does not exist')
    }
    if (!username || !password) {
      return res.reply(
        'unset the IMGFLIP_USERNAME and IMGFLIP_PASSWORD ' +
          'environment variables'
      )
    }
    const query = {
      template_id: templateId,
      username,
      password
    }
    if (bottom) {
      query.text0 = top
      query.text1 = bottom
    } else {
      query.text1 = top
    }
    return res
      .http('https://api.imgflip.com/caption_image')
      .query(query)
      .post()((err, response, body) => {
        if (err) {
          res.reply('an error occurred while meme generation')
          robot.emit('error', err)
          return
        }
        const result = JSON.parse(body)
        if (!result.success) {
          res.reply('an error occurred while meme generation')
          robot.emit('error', new Error(result.error_message))
          return
        }
        return res.send(result.data.url)
      })
  })

  robot.respond(/meme templates/, res => {
    const storeTemplates = Object.keys(templates)
    const brainTemplates = Object.keys(robot.brain.data._private).reduce(
      (acc, k) => {
        if (/^meme:templates:/.test(k)) {
          acc.push(k.split('meme:templates:')[1])
        }
        return acc
      },
      []
    )
    const _templates = storeTemplates.concat(brainTemplates)
    res.send(_templates.join(', '))
  })

  robot.respond(/meme add ([\d\w.\-_]+) (\d+)/, res => {
    const name = res.match[1]
    const templateId = res.match[2]
    robot.brain.set(`meme:templates:${name}`, templateId)
    res.send(`Template ${name} saved :ok_hand:`)
  })
}
