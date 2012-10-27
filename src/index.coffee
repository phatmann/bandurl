express = require 'express'
stylus = require 'stylus'
assets = require 'connect-assets'
bandurl = require './bandurl.js'

app = express()
app.use assets()
app.use express.static(process.cwd() + '/public')
app.set 'view engine', 'jade'

app.get '/', (req, resp) -> 
  bandurl.tracks 'massy ferguson', (songs) ->
    resp.render 'index', {songs: songs}
  

port = process.env.PORT or process.env.VMC_APP_PORT or 3000
app.listen port, -> console.log "Listening on #{port}\nPress CTRL-C to stop server."