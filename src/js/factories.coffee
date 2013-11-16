Schedule = ($http) ->
  {
    get: (id) ->
      $http({ method: 'GET', url: '/api/sched/' + id }).then (data) ->
        data.data[0]
    update: (sched) ->
      id = sched._id || ''
      $http({ method: 'PUT', url: '/api/sched/' + id, data: sched }).then (data) ->
        data.data
    remove: (id) ->
      $http({ method: 'DELETE', url: '/api/sched/' + id }).then (data) ->
        data.data
  }

Login = ($http) ->
  {
    login: (data) ->
      $http({ method: 'POST', url: '/api/login/login', data: data }).then (data) ->
        data.data
    register: (data) ->
      $http({ method: 'POST', url: '/api/login/register', data: data }).then (data) ->
        data.data
    currentUser: () ->
      $http({ method: 'GET', url: '/api/login' }).then (data) ->
        data.data
    logout: () ->
      $http({ method: 'GET', url: '/api/login/logout' }).then (data) ->
        data.data
  }

angular.module('sched.factories', [])
  .factory('Schedule', Schedule)
  .factory('Login', Login)