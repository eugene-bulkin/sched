module.exports = (app, Schedule) ->
  app.get '/api/sched/:schedId', (req, res) ->
    Schedule.find({ _id: req.params.schedId })
      .limit(1)
      .exec (err, sched) ->
        if err
          res.status 400
          res.send err
        res.json sched
  app.put '/api/sched', (req, res) ->
    obj = {
      name: req.body.name,
      classes: req.body.classes,
      user: req.session.curUser?._id || null
    }
    Schedule.create obj, (err, sched) ->
      if err
        res.send err
      res.json sched
  app.put '/api/sched/:schedId', (req, res) ->
    if not req.body.user
      res.status 400
      res.send "anon"
      return
    if req.body.user isnt req.session.curUser?._id
      res.status 400
      res.send "no_perm"
      return
    obj = {
      name: req.body.name,
      classes: req.body.classes,
      user: req.body.user
    }
    Schedule.update {
      _id: req.params.schedId
    }, { $set: obj }, (err, num) ->
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