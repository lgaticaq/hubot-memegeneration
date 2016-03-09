Helper = require("hubot-test-helper")
expect = require("chai").expect
nock = require("nock")
templates = require("../src/templates.json")

helper = new Helper("./../src/index.coffee")

describe "memegeneration", ->
  room = null
  text = "vamo a embriagarno"

  beforeEach ->
    room = helper.createRoom()
    nock.disableNetConnect()

  afterEach ->
    room.destroy()
    nock.cleanAll()

  context "unset environment variables", ->
    delete process.env.IMGFLIP_USERNAME
    delete process.env.IMGFLIP_PASSWORD

    beforeEach (done) ->
      nock("https://api.imgflip.com")
        .post("/caption_image")
        .query
          template_id: 55520613,
          username: "lgaticaq",
          password: "lgaticaq",
          text1: "vamo a embriagarno"
        .reply 200,
          error_message: "API error"
          success: false
      room.user.say("user", "hubot meme squirtle vamo a embriagarno")
      setTimeout(done, 100)

    it "should reply to user with a error message", ->
      expect(room.messages).to.eql([
        ["user", "hubot meme squirtle vamo a embriagarno"]
        ["hubot", "@user an error occurred while meme generation"]
      ])

  context "generate a meme", ->
    process.env.IMGFLIP_USERNAME = "lgaticaq"
    process.env.IMGFLIP_PASSWORD = "lgaticaq"

    beforeEach (done) ->
      nock("https://api.imgflip.com")
        .post("/caption_image")
        .query
          template_id: 55520613,
          username: "lgaticaq",
          password: "lgaticaq",
          text1: "vamo a embriagarno"
        .reply 200,
          data:
            page_url: "https://imgflip.com/i/10ied8",
            url: "http://i.imgflip.com/10ied8.jpg"
          success: true
      room.user.say("user", "hubot meme squirtle vamo a embriagarno")
      setTimeout(done, 100)

    it "should get a meme", ->
      expect(room.messages).to.eql([
        ["user", "hubot meme squirtle vamo a embriagarno"],
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
      room.user.say("user", "hubot meme undefined vamo a embriagarno")
      setTimeout(done, 100)

    it "should reply to user with a error message", ->
      expect(room.messages).to.eql([
        ["user", "hubot meme undefined vamo a embriagarno"]
        ["hubot", "@user the template does not exist"]
      ])

  context "server error", ->

    beforeEach (done) ->
      nock("https://api.imgflip.com")
        .post("/caption_image")
        .query
          template_id: 55520613,
          username: "lgaticaq",
          password: "lgaticaq",
          text1: "vamo a embriagarno"
        .replyWithError("Server error")
      room.user.say("user", "hubot meme squirtle vamo a embriagarno")
      setTimeout(done, 100)

    it "should reply to user with a error message", ->
      expect(room.messages).to.eql([
        ["user", "hubot meme squirtle vamo a embriagarno"]
        ["hubot", "@user an error occurred while meme generation"]
      ])

  context "response error", ->

    beforeEach (done) ->
      nock("https://api.imgflip.com")
        .post("/caption_image")
        .query
          template_id: 55520613,
          username: "lgaticaq",
          password: "lgaticaq",
          text1: "vamo a embriagarno"
        .reply 200,
          error_message: "API error"
          success: false
      room.user.say("user", "hubot meme squirtle vamo a embriagarno")
      setTimeout(done, 100)

    it "should reply to user with a error message", ->
      expect(room.messages).to.eql([
        ["user", "hubot meme squirtle vamo a embriagarno"]
        ["hubot", "@user an error occurred while meme generation"]
      ])
