express = require('express')
app = express()
mongoose = require('mongoose')
bcrypt = require('bcrypt-nodejs')
Schema = mongoose.Schema

mongoose.connect 'mongodb://sched:sched@localhost:27017/sched'

app.configure () ->
  app.use express.static(__dirname + '/app')
  app.use express.logger('dev')
  app.use express.bodyParser()
  app.use express.cookieParser()
  app.use express.session { secret: bcrypt.genSaltSync(10) }
  app.use express.methodOverride()


scheduleSchema = Schema {
  name: String,
  classes: Array,
  user: { type: Schema.Types.ObjectId, ref: 'User' }
}

userSchema = Schema {
  username: { type: String, index: {unique: true, dropDups: true} },
  hash: String
}
# Models
Schedule = mongoose.model 'Schedule', scheduleSchema
User = mongoose.model 'User', userSchema

require('./routes/main')(app)
require('./routes/sched')(app, Schedule)
require('./routes/user')(app, User)
require('./routes/login')(app, User)

port = process.env.PORT || 3000
app.listen port, () ->
  console.log "App listening on #{port}"
