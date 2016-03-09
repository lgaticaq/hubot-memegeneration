# hubot-memegeneration

[![npm version](https://img.shields.io/npm/v/hubot-memegeneration.svg?style=flat-square)](https://www.npmjs.com/package/hubot-memegeneration)
[![npm downloads](https://img.shields.io/npm/dm/hubot-memegeneration.svg?style=flat-square)](https://www.npmjs.com/package/hubot-memegeneration)
[![Join the chat at https://gitter.im/lgaticaq/hubot-memegeneration](https://img.shields.io/badge/gitter-join%20chat%20%E2%86%92-brightgreen.svg?style=flat-square)](https://gitter.im/lgaticaq/hubot-memegeneration?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

A Hubot script to meme generation with imgflip API

## Installation
```bash
npm i -S hubot-memegeneration
```

add `["hubot-memegeneration"]` to `external-scripts.json`.

Signup in imgflip (https://imgflip.com/signup) and set environment variables.

```bash
export IMGFLIP_USERNAME=<your imgflip username>
export IMGFLIP_PASSWORD=<your imgflip password>
```

## Examples

`hubot meme squirtle <text>` - `Generate a meme with squirtle and text on the bottom`
`hubot meme templates` - `Get all templates availables`
