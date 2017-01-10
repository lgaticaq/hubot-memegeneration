Helper = require("hubot-test-helper")
expect = require("chai").expect
nock = require("nock")

helper = new Helper("./../src/index.coffee")

describe "memegeneration", ->
  room = null
  @timeout(20000)
  process.env.IMGFLIP_USERNAME = "lgaticaq"
  process.env.IMGFLIP_PASSWORD = "lgaticaq"
  apiUrl = "https://api.imgflip.com"
  apiPath = "/caption_image"
  query =
    template_id: 61151469
    username: "lgaticaq"
    password: "lgaticaq"
    text1: "vamo a embriagarno"
  query2 =
    template_id: 61151469
    username: "lgaticaq"
    password: "lgaticaq"
    text0: "otra vez"
    text1: "vamo a embriagarno"

  beforeEach ->
    room = helper.createRoom()
    nock.disableNetConnect()

  afterEach ->
    room.destroy()
    nock.cleanAll()

  context "generate a meme", ->

    beforeEach (done) ->
      nock(apiUrl).post(apiPath).query(query).reply 200,
        data:
          page_url: "https://imgflip.com/i/10ied8",
          url: "http://i.imgflip.com/10ied8.jpg"
        success: true
      room.user.say("user", "hubot meme generate squirtle vamo a embriagarno")
      setTimeout(done, 100)

    it "should get a meme", ->
      expect(room.messages).to.eql([
        ["user", "hubot meme generate squirtle vamo a embriagarno"],
        ["hubot", "http://i.imgflip.com/10ied8.jpg"]
      ])

  context "list templates availables", ->

    beforeEach (done) ->
      room.robot.brain.data._private["karma"] = "1010100"
      room.robot.brain.data._private["meme:templates:test-_.12"] = "1010101"
      room.user.say("user", "hubot meme templates")
      setTimeout(done, 100)

    it "should get list of templates availables", ->
      t = "squirtle, charmander, bulbasaur, fry, huemul, money, mufasa, " +
      "doge, test-_.12"
      expect(room.messages).to.eql([
        ["user", "hubot meme templates"],
        ["hubot", t]
      ])

  context "undefined template", ->

    beforeEach (done) ->
      room.user.say("user", "hubot meme generate undefined vamo a embriagarno")
      setTimeout(done, 100)

    it "should reply to user with a error message", ->
      expect(room.messages).to.eql([
        ["user", "hubot meme generate undefined vamo a embriagarno"]
        ["hubot", "@user the template does not exist"]
      ])

  context "server error", ->

    beforeEach (done) ->
      nock(apiUrl).post(apiPath).query(query).replyWithError("Server error")
      room.user.say("user", "hubot meme generate squirtle vamo a embriagarno")
      setTimeout(done, 100)

    it "should reply to user with a error message", ->
      expect(room.messages).to.eql([
        ["user", "hubot meme generate squirtle vamo a embriagarno"]
        ["hubot", "@user an error occurred while meme generation"]
      ])

  context "response error", ->

    beforeEach (done) ->
      nock(apiUrl).post(apiPath).query(query).reply 200,
        error_message: "API error"
        success: false
      room.user.say("user", "hubot meme generate squirtle vamo a embriagarno")
      setTimeout(done, 100)

    it "should reply to user with a error message", ->
      expect(room.messages).to.eql([
        ["user", "hubot meme generate squirtle vamo a embriagarno"]
        ["hubot", "@user an error occurred while meme generation"]
      ])

  context "new template", ->

    beforeEach (done) ->
      room.user.say("user", "hubot meme add test-_.12 1010101")
      setTimeout(done, 100)

    it "should reply saved message", ->
      expect(room.messages).to.eql([
        ["user", "hubot meme add test-_.12 1010101"]
        ["hubot", "Template test-_.12 saved :ok_hand:"]
      ])
      brain = room.robot.brain.data._private["meme:templates:test-_.12"]
      expect(brain).to.eql("1010101")

  context "generate a meme from brain", ->
    beforeEach (done) ->
      nock(apiUrl).post(apiPath).query
        template_id: 1010101
        username: "lgaticaq"
        password: "lgaticaq"
        text1: "vamo a embriagarno"
      .reply 200,
        data:
          page_url: "https://imgflip.com/i/10ied8",
          url: "http://i.imgflip.com/10ied8.jpg"
        success: true
      room.robot.brain.data._private["meme:templates:test-_.12"] = "1010101"
      room.user.say("user", "hubot meme generate test-_.12 vamo a embriagarno")
      setTimeout(done, 100)

    it "should get a meme", ->
      expect(room.messages).to.eql([
        ["user", "hubot meme generate test-_.12 vamo a embriagarno"],
        ["hubot", "http://i.imgflip.com/10ied8.jpg"]
      ])

  context "unset api keys", ->
    beforeEach (done) ->
      delete process.env.IMGFLIP_USERNAME
      delete process.env.IMGFLIP_PASSWORD
      room.robot.brain.data._private["meme:templates:test-_.12"] = "1010101"
      room.user.say("user", "hubot meme generate test-_.12 vamo a embriagarno")
      setTimeout(done, 100)

    it "should get a meme", ->
      expect(room.messages).to.eql([
        ["user", "hubot meme generate test-_.12 vamo a embriagarno"],
        ["hubot", "@user unset the IMGFLIP_USERNAME and IMGFLIP_PASSWORD " +
        "environment variables"]
      ])

  context "generate a meme with top text", ->

    beforeEach (done) ->
      process.env.IMGFLIP_USERNAME = "lgaticaq"
      process.env.IMGFLIP_PASSWORD = "lgaticaq"
      nock(apiUrl).post(apiPath).query(query2).reply 200,
        data:
          page_url: "https://imgflip.com/i/10ied9",
          url: "http://i.imgflip.com/10ied9.jpg"
        success: true
      room.user.say(
        "user", "hubot meme generate squirtle otra vez|vamo a embriagarno")
      setTimeout(done, 100)

    it "should get a meme", ->
      expect(room.messages).to.eql([
        ["user", "hubot meme generate squirtle otra vez|vamo a embriagarno"],
        ["hubot", "http://i.imgflip.com/10ied9.jpg"]
      ])
