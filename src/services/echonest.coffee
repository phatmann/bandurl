async = require('async')

class Echonest
  @API_KEY = 'HR71PV9JF1LXJUYWX'

  constructor: ->
    echonest = require 'echonest'
    @api = new echonest.Echonest(api_key: Echonest.API_KEY)
    @services = require './echonest/services'

  find_band: (name, callback) ->
    # TODO: resolve ambiguities via API
    new Band name

  find_songs: (band_name, callback) ->
    bucket = ("id:#{name}-WW" for name, service of @services when service.tracks)
    bucket.push 'tracks'

    params =
      artist:   band_name
      bucket:   bucket
      results:  5
      sort:     'song_hotttnesss-desc'
      limit:    true

    @api.song.search params, (error, response) =>
      songs = for song in response.songs
        [catalog, type, key]  = song.tracks[0].foreign_id.split(':')
        [vendor, locale]      = catalog.split('-')
        new Song song.title, vendor, key

      getUrl = (song, callback) =>
        service = this[song.vendor] ?= require ('./' + vendor)
        service.getUrl song, (err) ->
          callback err
      
      async.forEach songs, getUrl, (err) ->
        callback songs

class Band
  @find: (name, callback) ->
    @echonest ?= new Echonest
    callback @echonest.find_band(name)

  constructor: (@name) ->
    Band.echonest ?= new Echonest

  songs: (callback) ->
    Band.echonest.find_songs(@name, callback)

class Song
  constructor: (@name, @vendor, @key) ->

exports.Band = Band
