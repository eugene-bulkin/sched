bcrypt = require('bcrypt-nodejs')

module.exports = (app, User) ->
  app.get '/api/login', (req, res) ->
    if req.session.loggedIn
      res.json req.session.curUser
    else
      res.json null
  app.get '/api/login/logout', (req, res) ->
    if !req.session.loggedIn
      res.send "not_logged_in"
      return
    req.session.loggedIn = false
    req.session.curUser = null
    res.send "success"
  app.post '/api/login/login', (req, res) ->
    if req.session.loggedIn
      res.json req.session.curUser
      return
    User.findOne {
      username: req.body.username
    }, (err, user) ->
      if user is null
        res.status 400
        res.send "no_user"
        return
      if err
        res.status 400
        res.send err
        return
      if !bcrypt.compareSync(req.body.password, user.hash)
        res.status 400
        res.send "incorrect_password"
        return
      req.session.loggedIn = true
      req.session.curUser = { _id: user._id, username: user.username }
      res.json req.session.curUser
  app.post '/api/login/register', (req, res) ->
    obj = {
      username: req.body.username,
      hash: bcrypt.hashSync(req.body.password, bcrypt.genSaltSync(10))
    }
    User.create obj, (err, user) ->
      if err
        res.status 400
        res.send err
        return
      req.session.loggedIn = true
      req.session.curUser = { _id: user._id, username: user.username }
      res.json req.session.curUser