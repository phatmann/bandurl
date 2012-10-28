# 
# bandurl
# https://github.com/phatmann/bandurl
# 
# Copyright (c) 2012 Tony Mann

exports.tracks = (band, callback) ->
  echonestApiKey   = 'HR71PV9JF1LXJUYWX'

  rdioApiKey       = 'tj4xf7d6c9ck3nr97j3edxyn'
  rdioSharedSecret = 'bWUd5TR3YP'

  echonest = require 'echonest'
  async    = require 'async'
  rdio     = require './rdio/rdio.js'

  echonestApi = new echonest.Echonest(api_key: echonestApiKey)
  rdioApi     = new rdio([rdioApiKey, rdioSharedSecret])

  params =
    artist:   band
    bucket:   ['tracks', 'id:rdio-US']
    results:  5
    sort:     'song_hotttnesss-desc'
    limit:    true

  echonestApi.song.search params, (error, response) ->
    results = {}

    getUrl = (song, callback) ->
      track = song.tracks[0]
      [vendor, type, key] = track.foreign_id.split(':')
      rdioApi.call 'get', {keys: key}, (err, response) ->
        results[song.title] = response.result[key].shortUrl unless err
        callback(err)

    async.forEach response.songs, getUrl, (err) ->
      callback results
