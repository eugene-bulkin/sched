module.exports = (app, Schedule) ->
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