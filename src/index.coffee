express    = require 'express'
stylus     = require 'stylus'
assets     = require 'connect-assets'
async      = require 'async'
echonest   = require './services/echonest'

app = express()
app.use assets()
app.use express.static(process.cwd() + '/public')
app.set 'view engine', 'jade'

nameToURL = (name)->
  '/' + name.replace(/\s/g, '_')

handleToName = (handle)->
  handle.replace(/_/g, ' ')

app.get '/:band?', (req, resp) ->
  view_params = {bands: null, band: null, songs: null, biography: null, images: null, similarBands: null, terms: null}

  if req.params.band
    name = handleToName req.params.band
    echonest.Band.find name, (bands) ->
      if bands.length == 1 or bands[0].name.toUpperCase == name.toUpperCase
        band = bands[0]
        view_params.band      = band
        view_params.biography = band.biographies[0]
        view_params.images    = band.images[0..1]
        async.parallel
          getSongs: (callback) ->
            band.songs (songs) ->
              view_params.songs = songs
              callback()
          getSimilarBands: (callback) ->
            band.similarBands (bands) ->
              band.url = nameToURL(band.name) for band in bands
              view_params.similarBands = bands
              callback()
          getTerms: (callback) ->
            band.terms (terms) ->
              view_params.terms = terms
        resp.render 'index', view_params
      else
        band.url = nameToURL(band.name) for band in bands
        view_params.bands = bands
        resp.render 'index', view_params
  else if req.query.band
    resp.redirect nameToURL(req.query.band)
  else
    resp.render 'index', view_params

port = process.env.PORT or process.env.VMC_APP_PORT or 3000
app.listen port, -> console.log "Listening on #{port}\nPress CTRL-C to stop server."