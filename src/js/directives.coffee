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

colorPicker = () ->
  {
    restrict: 'E',
    replace: true,
    templateUrl: 'partials/colorPicker.html',
    link: (scope, element, attrs) ->
  }

schedHeader = () ->
  {
    restrict: 'E',
    replace: false,
    templateUrl: 'partials/header.html',
    link: (scope, element, attrs) ->
  }

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
  }

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
        frm.on(tre, () ->
          offset = $(".cls-form.open").find("button[name='clsColor']").offset()
          if $("#colors") and offset then $('#colors').css(offset)
        )
      )
  }

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

schedDisplay = () ->
  {
    restrict: 'E',
    replace: true,
    templateUrl: 'partials/display.html',
    link: (scope, element, attrs) ->
  }

angular.module('sched.directives', [])
  .directive('repeated', repeated)
  .directive('colorPickerButton', colorPickerButton)
  .directive('colorPicker', colorPicker)
  .directive('schedHeader', schedHeader)
  .directive('schedMenuForm', schedMenuForm)
  .directive('schedMenuLink', schedMenuLink)
  .directive('schedMenu', schedMenu)
  .directive('schedDisplay', schedDisplay)