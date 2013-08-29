function getBright(hex) {
    "use strict";
    hex = hex.replace(/[^a-fA-F0-9]/g, '');
    var r = parseInt(hex.substr(0, 2), 16),
        g = parseInt(hex.substr(2, 2), 16),
        b = parseInt(hex.substr(4, 2), 16);
    // formula from http://alienryderflex.com/hsp.html
    return Math.sqrt(0.299 * r * r + 0.587 * g * g + 0.114 * b * b);
}

function hex2rgba(hex, opacity) {
    "use strict";
    opacity = opacity || 1;
    hex = hex.replace(/[^a-fA-F0-9]/g, '');
    var r = parseInt(hex.substr(0, 2), 16),
        g = parseInt(hex.substr(2, 2), 16),
        b = parseInt(hex.substr(4, 2), 16);
    return "rgba(" + r + ", " + g + ", " + b + ", " + opacity + ")";
}

function getMins(time) {
    "use strict";
    var ts = time.split(":");
    return 60 * (parseInt(ts[0], 10) || 0) + (parseInt(ts[1], 10) || 0);
}

function toMins(time) {
    "use strict";
    return (Math.floor(time / 60)).pad(2) + ":" + (time % 60).pad(2);
}

var schedModule = angular.module('sched', []);

var paletteColors = ["D94040", "FFA64D", "F2F249", "52CC52", "40A6D9", "4D4DBF", "BF4D99",
    "666666", "999999", "CCCCCC"];

// return random item from array
Array.prototype.choice = function () {
    "use strict";
    return this[Math.floor(Math.random() * this.length)];
};

// string padding for a Number
Number.prototype.pad = function (width, z) {
    "use strict";
    z = z || '0';
    var n = this + '';
    return n.length >= width ? n : new Array(width - n.length + 1).join(z) + n;
};

schedModule.directive('colorPicker', function () {
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
});

schedModule.directive('timePicker', function () {
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

function SchedController($scope) {
    "use strict";

    $scope.days = [1, 2, 3, 4, 5];
    $scope.window = {start: "08:00", end: "23:00"};

    // resizing stuff
    var schedContainer = $("#scheduleContainer");
    $scope.grid_width = schedContainer.width();
    $scope.grid_height = schedContainer.height();

    $scope.class_width = $scope.grid_width / $scope.days.length - 1;

    $scope.gridWidth = function () {
        return $("#scheduleContainer").width();
    };
    $scope.$watch($scope.gridWidth, function (newValue) {
        $scope.grid_width = newValue;

        $scope.class_width = $scope.grid_width / $scope.days.length - 1;
    });

    $scope.gridHeight = function () {
        return $("#scheduleContainer").height();
    };
    $scope.$watch($scope.gridHeight, function (newValue) {
        $scope.grid_height = newValue;
    });

    window.onload = function () {
        $scope.$apply();
    };

    window.onresize = function () {
        $scope.$apply();
    };

    $scope.timeAlign = function (t) {
        var start = getMins($scope.window.start),
            end = getMins($scope.window.end),
            numTicks = Math.floor((end - start) / 30),
            tickSpacing = $scope.grid_height / numTicks;
        return {
            top: ((getMins(t) - start) / 30 * tickSpacing - 4) + 'px'
        };
    };

    $scope.timeTicks = function () {
        var t, result = [];
        for (t = getMins($scope.window.start); t <= getMins($scope.window.end); t += 30) {
            result.push(toMins(t));
        }
        return result;
    };


    $scope.classes = [];

    $scope.getDay = function (d) {
        var days = {
            1: "Monday",
            2: "Tuesday",
            3: "Wednesday",
            4: "Thursday",
            5: "Friday"
        };

        return days[d];
    };

    $scope.selectClass = function (i) {
        $scope.$broadcast('classClick', i);
    };
}

function ClassController($scope) {
    "use strict";

    $scope.get_height = function (i) {
        var c = $scope.class,
            start = c.times[i].start,
            end = c.times[i].end,
            mins = getMins(end) - getMins(start),
            totalMins = getMins($scope.window.end) - getMins($scope.window.start);

        return $("#scheduleContainer").height() * mins / totalMins;
    };

    $scope.classStyle = function (ti, day, start) {
        var startMins = getMins(start) - getMins($scope.window.start),
            totalMins = getMins($scope.window.end) - getMins($scope.window.start),
            bright = getBright($scope.class.color);
        return {
            position: 'absolute',
            top: (startMins / totalMins * $("#scheduleContainer").height()) + 'px',
            left: ($scope.class_width + 1) * (day - 1) + 'px',
            width: ($scope.class_width) + 'px',
            height: ($scope.get_height(ti)) + 'px',
            backgroundColor: $scope.class.color,
            color: (bright > 165) ? '#000000' : '#ffffff',
            fontSize: ($scope.get_height(ti) / 3) + 'px'
        };
    };
}

function ClassFormController($scope) {
    "use strict";

    $scope.selectedClass = -1;

    $scope.selectClass = function (i) {
        $scope.selectedClass = i;
    };

    $scope.closeClass = function () {
        $scope.selectedClass = -1;
    };

    $scope.addClass = function () {
        $scope.$parent.classes.push({
            name: "?",
            section: null,
            times: [],
            color: "#" + paletteColors.choice()
        });

    };

    $scope.removeClass = function (i) {
        $scope.$parent.classes.splice(i, 1);
    };

    $scope.addTime = function (i) {
        $scope.$parent.classes[i].times.push({
            days: {1: false, 2: false, 3: false, 4: false, 5: false},
            start: "",
            end: "",
            location: "",
            instructor: ""
        });
    };

    $scope.removeTime = function (ci, i) {
        $scope.$parent.classes[ci].times.splice(i, 1);
    };

    $scope.nameStyle = function (color, addBG) {
        var bright = getBright(color),
            result = {
                color: (bright > 165) ? '#000000' : '#ffffff'
            };
        if (addBG === undefined) {
            addBG = true;
        }
        if (addBG) {
            result.backgroundColor = color;
        }

        return result;
    };

    $scope.dayButton = function (color, ci, ti, di) {
        var bright = getBright(color),
            result = {
                color: (bright > 165) ? '#000000' : '#ffffff'
            };

        if($scope.$parent.classes[ci].times[ti].days[di]) {
            result.backgroundColor = color;
        } else {
            result.backgroundColor = hex2rgba(color, 0.5);
        }

        return result;
    }

    $scope.$on('classClick', function (event, args) {
        $scope.selectClass(args);
    });
}

schedModule.controller('SchedController', SchedController);
schedModule.controller('ClassFormController', ClassFormController);
schedModule.controller('ClassController', ClassController);