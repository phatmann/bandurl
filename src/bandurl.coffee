# 
# bandurl
# https://github.com/phatmann/bandurl
# 
# Copyright (c) 2012 Tony Mann

exports.tracks = (band, callback) ->
  echonest_api_key   = 'HR71PV9JF1LXJUYWX'

  rdio_api_key       = 'tj4xf7d6c9ck3nr97j3edxyn'
  rdio_shared_secret = 'bWUd5TR3YP'

  echonest = require 'echonest'
  async    = require 'async'
  rdio     = require './rdio/rdio.js'

  echonest_api = new echonest.Echonest(api_key: echonest_api_key)
  rdio_api     = new rdio([rdio_api_key, rdio_shared_secret])

  params =
    artist:   band
    bucket:   ['tracks', 'id:rdio-US']
    results:  5
    sort:     'song_hotttnesss-desc'
    limit:    true

  echonest_api.song.search params, (error, response) ->
    #console.log response
    results = {}

    get_url = (song, callback) ->
      track = song.tracks[0]
      [vendor, type, key] = track.foreign_id.split(':')
      rdio_api.call 'get', {keys: key}, (err, response) ->
        results[song.title] = response.result[key].shortUrl unless err
        callback(err)

    async.forEach response.songs, get_url, (err) ->
      callback results
