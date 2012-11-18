async = require 'async' 

class Echonest
  @API_KEY = 'HR71PV9JF1LXJUYWX'

  constructor: ->
    echonest = require 'echonest'
    @api = new echonest.Echonest(api_key: Echonest.API_KEY)
    @services = require './echonest/services'

  findBands: (name, callback) ->
    params =
      name: name
      bucket: ['biographies', 'images']

    @api.artist.search params, (error, response) =>
      callback response.artists

  findSongs: (bandID, callback) ->
    bucket = ("id:#{name}-WW" for name, service of @services when service.tracks)
    bucket.push 'tracks'

    params =
      artist_id:   bandID
      bucket:      bucket
      results:     5
      sort:        'song_hotttnesss-desc'
      limit:       true

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

  findSimilarBands: (bandID, callback) ->
    params =
      id:       bandID
      results:  5

    @api.artist.similar params, (error, response) =>
      callback response.artists

  findTerms: (bandID, callback) ->
    params =
      id:       bandID

    @api.artist.terms params, (error, response) =>
      callback response.terms

class Band
  @find: (name, callback) ->
    @echonest ?= new Echonest
    artists = @echonest.findBands name, (artists) ->
      bands = (new Band(artist) for artist in artists)
      callback bands

  constructor: (artist) ->
    Band.echonest ?= new Echonest
    [@name, @id] = [artist.name, artist.id]
    @images = (image.url for image in artist.images) if artist.images
    @biographies = (biography.text for biography in artist.biographies \
      when not biography.truncated and biography.license.attribution isnt 'n/a') if artist.biographies

  songs: (callback) ->
    Band.echonest.findSongs @id, callback

  similarBands: (callback) ->
    Band.echonest.findSimilarBands @id, (artists) ->
      bands = (new Band(artist) for artist in artists)
      callback bands

  terms: (callback) ->
    Band.echonest.findTerms @id, (terms) ->
      terms = (term.name for term in terms)
      callback terms[0..2].join ', '

class Song
  constructor: (@name, @vendor, @key) ->

exports.Band = Band
