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

require('./routes/main')(app)
require('./routes/sched')(app, Schedule)

port = process.env.PORT || 3000
app.listen port, () ->
  console.log "App listening on #{port}"
