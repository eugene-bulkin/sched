###
Function that places the color picker at the top left corner of the button to
which it binds
###
colorPickerPlace = () ->
  btnO = $(".cls-form.open").find("button[name='clsColor']").offset()
  cntO = $("#content").offset()
  $('#colors').css({
    top: btnO.top - cntO.top,
    left: btnO.left - cntO.left
  })

angular.module('sched',
  ['ngRoute', 'ngResource', 'ngAnimate', 'sched.directives', 'sched.controllers', 'sched.factories'],
  ($routeProvider) ->
    classResolver = {
      classes: (Schedule, $q, $route) ->
        deferred = $q.defer()
        Schedule.query({ id: $route.current.params.schedId }, (data) ->
          deferred.resolve(data)
        , (reason) ->
          deferred.reject()
        )
        deferred.promise
    }
    $routeProvider.when('/', {
      template: '<sched-display></sched-display><sched-menu></sched-menu><color-picker></color-picker>',
      controller: SchedCtrl,
      resolve: {
        classes: () -> [] # resolve to empty list if there's no id
      }
    })
    $routeProvider.when('/view/:schedId', {
      template: '<sched-display></sched-display><sched-menu></sched-menu><color-picker></color-picker>',
      controller: SchedCtrl,
      resolve: classResolver
    })
    $routeProvider.otherwise({
      redirectTo: '/'
    })
).run(() ->
  $(window).resize(colorPickerPlace)
)