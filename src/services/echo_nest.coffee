# 
# bandurl
# https://github.com/phatmann/bandurl
# 
# Copyright (c) 2012 Tony Mann

async = require('async')

class Echonest
  @API_KEY = 'HR71PV9JF1LXJUYWX'

  constructor: ->
    echonest = require 'echonest'
    @api = new echonest.Echonest(api_key: Echonest.API_KEY)

  find_band: (name, callback) ->
    # TODO: resolve ambiguities via API
    new Band name

  find_songs: (band_name, callback) ->
    rdio = require ('./rdio')
    @rdio ?= new rdio.Rdio

    params =
      artist:   band_name
      bucket:   ['tracks', 'id:rdio-US'] # TODO: expand to all services
      results:  5
      sort:     'song_hotttnesss-desc'
      limit:    true

    @api.song.search params, (error, response) =>
      songs = for song in response.songs
        [vendor, type, key] = song.tracks[0].foreign_id.split(':')
        new Song song.title, vendor, type, key

      getUrl = (song, callback) =>
        @rdio.getUrl song, (err) ->
          callback err
      
      async.forEach songs, getUrl, (err) ->
        callback songs

class Band
  @find: (name, callback) ->
    @echonest ?= new Echonest
    callback @echonest.find_band(name)

  constructor: (@name) ->
    @echonest ?= new Echonest

  songs: (callback) ->
    @echonest.find_songs(@name, callback)

class Song
  constructor: (@name, @vendor, @type, @key) ->

exports.Band = Band
