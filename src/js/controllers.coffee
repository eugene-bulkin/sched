###
Auxiliary function to chunk an array into certain-sized pieces. This is used for
the color selector palette.

@example
  chunk([1,2,3,4,5,6,7], 2) = [[1,2],[3,4],[5,6],[7]]

@param [Array] arr
@param [Integer] chunkSize how large each chunk is
@return [Array]
###
chunk = (arr, chunkSize) ->
  R = []
  for i in [0...arr.length] by chunkSize
    R.push(arr.slice(i,i+chunkSize))
  R

###
The schedule app controller. Keeps track of classes.

@param [Object] $scope
@param [Array] classes The classes loaded by the Schedule factory
###
SchedCtrl = ($scope, $rootScope, sched, currentUser) ->
  $scope.sched = sched
  $scope.classes = sched.classes
  $scope.modified = false
  $scope.$emit('user-loaded', currentUser)

  $scope.$watch("classes", (newVal, oldVal) ->
    if newVal is oldVal then return
    $scope.sched.classes = $scope.classes
    $scope.modified = true
  , true)

  $scope.colorPalette = chunk([
    "#d44", "#f84", "#fe8",
    "#8d8", "#48d", "#a6f",
    "#642", "#aaa", "#888"], 3)
  return
###
The schedule menu controller.

@param [Object] $scope
###
SchedMenuCtrl = ($scope) ->
  $scope.days = ' MTWRF'.split('')

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

###
The schedule class controller.

@param [Object] $scope
###
SchedClassCtrl = ($scope) ->
  $scope.hasTimes = (cls) ->
    $scope.timeDiff(cls.start, cls.end) > 0
  $scope.clickClass = (cls) ->
    $scope.$emit('class-click', cls.tId)
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

###
The schedule display controller.

@param [Object] $scope
###
SchedDisplayCtrl = ($scope) ->
  $scope.timeDiff = (start, end) ->
    if !start or !end then return 0
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
      for time, timeIndex in cls.times
        for day in "12345".split("")
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
            id: clsId,
            tId: timeIndex
          }
          result.push(clsInfo)
    result

  $scope.classList = getClasses()

  $scope.$watch('classes', () ->
    $scope.classList = getClasses()
  , true)
  return

###
The controller for the header element

@param {Object} $scope
@param {Object} User
###
SchedHeaderCtrl = ($scope, Login) ->
  $scope.showLogin = false
  $scope.login = true
  $scope.errorMsg = null
  $scope.loginForm = null
  $scope.currentUser = null
  $scope.$on 'user-loaded', (e, user) ->
    # for some rason, angular returns "null" if null is sent...
    $scope.currentUser = if user is "null" then null else user
  $scope.removeModal = () ->
    $scope.showLogin = false
    $('table#body').removeClass('blur')
    $(this).unbind "keyup"
  $scope.closeModal = (e) ->
    if e.keyCode is 27 #close on Esc key
      $scope.removeModal()
      $scope.$apply()
  $scope.processLogin = () ->
    form = @loginForm
    scope = this
    Login.login({
      username: @username,
      password: @password
    }).then (response) ->
        # if success, close the modal
        $scope.removeModal()
        # TODO: reset form
        scope.username = ''
        scope.password = ''
        form.$setPristine()
        # TODO: update header to reflect login
        $scope.currentUser = {
          username: response.username
        }
    , (error) ->
      $scope.errorMsg = error.data
  $scope.processRegister = () ->
    form = @registerForm
    scope = this
    Login.register({
      username: @username,
      password: @password
    }).then (response) ->
        # if success, close the modal
        $scope.removeModal()
        # TODO: reset form
        scope.username = ''
        scope.password = ''
        form.$setPristine()
        # TODO: update header to reflect login
        $scope.currentUser = {
          username: response.username
        }
    , (error) ->
      if error.data.code is 11000
        # this is a duplicate user
        $scope.errorMsg = "The username '#{scope.username}' is already taken. Please choose another one."
      else
        $scope.errorMsg = error.data

angular.module('sched.controllers', [])
  .controller('SchedCtrl', SchedCtrl, ['$scope'])
  .controller('SchedMenuCtrl', SchedMenuCtrl, ['$scope'])
  .controller('SchedClassCtrl', SchedClassCtrl, ['$scope'])
  .controller('SchedDisplayCtrl', SchedDisplayCtrl, ['$scope'])
  .controller('SchedHeaderCtrl', SchedHeaderCtrl, ['$scope', 'Login'])