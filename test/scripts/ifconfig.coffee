{Robot, User, TextMessage} = require 'hubot'
assert = require 'power-assert'
path = require 'path'
sinon = require 'sinon'

describe 'ifconfig', ->
  beforeEach (done) ->
    @sinon = sinon.sandbox.create()
    # for warning: possible EventEmitter memory leak detected.
    # process.on 'uncaughtException'
    @sinon.stub process, 'on', -> null
    @robot = new Robot(path.resolve(__dirname, '..'), 'shell', false, 'hubot')
    @robot.adapter.on 'connected', =>
      @robot.load path.resolve(__dirname, '../../src/scripts')
      done()
    @robot.run()

  afterEach (done) ->
    @robot.brain.on 'close', =>
      @sinon.restore()
      done()
    @robot.shutdown()

  describe 'listeners[0].regex', ->
    describe 'valid patterns', ->
      beforeEach ->
        @tests = [
          message: '@hubot ifconfig'
          matches: ['@hubot ifconfig']
        ]

      it 'should match', ->
        @tests.forEach ({ message, matches }) =>
          callback = @sinon.spy()
          @robot.listeners[0].callback = callback
          sender = new User 'bouzuya', room: 'hitoridokusho'
          @robot.adapter.receive new TextMessage(sender, message)
          actualMatches = callback.firstCall.args[0].match.map((i) -> i)
          assert callback.callCount is 1
          assert.deepEqual actualMatches, matches

  describe 'listeners[0].callback', ->
    beforeEach ->
      @hello = @robot.listeners[0].callback

    describe 'receive "@hubot ifconfig"', ->
      beforeEach ->
        httpGetResponse = @sinon.stub()
        httpGetResponse
          .onFirstCall()
          .callsArgWith 0, null, null, '111.222.111.222'
        httpGet = @sinon.stub()
        httpGet.onFirstCall().returns httpGetResponse
        http = @sinon.stub()
        http.onFirstCall().returns get: httpGet
        @send = @sinon.spy()
        @hello
          match: ['@hubot ifconfig']
          send: @send
          http: http

      it 'send "111.222.111.222"', ->
        assert @send.callCount is 1
        assert @send.firstCall.args[0] is '111.222.111.222'

  describe 'robot.helpCommands()', ->
    it 'should be ["hubot ifconfig - respond hubot\'s ip address"]', ->
      assert.deepEqual @robot.helpCommands(), [
        'hubot ifconfig - respond hubot\'s ip address'
      ]
