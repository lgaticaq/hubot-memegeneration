# hubot-memegeneration

[![npm version](https://img.shields.io/npm/v/hubot-memegeneration.svg?style=flat-square)](https://www.npmjs.com/package/hubot-memegeneration)
[![npm downloads](https://img.shields.io/npm/dm/hubot-memegeneration.svg?style=flat-square)](https://www.npmjs.com/package/hubot-memegeneration)
[![Build Status](https://img.shields.io/travis/lgaticaq/hubot-memegeneration.svg?style=flat-square)](https://travis-ci.org/lgaticaq/hubot-memegeneration)
[![Coverage Status](https://img.shields.io/coveralls/lgaticaq/hubot-memegeneration/master.svg?style=flat-square)](https://coveralls.io/github/lgaticaq/hubot-memegeneration?branch=master)
[![Code Climate](https://img.shields.io/codeclimate/github/lgaticaq/hubot-memegeneration.svg?style=flat-square)](https://codeclimate.com/github/lgaticaq/hubot-memegeneration)
[![devDependency Status](https://img.shields.io/david/dev/lgaticaq/hubot-memegeneration.svg?style=flat-square)](https://david-dm.org/lgaticaq/hubot-memegeneration#info=devDependencies)

> A Hubot script to meme generation with imgflip API

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

`hubot meme generate <template_name> <text>` - `Generate a meme with text on the bottom`
`hubot meme generate <template_name> <text 1>|<text 2>` - `Generate a meme with text on the top (text1) and text on the bottom (text2)`

`hubot meme add <name> <id>` - `Add new template with name and id`

## How find new templates

Go to https://imgflip.com/memesearch.

![Search image](http://i.imgur.com/4Mb45I0.jpg)
![Select image](http://i.imgur.com/525EE1O.jpg)
![Get id of image](http://i.imgur.com/Ucd5zBn.jpg)

## License

[MIT](https://tldrlegal.com/license/mit-license)
