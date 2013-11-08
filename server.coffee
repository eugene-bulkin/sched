express = require('express')
app = express()
mongoose = require('mongoose')

mongoose.connect 'mongodb://sched:sched@localhost:27017/sched'

app.configure () ->
  app.use express.static(__dirname + '/app')
  app.use express.logger('dev')
  app.use express.bodyParser()
  app.use express.methodOverride()

# Routes
app.get '*', (req, res) ->
  res.sendFile './app/index.html'

app.listen 3000
console.log "App listening on 3000"