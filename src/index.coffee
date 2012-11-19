express    = require 'express'
stylus     = require 'stylus'
assets     = require 'connect-assets'
async      = require 'async'
echonest   = require './services/echonest'

app = express()
app.use assets()
app.use express.static(process.cwd() + '/public')
app.set 'view engine', 'jade'

nameToHandle = (name)->
  name.replace(/\s/g, '_')

handleToName = (handle)->
  handle.replace(/_/g, ' ')

app.get '/', (req, resp) ->
  if req.query.band
    name = handleToName req.query.band
    echonest.Band.find name, (bands) ->
      if bands.length == 1 or bands[0].name.toUpperCase == name.toUpperCase
        resp.redirect '/' + nameToHandle(bands[0].name)
      else
        band.url = nameToHandle(band.name) for band in bands
        resp.render 'index', {bands: bands}
  else
    resp.render 'index', {bands: null}

app.get '/:band', (req, resp) ->
  name = handleToName req.params.band
  echonest.Band.find name, (bands) ->
    if bands.length > 1 and bands[0].name.toUpperCase != name.toUpperCase
      resp.redirect '/?' + nameToHandle(bands[0].name) # TODO: use other view without redirect
    else
      band = bands[0]
      view_params = {}
      view_params.band      = band
      view_params.biography = band.biographies[0]
      view_params.images    = band.images[0..1]
      async.parallel {
        getSongs: (callback) ->
          band.songs (songs) ->
            view_params.songs = songs
            callback()
        getSimilarBands: (callback) ->
          band.similarBands (bands) ->
            band.url = nameToHandle(band.name) for band in bands
            view_params.similarBands = bands
            callback()
        getTerms: (callback) ->
          band.terms (terms) ->
            view_params.terms = terms
            callback()
      }, ->
        resp.render 'band', view_params

port = process.env.PORT or process.env.VMC_APP_PORT or 3000
app.listen port, -> console.log "Listening on #{port}\nPress CTRL-C to stop server."