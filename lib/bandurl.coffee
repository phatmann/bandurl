# 
# bandurl
# https://github.com/phatmann/bandurl
# 
# Copyright (c) 2012 Tony Mann
# Licensed under the MIT license.
# 

exports.tracks = (band, callback) ->
  echonest = require 'echonest'
  echonest_api_key = 'HR71PV9JF1LXJUYWX'
  mynest = new echonest.Echonest(api_key: echonest_api_key)
  mynest.song.search {artist:band, bucket:['tracks', 'id:rdio-US']}, (error, response) ->
    songs = response.songs
    tracks = {}
    tracks[song.title] = song.tracks[0] for song in songs when song.tracks.length > 0
    callback tracks
