angular.module('sched.factories', [])
  .factory('Schedule', ($resource) ->
    $resource('schedule.php?id=:id', {
      id: '@id'
    })
  )