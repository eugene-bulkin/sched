angular.module('sched.controllers', [])
    .controller('SchedCtrl', function (Schedule, $scope, $route, $routeParams, $http) {
        "use strict";

        // basic info
        $scope.id = ($routeParams.id) ? alphaID($routeParams.id, true, 4) : "new";
        $scope.schedule = ($scope.id == "new") ? {id: false, classes: []} : Schedule.get({id: $scope.id});

        // grid configuration
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

        $scope.classBox = function (classData, time, day) {
            var startMins = getMins(time.start) - getMins($scope.window.start),
                classLength = (time.end !== "" && time.start !== "") ? getMins(time.end) - getMins(time.start) : 0,
                totalMins = getMins($scope.window.end) - getMins($scope.window.start),
                bright = getBright(classData.color),
                containerHeight = $("#scheduleContainer").height(),
                boxHeight = containerHeight * classLength / totalMins;
            if (boxHeight === 0) {
                return {
                    display: "none"
                };
            }
            return {
                position: 'absolute',
                top: (startMins / totalMins * containerHeight) + 'px',
                left: ($scope.class_width + 1) * (day - 1) + 'px',
                width: ($scope.class_width) + 'px',
                height: boxHeight + 'px',
                backgroundColor: classData.color,
                color: (bright > 165) ? '#000000' : '#ffffff',
                fontSize: (boxHeight / 3) + 'px'
            };
        };
        // form configuration
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

        $scope.selectedClass = -1;

        $scope.selectClass = function (i) {
            $scope.selectedClass = i;
        };

        $scope.closeClass = function () {
            $scope.selectedClass = -1;
        };

        $scope.dayButton = function (classData, time, day) {
            var bright = getBright(classData.color),
                result = {
                    color: (bright > 165) ? '#000000' : '#ffffff'
                };
            if (time.days[day]) {
                result.backgroundColor = classData.color;
            } else {
                result.backgroundColor = hex2rgba(classData.color, 0.5);
            }
            return result;
        };

        $scope.addTime = function (i) {
            $scope.schedule.classes[i].times.push({
                days: {1: false, 2: false, 3: false, 4: false, 5: false},
                start: "",
                end: "",
                location: "",
                instructor: ""
            });
        };

        $scope.removeTime = function (ci, i) {
            $scope.schedule.classes[ci].times.splice(i, 1);
        };

        $scope.addClass = function () {
            $scope.schedule.classes.push({
                name: "?",
                section: null,
                times: [],
                color: "#" + paletteColors.choice()
            });

        };

        $scope.removeClass = function (i) {
            $scope.schedule.classes.splice(i, 1);
        };
    }, ['Schedule', '$scope', '$route', '$routeParams', '$http']);