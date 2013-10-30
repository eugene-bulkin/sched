angular.module('sched',
  ['ngRoute', 'sched.directives', 'sched.controllers', 'sched.factories'],
  ($routeProvider) ->
    $routeProvider.otherwise({
      redirectTo: '/'
    })
).run(() ->
  $(window).resize(() ->
    offset = $(".cls-form.open").find("button[name='clsColor']").offset()
    $('#colors').css(offset)
  )
)