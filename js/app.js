var schedModule = angular.module('sched', ['ngRoute', 'ngResource', 'sched.directives', 'sched.controllers'], function ($routeProvider) {
    "use strict";
    $routeProvider.when('/', {
        templateUrl: 'partials/schedule.html',
        controller: 'SchedCtrl'
    })
        .when('/view/:id', {
            templateUrl: 'partials/schedule.html',
            controller: 'SchedCtrl'
        })
        .otherwise({ redirectTo: '/'});
});

schedModule.factory('Schedule', function ($resource) {
    "use strict";
    return $resource('schedule.php?id=:id', {id: '@id'});
});