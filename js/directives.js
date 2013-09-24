angular.module('sched.directives', [])
    .directive('colorPicker', function () {
        "use strict";
        return {
            require: 'ngModel',
            link: function (scope, element, attrs, ngModel) {
                $(element).colorPicker({
                    // update the scope whenever we pick a new color
                    onColorChange: function (id, newValue) {
                        scope.$apply(function () {
                            ngModel.$setViewValue(newValue);
                        });
                    },
                    colors: paletteColors,
                    pickerDefault: scope.class.color.replace("#", "")
                });

                ngModel.$render = function () {
                    $(element).val(ngModel.$viewValue);
                    $(element).change();
                };
            }
        };
    })
    .directive('timePicker', function () {
        "use strict";
        return {
            require: 'ngModel',
            link: function (scope, element, attrs, ngModel) {
                $(element).timepicker({
                    timeFormat: 'H:i',
                    step: 5,
                    forceRoundTime: true,
                    minTime: scope.window.start,
                    maxTime: scope.window.end
                }).on('changeTime', function () {
                        var newValue = $(this).val();
                        if (!scope.$$phase) {
                            scope.$apply(function () {
                                ngModel.$setViewValue(newValue);
                            });
                        }
                    });

                ngModel.$render = function () {
                    $(element).val(ngModel.$viewValue);
                    $(element).change();
                };
            }
        };
    });