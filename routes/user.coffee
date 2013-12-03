bcrypt = require('bcrypt-nodejs')

module.exports = (app, User, Schedule) ->
  app.get '/api/user/:userId', (req, res) ->
    User.findOne({ _id: req.params.userId })
      .exec (err, user) ->
        if err
          res.status 400
          res.send err
        res.json { username: user._id }
  app.get '/api/user/:userId/schedules', (req, res) ->
    Schedule.find({ user: req.params.userId })
      .exec (err, schedules) ->
        if err
          res.status 400
          res.send err
        res.json schedules