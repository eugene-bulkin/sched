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
  name: String,
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
app.put '/api/sched', (req, res) ->
  obj = {
    name: req.body.name,
    classes: req.body.classes
  }
  Schedule.create obj, (err, sched) ->
    if err
      res.send err
    res.json sched
app.put '/api/sched/:schedId', (req, res) ->
  obj = {
    name: req.body.name,
    classes: req.body.classes
  }
  Schedule.update {
    _id: req.params.schedId
  }, obj, (err, num) ->
    if err
      res.send err
    res.json req.body
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

port = process.env.PORT || 3000
app.listen port, () ->
  console.log "App listening on #{port}"
