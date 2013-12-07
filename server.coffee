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
  name: { type: String, index: true },
  lastModified: { type: Date, default: Date.now },
  classes: [
    {
      name: String,
      section: String,
      color: String,
      enabled: Boolean,
      times: [
        {
          days: {
            1: Boolean,
            2: Boolean,
            3: Boolean,
            4: Boolean,
            5: Boolean
          },
          start: String,
          end: String,
          location: String,
          instructor: String
        }
      ]
    }
  ],
  user: { type: String, ref: 'User' }
}

# username must unique anyway, so use it as _id
userSchema = Schema {
  _id: String,
  hash: String
}
# Models
Schedule = mongoose.model 'Schedule', scheduleSchema
User = mongoose.model 'User', userSchema

require('./routes/main')(app)
require('./routes/sched')(app, Schedule)
require('./routes/user')(app, User, Schedule)
require('./routes/login')(app, User)

port = process.env.PORT || 3000
app.listen port, () ->
  console.log "App listening on #{port}"
