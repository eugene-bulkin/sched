###
Function that places the color picker at the top left corner of the button to
which it binds
###
colorPickerPlace = () ->
  btnO = $(".cls-form.open").find("button[name='clsColor']").offset()
  if btnO
    cntO = $("#content").offset()
    $('#colors').css({
      top: btnO.top - cntO.top,
      left: btnO.left - cntO.left
    })
    true
  false

angular.module('sched',
  ['ngRoute', 'ngResource', 'ngAnimate', 'sched.directives', 'sched.controllers', 'sched.factories'],
  ($routeProvider) ->
    schedResolver = (Schedule, $q, $route) ->
      deferred = $q.defer()
      Schedule.get($route.current.params.schedId).then (data) ->
        deferred.resolve data
      , (reason) ->
        deferred.reject()
      deferred.promise
    loginResolver = (Login, $q, $route) ->
      deferred = $q.defer()
      Login.currentUser().then (data) ->
        deferred.resolve data
      , (reason) ->
        deferred.reject()
      deferred.promise
    $routeProvider.when('/', {
      template: '<sched-schedule-options></sched-schedule-options><sched-display></sched-display><sched-menu></sched-menu><color-picker></color-picker>',
      controller: SchedCtrl,
      resolve: {
        sched: () -> {classes: []}, # resolve to empty list if there's no id
        currentUser: loginResolver
      }
    })
    $routeProvider.when('/view/:schedId', {
      template: '<sched-schedule-options></sched-schedule-options><sched-display></sched-display><sched-menu></sched-menu><color-picker></color-picker>',
      controller: SchedCtrl,
      resolve: {
        sched: schedResolver,
        currentUser: loginResolver
      }
    })
    $routeProvider.otherwise({
      redirectTo: '/'
    })
).run(() ->
  $(window).resize(colorPickerPlace)
)