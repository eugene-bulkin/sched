String.prototype.reverse = function(){
    return this.split('').reverse().join('');
};

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

function alphaID(input, toNum, padUp) {
    toNum = toNum || false;
    padUp = padUp || 0;
    var index = "bcdfghjklmnpqrstvwxyzBCDFGHJKLMNPQRSTVWXYZ",
        base = parseFloat(index.length),
        output;

    if (toNum) {
        // Digital number  <<--  alphabet letter code
        input = input.reverse();
        output = 0;
        len = input.length - 1;
        for(var t = 0; t <= len; t++) {
            var bcp = Math.floor(Math.pow(base, len - t));
            output = output + index.indexOf(input.substr(t, 1)) * bcp;
        }
        if(!isNaN(padUp)) {
            padUp--;
            if (padUp > 0) {
                output -= Math.pow(base, padUp);
            }
        }
    } else {
        // Digital number  -->>  alphabet letter code
        input = parseInt(input);
        if(!isNaN(padUp)) {
            padUp--;
            if (padUp > 0) {
                input += Math.pow(base, padUp);
            }
        }
        output = "";
        for(var t = Math.floor(Math.log(input) / Math.log(base)); t >= 0; t--) {
            var bcp = Math.floor(Math.pow(base, t));
            var a = Math.floor(input / bcp) % base;
            output = output + index.substr(a, 1);
            input = input - (a * bcp);
        }
        output = output.reverse();
    }

    return output;
}