angular.module('sched',
  ['ngRoute', 'sched.directives', 'sched.controllers', 'sched.factories'],
  ($routeProvider) ->
    $routeProvider.when('/', {
      template: '<sched-display></sched-display><sched-menu></sched-menu>',
      controller: SchedCtrl
    })
    $routeProvider.when('/view/:schedId', {
      template: '<sched-display></sched-display><sched-menu></sched-menu>',
      controller: SchedCtrl
    })
    $routeProvider.otherwise({
      redirectTo: '/'
    })
).run(() ->
  $(window).resize(() ->
    offset = $(".cls-form.open").find("button[name='clsColor']").offset()
    $('#colors').css(offset)
  )
)