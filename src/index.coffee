express    = require 'express'
stylus     = require 'stylus'
assets     = require 'connect-assets'
echonest   = require './services/echonest'

app = express()
app.use assets()
app.use express.static(process.cwd() + '/public')
app.set 'view engine', 'jade'

name_to_url = (name)->
  '/' + name.replace(/\s/g, '_')

handle_to_name = (handle)->
  handle.replace(/_/g, ' ')

app.get '/:band?', (req, resp) ->
  view_params = {bands: null, band: null, songs: null}

  if req.params.band
    name = handle_to_name req.params.band
    echonest.Band.find name, (bands) ->
      if bands.length == 1 or bands[0].name.toUpperCase == name.toUpperCase
        bands[0].songs (songs) ->
          view_params.band  = bands[0]
          view_params.songs = songs
          resp.render 'index', view_params
      else
        band.url = name_to_url(band.name) for band in bands
        view_params.bands = bands
        resp.render 'index', view_params
  else if req.query.band
    resp.redirect name_to_url(req.query.band)
  else
    resp.render 'index', view_params

port = process.env.PORT or process.env.VMC_APP_PORT or 3000
app.listen port, -> console.log "Listening on #{port}\nPress CTRL-C to stop server."