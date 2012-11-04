request   = require 'request'
_         = require('underscore')
echonest  = require('../app/services/echonest')

describe 'Songs', ->
  songs = {}

  beforeEach (done) ->
    echonest.Band.find 'massy ferguson', (band) ->
      band.songs (s)->
        songs = s
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
