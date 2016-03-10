# hubot-memegeneration

[![npm version](https://img.shields.io/npm/v/hubot-memegeneration.svg?style=flat-square)](https://www.npmjs.com/package/hubot-memegeneration)
[![npm downloads](https://img.shields.io/npm/dm/hubot-memegeneration.svg?style=flat-square)](https://www.npmjs.com/package/hubot-memegeneration)
[![Build Status](https://img.shields.io/travis/lgaticaq/hubot-memegeneration.svg?style=flat-square)](https://travis-ci.org/lgaticaq/hubot-memegeneration)
[![devDependency Status](https://img.shields.io/david/dev/lgaticaq/hubot-memegeneration.svg?style=flat-square)](https://david-dm.org/lgaticaq/hubot-memegeneration#info=devDependencies)
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

`hubot meme templates` - `Get all templates availables`

`hubot meme generate <name> <text>` - `Generate a meme with <name> and text on the bottom`

`hubot meme add <name> <id>` - `Add new template with name and id`

## How add new templates

Go to https://imgflip.com/memesearch.

![Search image](http://i.imgur.com/4Mb45I0.jpg)
![Select image](http://i.imgur.com/525EE1O.jpg)
![Get id of image](http://i.imgur.com/Ucd5zBn.jpg)
![Add id to json](http://i.imgur.com/2E7zDJz.jpg)
