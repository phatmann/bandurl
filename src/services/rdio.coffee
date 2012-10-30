# 
# bandurl
# https://github.com/phatmann/bandurl
# 
# Copyright (c) 2012 Tony Mann

class Rdio
  @RDIO_API_KEY       = 'tj4xf7d6c9ck3nr97j3edxyn'
  @RDIO_SHARED_SECRET = 'bWUd5TR3YP'

  constructor: ->
    rdio = require '../rdio/rdio.js'
    @rdio = new rdio([Rdio.RDIO_API_KEY, Rdio.RDIO_SHARED_SECRET])

  getUrl: (song, callback) => 
    @rdio.call 'get', {keys: song.key}, (err, response) ->
      song.url = response.result[song.key].shortUrl unless err
      callback(err)

exports.Rdio = Rdio
