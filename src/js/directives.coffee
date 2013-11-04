###
A directive for handling the color palette. Handles issue with ng-repeat and
scope handling.
###
repeated = () ->
  {
    restrict: 'A',
    link: (scope, element, attrs) ->
      element.on('click', () ->
        button = $(".cls-form.open").find("button[name='clsColor']")
        color = $(this).val()
        button.val(color).css('background-color', color)
        clsId = $(".cls-form.open").attr('id').match(/^cls-frm-(\d+)$/)[1]
        clsId = parseInt(clsId, 10)
        scope.classes[clsId].color = color
        scope.$apply()
        $("#colors").toggleClass("open")
      )
  }

###
A directive for the button that brings up the color palette from the menu form.
###
colorPickerButton = () ->
  {
    restrict: 'E',
    replace: true,
    template: '<button type="button" name="clsColor"' +
      ' unselectable="on" onselectstart="return false">color</button>',
    link: (scope, element, attrs) ->
      element.val(scope.class.color)
      $(element).css('background-color', scope.class.color)
      $(element).on('click', () ->
        $("#colors").show().toggleClass('open')
      )
  }

###
A directive for a color palette. The palette, on click, changes the color of
the class.
###
colorPicker = () ->
  {
    restrict: 'E',
    replace: true,
    templateUrl: 'partials/colorPicker.html',
    link: (scope, element, attrs) ->
  }

###
A directive for the header section of the page.
###
schedHeader = () ->
  {
    restrict: 'E',
    replace: false,
    controller: SchedHeaderCtrl,
    templateUrl: 'partials/header.html',
    link: (scope, element, attrs) ->
      $("#login").on 'click', () ->
        $(document).on "keyup", scope.closeModal
        scope.showLogin = true
        scope.$apply()

  }

###
A directive for the login modal
###
loginModal = () ->
  {
    restrict: 'E',
    replace: true,
    controller: SchedHeaderCtrl
    templateUrl: 'partials/loginModal.html'
    link: (scope, element, attrs) ->
      $("#close-button").on 'click', () ->
        $scope.showLogin = false
        $scope.$apply()
        $(this).unbind "keyup"
      scope.toggleRegister = () ->
        scope.login = !scope.login
  }

userExists = (User) ->
  {
    require:'ngModel',
    restrict: 'A',
    link: (scope, el, attrs, ctrl) ->
      ctrl.$parsers.push((username) ->
        # TODO: Implement user existence validator
        username
      )
  }

###
A directive for handling the menu forms
###
schedMenuForm = () ->
  {
    restrict: 'E',
    replace: true,
    templateUrl: 'partials/menuForm.html',
    link: (scope, element, attrs) ->
      element.find('button.close').on('click', () ->
        $(this).parent().toggleClass("open selected")
        if $("#colors") then $("#colors").hide()
      )
      scope.$parent.$on('class-click', (e, args...) ->
        scope.selectedTime = args[0]
      )
      scope.selectedTime = if scope.class.times.length > 0 then 0 else -1
      scope.prevActive = () -> scope.selectedTime > 0
      scope.nextActive = () -> scope.selectedTime < scope.class.times.length - 1
      scope.delActive = () -> scope.class.times.length > 0
      scope.delTime = () ->
        $("#smtf-#{scope.$index}-#{scope.selectedTime}").remove()
        scope.class.times.splice(scope.selectedTime, 1)
        if scope.selectedTime > scope.class.times.length - 1 then scope.selectedTime -= 1
      scope.addTime = () ->
        scope.class.times.push {
          days: {1: false, 2: false, 3: false, 4: false, 5: false},
          start: null,
          end: null,
          location: null,
          instructor: null
        }
        scope.selectedTime = scope.class.times.length - 1
  }

###
A directive for the time information area of the class menu form.
###
schedMenuTimeForm = () ->
  {
    restrict: 'EA',
    replace: true,
    templateUrl: 'partials/menuTimeForm.html',
    link: (scope, element, attrs) ->
  }

###
A directive for menu links
###
schedMenuLink = () ->
  {
    restrict: 'E',
    replace: true,
    templateUrl: 'partials/menuLink.html',
    link: (scope, element, attrs) ->
      element.on('click', () ->
        frm = $("#cls-frm-" + this.id.replace("cls-",""))
        frm.toggleClass("open selected")
        # on slide end, move the color picker box to the appropriate area
        tre = 'transitionend webkitTransitionEnd oTransitionEnd otransitionend'
        frm.on(tre, colorPickerPlace)
      )
  }

###
A directive for the class menu
###
schedMenu = () ->
  {
    restrict: 'E',
    replace: true,
    templateUrl: 'partials/menu.html',
    link: (scope, element, attrs) ->
      $("#menuicon").on('click', () ->
        toOpen = "#menu, #menuicon, .cls-form.open, .cls-form.selected"
        $(toOpen).toggleClass("open")
        if $("#colors") then $("#colors").hide()
      )
  }

###
A directive for the schedule display
###
schedDisplay = () ->
  {
    restrict: 'E',
    replace: true,
    templateUrl: 'partials/display.html',
    link: (scope, element, attrs) ->
  }

###
A directive for a timepicker.

@see http://jonthornton.github.io/jquery-timepicker/
###
timePicker = () ->
  {
    restrict: 'A',
    require: 'ngModel',
    link: (scope, element, attrs, ngModel) ->
      $(element).timepicker({
        timeFormat: 'H:i',
        step: 5,
        forceRoundTime: true,
        minTime: scope.$parent.$parent.timeOrigin,
        maxTime: scope.$parent.$parent.timeEnd
      }).on('changeTime', () ->
        newValue = $(this).val()
        if (!scope.$$phase)
          scope.$apply(() -> ngModel.$setViewValue(newValue))
        return
      )

      ngModel.$render = () ->
        $(element).val(ngModel.$viewValue)
        $(element).change()
  }

angular.module('sched.directives', [])
  .directive('repeated', repeated)
  .directive('timePicker', timePicker)
  .directive('colorPickerButton', colorPickerButton)
  .directive('colorPicker', colorPicker)
  .directive('schedHeader', schedHeader)
  .directive('loginModal', loginModal)
  .directive('userExists', ['User', userExists])
  .directive('schedMenuTimeForm', schedMenuTimeForm)
  .directive('schedMenuForm', schedMenuForm)
  .directive('schedMenuLink', schedMenuLink)
  .directive('schedMenu', schedMenu)
  .directive('schedDisplay', schedDisplay)