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
//   badgers - yell back
//
// Author:
//   lgaticaq

'use strict'

const templates = require('./templates.json')

/**
 * Generate the image
 */
function generate (robot, res, query) {
  // add the creds...
  query.password = process.env.IMGFLIP_PASSWORD
  query.username = process.env.IMGFLIP_USERNAME
  if (!query.username || !query.password) {
    return res.reply(
      'unset the IMGFLIP_USERNAME and IMGFLIP_PASSWORD ' +
        'environment variables'
    )
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
}

module.exports = robot => {
  if (!process.env.IMGFLIP_USERNAME) {
    robot.logger.warning('The IMGFLIP_USERNAME environment variable not set.')
  }
  if (!process.env.IMGFLIP_PASSWORD) {
    robot.logger.warning('The IMGFLIP_PASSWORD environment variable not set.')
  }
  // mr burns
  robot.hear(/excellent/i, res => {
    const query = {
      template_id: templates['excellent'],
      text0: 'Excellent...'
    }
    return generate(robot, res, query)
  })
  // y u no
  robot.hear(/Y U NO (.+)/i, res => {
    const query = {
      template_id: templates['y-u-no'],
      text0: res.match[1]
    }
    return generate(robot, res, query)
  })
  // Spock
  robot.hear(/appears (.+)/i, res => {
    const query = {
      template_id: templates['spock'],
      text0: res.match[1]
    }
    return generate(robot, res, query)
  })

  robot.hear(/brace yourselves (.+)/i, res => {
    const query = {
      template_id: 61546,
      text0: 'Brace yourselves',
      text1: res.match[1]
    }
    return generate(robot, res, query)
  })

  robot.hear(/(.+) (ALL THE) (.+)/i, res => {
    const query = {
      template_id: 61533,
      text0: res.match[1],
      text1: res.match[3]
    }
    return generate(robot, res, query)
  })

  robot.hear(/(I DON'?T ALWAYS .*) (BUT WHEN I DO,? .*)/i, res => {
    const query = {
      template_id: 61532,
      text0: res.match[1],
      text1: res.match[2]
    }
    return generate(robot, res, query)
  })
  robot.hear(/(.*)(SUCCESS|NAILED IT)$/i, res => {
    const query = {
      template_id: 341570,
      text0: res.match[1],
      text1: res.match[2]
    }
    return generate(robot, res, query)
  })

  robot.hear(/(.*) (\w+\sTOO DAMN .*)/i, res => {
    const query = {
      template_id: 61580,
      text0: res.match[1],
      text1: res.match[2]
    }
    return generate(robot, res, query)
  })

  robot.hear(/^(NOT SURE IF .*) (OR .*)/i, res => {
    const query = {
      template_id: 61520,
      text0: res.match[1],
      text1: res.match[2]
    }
    return generate(robot, res, query)
  })

  robot.hear(/(YO DAWG .*) (SO .*)/i, res => {
    const query = {
      template_id: 101716,
      text0: res.match[1],
      text1: res.match[2]
    }
    return generate(robot, res, query)
  })

  robot.hear(/(All your .*) (are belong to .*)/i, res => {
    const query = {
      template_id: 4503404,
      text0: res.match[1],
      text1: res.match[2]
    }
    return generate(robot, res, query)
  })

  robot.hear(/(.*)\s+COURAGE\s+(.*)/i, res => {
    const query = {
      template_id: 61517,
      text0: res.match[1],
      text1: res.match[2]
    }
    return generate(robot, res, query)
  })

  robot.hear(/ONE DOES NOT SIMPLY (.*)/i, res => {
    const query = {
      template_id: 61579,
      text0: 'One does not simply',
      text1: res.match[1]
    }
    return generate(robot, res, query)
  })

  robot.hear(
    /((?:WOW )?(?:SUCH|MUCH) .*) ((SUCH|MUCH|SO|VERY|MANY) .*)/i,
    res => {
      const templateName = 'doge'
      const rTemplate = `meme:templates:${templateName}`
      const templateId = robot.brain.get(rTemplate) || templates[templateName]
      const top = res.match[1]
      const bottom = res.match[2]
      const query = {
        template_id: templateId
      }
      if (bottom) {
        query.text0 = top
        query.text1 = bottom
      } else {
        query.text1 = top
      }
      return generate(robot, res, query)
    }
  )

  robot.respond(/meme generate ([\d\w.\-_]+) ([\w\W\d\s]+)/, res => {
    const templateName = res.match[1]
    const rTemplate = `meme:templates:${templateName}`
    const templateId = robot.brain.get(rTemplate) || templates[templateName]
    const [top, bottom] = Array.from(res.match[2].split('|'))

    if (!templateId) {
      return res.reply('the template does not exist')
    }

    const query = {
      template_id: templateId
    }
    if (bottom) {
      query.text0 = top
      query.text1 = bottom
    } else {
      query.text1 = top
    }
    return generate(robot, res, query)
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
}
