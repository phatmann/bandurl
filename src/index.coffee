express    = require 'express'
stylus     = require 'stylus'
assets     = require 'connect-assets'
echonest   = require './services/echo_nest'

app = express()
app.use assets()
app.use express.static(process.cwd() + '/public')
app.set 'view engine', 'jade'

app.get '/:band?', (req, resp) ->
  if req.params.band
    name = req.params.band.replace(/_/g, ' ')
    band = echonest.Band.find(name)
    band.songs (songs) ->
      resp.render 'index', {band: band, songs: songs}
  else if req.query.band
    resp.redirect '/' + req.query.band.replace(/\s/g, '_')
  else
    resp.render 'index',{band: null, songs: null}

port = process.env.PORT or process.env.VMC_APP_PORT or 3000
app.listen port, -> console.log "Listening on #{port}\nPress CTRL-C to stop server."