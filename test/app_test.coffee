request = require 'request'
_ = require('underscore')
bandurl = require('../app/bandurl.js')

describe 'Songs', ->
  songs = {}

  beforeEach (done) ->
    bandurl.tracks 'massy ferguson', (tracks)->
      songs = tracks
      done()

  it 'should return songs', ->
    (_.size(songs) > 0).should.be.true

describe 'GET /', ->
  response = null
  before (done) ->
    request 'http://localhost:3000', (e, r, b) ->
      response = r
      done()

  it 'should return 200', (done) ->
    response.statusCode.should.equal 200
    done()
