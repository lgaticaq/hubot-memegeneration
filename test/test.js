'use strict'

const Helper = require('hubot-test-helper')
const { describe, it, beforeEach, afterEach } = require('mocha')
const { expect } = require('chai')
const nock = require('nock')

const helper = new Helper('../src/index.js')

describe('memegeneration', function () {
  this.timeout(20000)
  process.env.IMGFLIP_USERNAME = 'lgaticaq'
  process.env.IMGFLIP_PASSWORD = 'lgaticaq'
  const apiUrl = 'https://api.imgflip.com'
  const apiPath = '/caption_image'
  const query = {
    template_id: 61151469,
    username: 'lgaticaq',
    password: 'lgaticaq',
    text1: 'vamo a embriagarno'
  }
  const query2 = {
    template_id: 61151469,
    username: 'lgaticaq',
    password: 'lgaticaq',
    text0: 'otra vez',
    text1: 'vamo a embriagarno'
  }

  beforeEach(() => {
    this.room = helper.createRoom({ httpd: false })
  })

  afterEach(() => {
    this.room.destroy()
  })

  describe('generate a meme', () => {
    beforeEach(done => {
      nock(apiUrl)
        .post(apiPath)
        .query(query)
        .reply(200, {
          data: {
            page_url: 'https://imgflip.com/i/10ied8',
            url: 'http://i.imgflip.com/10ied8.jpg'
          },
          success: true
        })
      this.room.user.say(
        'user',
        'hubot meme generate squirtle vamo a embriagarno'
      )
      setTimeout(done, 100)
    })

    it('should get a meme', () => {
      expect(this.room.messages).to.eql([
        ['user', 'hubot meme generate squirtle vamo a embriagarno'],
        ['hubot', 'http://i.imgflip.com/10ied8.jpg']
      ])
    })
  })

  describe('list templates availables', () => {
    beforeEach(done => {
      this.room.robot.brain.data._private['karma'] = '1010100'
      this.room.robot.brain.data._private['meme:templates:test-_.12'] =
        '1010101'
      this.room.user.say('user', 'hubot meme templates')
      setTimeout(done, 100)
    })

    it('should get list of templates availables', () => {
      const t =
        'squirtle, charmander, bulbasaur, fry, huemul, money, mufasa, ' +
        'doge, test-_.12'
      expect(this.room.messages).to.eql([
        ['user', 'hubot meme templates'],
        ['hubot', t]
      ])
    })
  })

  describe('undefined template', () => {
    beforeEach(done => {
      this.room.user.say(
        'user',
        'hubot meme generate undefined vamo a embriagarno'
      )
      setTimeout(done, 100)
    })

    it('should reply to user with a error message', () => {
      expect(this.room.messages).to.eql([
        ['user', 'hubot meme generate undefined vamo a embriagarno'],
        ['hubot', '@user the template does not exist']
      ])
    })
  })

  describe('server error', () => {
    beforeEach(done => {
      nock(apiUrl)
        .post(apiPath)
        .query(query)
        .replyWithError('Server error')
      this.room.user.say(
        'user',
        'hubot meme generate squirtle vamo a embriagarno'
      )
      setTimeout(done, 100)
    })

    it('should reply to user with a error message', () => {
      expect(this.room.messages).to.eql([
        ['user', 'hubot meme generate squirtle vamo a embriagarno'],
        ['hubot', '@user an error occurred while meme generation']
      ])
    })
  })

  describe('response error', () => {
    beforeEach(done => {
      nock(apiUrl)
        .post(apiPath)
        .query(query)
        .reply(200, {
          error_message: 'API error',
          success: false
        })
      this.room.user.say(
        'user',
        'hubot meme generate squirtle vamo a embriagarno'
      )
      setTimeout(done, 100)
    })

    it('should reply to user with a error message', () => {
      expect(this.room.messages).to.eql([
        ['user', 'hubot meme generate squirtle vamo a embriagarno'],
        ['hubot', '@user an error occurred while meme generation']
      ])
    })
  })

  describe('new template', () => {
    beforeEach(done => {
      this.room.user.say('user', 'hubot meme add test-_.12 1010101')
      setTimeout(done, 100)
    })

    it('should reply saved message', () => {
      expect(this.room.messages).to.eql([
        ['user', 'hubot meme add test-_.12 1010101'],
        ['hubot', 'Template test-_.12 saved :ok_hand:']
      ])
      const key = 'meme:templates:test-_.12'
      const brain = this.room.robot.brain.data._private[key]
      expect(brain).to.eql('1010101')
    })
  })

  describe('generate a meme from brain', () => {
    beforeEach(done => {
      nock(apiUrl)
        .post(apiPath)
        .query({
          template_id: 1010101,
          username: 'lgaticaq',
          password: 'lgaticaq',
          text1: 'vamo a embriagarno'
        })
        .reply(200, {
          data: {
            page_url: 'https://imgflip.com/i/10ied8',
            url: 'http://i.imgflip.com/10ied8.jpg'
          },
          success: true
        })
      this.room.robot.brain.data._private['meme:templates:test-_.12'] =
        '1010101'
      this.room.user.say(
        'user',
        'hubot meme generate test-_.12 vamo a embriagarno'
      )
      setTimeout(done, 100)
    })

    it('should get a meme', () => {
      expect(this.room.messages).to.eql([
        ['user', 'hubot meme generate test-_.12 vamo a embriagarno'],
        ['hubot', 'http://i.imgflip.com/10ied8.jpg']
      ])
    })
  })

  describe('unset api keys', () => {
    beforeEach(done => {
      delete process.env.IMGFLIP_USERNAME
      delete process.env.IMGFLIP_PASSWORD
      this.room.robot.brain.data._private['meme:templates:test-_.12'] =
        '1010101'
      this.room.user.say(
        'user',
        'hubot meme generate test-_.12 vamo a embriagarno'
      )
      setTimeout(done, 100)
    })

    it('should get a meme', () => {
      expect(this.room.messages).to.eql([
        ['user', 'hubot meme generate test-_.12 vamo a embriagarno'],
        [
          'hubot',
          '@user unset the IMGFLIP_USERNAME and IMGFLIP_PASSWORD ' +
            'environment variables'
        ]
      ])
    })
  })

  describe('generate a meme with top text', () => {
    beforeEach(done => {
      process.env.IMGFLIP_USERNAME = 'lgaticaq'
      process.env.IMGFLIP_PASSWORD = 'lgaticaq'
      nock(apiUrl)
        .post(apiPath)
        .query(query2)
        .reply(200, {
          data: {
            page_url: 'https://imgflip.com/i/10ied9',
            url: 'http://i.imgflip.com/10ied9.jpg'
          },
          success: true
        })
      this.room.user.say(
        'user',
        'hubot meme generate squirtle otra vez|vamo a embriagarno'
      )
      setTimeout(done, 100)
    })

    it('should get a meme', () => {
      expect(this.room.messages).to.eql([
        ['user', 'hubot meme generate squirtle otra vez|vamo a embriagarno'],
        ['hubot', 'http://i.imgflip.com/10ied9.jpg']
      ])
    })
  })
})
