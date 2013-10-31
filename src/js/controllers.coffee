chunk = (arr, chunkSize) ->
  R = []
  for i in [0...arr.length] by chunkSize
    R.push(arr.slice(i,i+chunkSize))
  R

angular.module('sched.controllers', [])
  .controller('SchedCtrl', ($scope, $route, $routeParams, $http) ->
    $scope.classes = [
      {
         name: "Ma 5a",
         section: 1,
         color: "#f84",
         times: [{
              days: {1: true, 2: false, 3: true, 4: false, 5: true},
              start: "09:00",
              end: "09:55",
              location: "151 SLN",
              instructor: null
          }]
      },
      {
         name: "Ma 108a",
         section: 1,
         color: "#48f",
         times: [{
              days: {1: true, 2: false, 3: true, 4: false, 5: true},
              start: "11:00",
              end: "11:55",
              location: "151 SLN",
              instructor: null
          }]
      },
      {
         name: "Ma 6a",
         section: 1,
         color: "#4f8",
         times: [{
              days: {1: true, 2: false, 3: true, 4: false, 5: true},
              start: "13:00",
              end: "13:55",
              location: "151 SLN",
              instructor: null
          }]
      },
      {
         name: "Ph 2a",
         section: 1,
         color: "#4f8",
         times: [{
              days: {1: false, 2: true, 3: false, 4: true, 5: false},
              start: "11:30",
              end: "12:55",
              location: "151 SLN",
              instructor: null
          }]
      }
    ]

    $scope.colorPalette = chunk([
      "#d44", "#f84", "#fe8",
      "#8d8", "#48d", "#a6f",
      "#642", "#aaa", "#888"], 3)
    return
  , ['$scope', '$route', '$routeParams', '$http'])
  .controller('SchedMenuCtrl', ($scope) ->
    $scope.addClass = () ->
      obj = {
         name: "",
         section: null,
         color: "#888",
         times: []
      }
      $scope.classes.push(obj)
      return
    return
  , ['$scope'])
  .controller('SchedClassCtrl', ($scope) ->
    $scope.clickClass = (cls) ->
      if !$('#menu').hasClass('open')
        $('#menu').addClass('open')
        $('#menuicon').addClass('open')
      $('.cls-form').removeClass('open selected')
      $('#cls-frm-' + cls.id).addClass('open selected')
      return

    $scope.getStyle = (cls) ->
      hours = $scope.totalTime
      timeDiff = $scope.timeDiff(cls.start, cls.end)
      timeOffset = $scope.timeDiff($scope.timeOrigin, cls.start)
      topOffset = if cls.day is 1 then 1 else 2
      pad = 2 # padding of clsBox, see display.scss, $clsBox-pad
      {
        width: "#{2 * $scope.blockWidth * timeDiff / 60}px",
        left: "#{2 * ($scope.blockWidth - 1) * timeOffset / 60 - 1}px",
        top: "#{(cls.day - 1) * 100 + pad}px",
        backgroundColor: cls.color
      }
    return
  , ['$scope'])
  .controller('SchedDisplayCtrl', ($scope) ->
    $scope.timeDiff = (start, end) ->
      toMins = (p, n, i) -> p + Math.pow(60, 1 - i) * n
      end.split(":").reduce(toMins, 0) - start.split(":").reduce(toMins, 0)

    $scope.timeOrigin = "07:30" # time origin is 7:30 AM
    $scope.timeEnd = "23:30" # time end is 11:30 PM
    $scope.totalTime = $scope.timeDiff($scope.timeOrigin, $scope.timeEnd) / 60
    $scope.blockWidth = 60

    $scope.range = (from, to) ->
      if(!to)
        to = from
        from = 1
      [from..to]

    getClasses = () ->
      result = []
      for cls, clsId in $scope.classes
        for time in cls.times
          for day in [1..5]
            if(!time.days[day]) then continue
            clsInfo = {
              name: cls.name,
              section: cls.section,
              start: time.start,
              end: time.end,
              location: time.location,
              instructor: time.instructor,
              day: day,
              color: cls.color,
              id: clsId
            }
            result.push(clsInfo)
      result

    $scope.classList = getClasses()

    $scope.$watch('classes', () ->
      $scope.classList = getClasses()
    , true)
    return
  , ['$scope'])