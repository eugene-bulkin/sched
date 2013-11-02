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
  ['ngRoute', 'sched.directives', 'sched.controllers', 'sched.factories'],
  ($routeProvider) ->
    $routeProvider.when('/', {
      template: '<sched-display></sched-display><sched-menu></sched-menu><color-picker></color-picker>',
      controller: SchedCtrl
    })
    $routeProvider.when('/view/:schedId', {
      template: '<sched-display></sched-display><sched-menu></sched-menu><color-picker></color-picker>',
      controller: SchedCtrl
    })
    $routeProvider.otherwise({
      redirectTo: '/'
    })
).run(() ->
  $(window).resize(colorPickerPlace)
)