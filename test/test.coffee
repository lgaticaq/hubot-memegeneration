Helper = require("hubot-test-helper")
expect = require("chai").expect
nock = require("nock")
templates = require("../src/templates.json")

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
      room.user.say("user", "hubot meme templates")
      setTimeout(done, 100)

    it "should get list of templates availables", ->
      expect(room.messages).to.eql([
        ["user", "hubot meme templates"],
        ["hubot", (k for k, v of templates).join(", ")]
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
      expect(room.robot.brain.data._private["meme:templates:test-_.12"]).to.eql("1010101")

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
