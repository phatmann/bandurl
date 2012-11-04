request   = require 'request'
_         = require('underscore')
echonest  = require('../app/services/echonest')

describe 'Bands', ->
  bands = {}

  beforeEach (done) ->
    echonest.Band.find 'massy', (b) ->
      bands = b
      done()

  it 'should return bands', ->
    (bands.length > 0).should.be.true

describe 'Songs', ->
  songs = {}

  beforeEach (done) ->
    echonest.Band.find 'massy ferguson', (bands) ->
      band = bands[0]
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
