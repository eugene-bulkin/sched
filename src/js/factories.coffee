Schedule = ($resource) ->
  $resource('/api/sched/:id', {}, {
    query: {method: 'GET', params: { id: '@id' }, isArray: true},
    post: {method: 'POST'},
    update: {method: 'PUT', params: { id: '@id' }},
    remove: {method: 'DELETE', params: { id: '@id' }}
  })

User = ($resource) ->
  $resource('/api/user/:id', {}, {
  })

Login = ($resource) ->
  $resource('/api/login/:mode', {}, {
    login: {
      method: 'POST',
      params: {mode: 'login' },
      interceptor: {
        response: (resp) ->
          resp
        responseError: (resp) ->
          resp
      }
    }
  })

###
User factory
@param {Object} $resource
@param {Object} $q
###
###User = ($resource, $q) ->
  $resource('user.php', {}, {
    login: {
      method: 'POST',
      params: {mode: 'login'},
      responseType: "json",
      interceptor: {
        response: (resp) ->
          resp
      }
    },
    register: {
      method: 'POST',
      params: {mode: 'register'},
      responseType: "json",
      interceptor: {
        response: (resp) ->
          resp
      }
    },
    exists: {
      method: 'POST',
      responseType: "json",
      isArray: true,
      transformReponse: (data) ->
        console.log data
        data
      params: {mode: 'exists'}
    }
  })###

angular.module('sched.factories', [])
  .factory('Schedule', Schedule)
  .factory('Login', Login)
  .factory('User', User)