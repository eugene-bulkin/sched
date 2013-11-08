express = require('express')
app = express()
mongoose = require('mongoose')

mongoose.connect 'mongodb://sched:sched@localhost:27017/sched'

app.configure () ->
  app.use express.static(__dirname + '/app')
  app.use express.logger('dev')
  app.use express.bodyParser()
  app.use express.methodOverride()

# Models
Schedule = mongoose.model 'Schedule', {
  classes: Array
}

# Routes
app.get '/api/sched/:schedId', (req, res) ->
  Schedule.find {
    _id: req.params.schedId
  }, (err, sched) ->
    if err
      res.send err
    res.json sched
app.post '/api/sched', (req, res) ->
  Schedule.create {
    classes: []
  }, (err, sched) ->
    if err
      res.send err
    Schedule.find (err, scheds) ->
      if err
        res.send err
      res.json scheds
app.delete '/api/sched/:schedId', (req, res) ->
  Schedule.remove {
    _id: req.params.schedId
  }, (err, sched) ->
    if err
      res.send err
    Schedule.find (err, scheds) ->
      if err
        res.send err
      res.json scheds

app.get '/', (req, res) ->
  res.sendFile './app/index.html'

app.listen 3000
console.log "App listening on 3000"