"use strict";

var _typeof = typeof Symbol === "function" && typeof Symbol.iterator === "symbol" ? function (obj) { return typeof obj; } : function (obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; };

var _ = {
	// Return the second value if the first value is undefined..
	get: function get(obj1, obj2) {
		return typeof obj1 === "undefined" ? obj2 : obj1;
	},

	// Value is a boolean..
	isBoolean: function isBoolean(obj) {
		return typeof obj === "boolean";
	},

	// Value is a finite number..
	isFinite: function (_isFinite) {
		function isFinite(_x) {
			return _isFinite.apply(this, arguments);
		}

		isFinite.toString = function () {
			return _isFinite.toString();
		};

		return isFinite;
	}(function (int) {
		return isFinite(int) && !isNaN(parseFloat(int));
	}),

	// Value is an integer..
	isInteger: function isInteger(int) {
		return !isNaN(self.toNumber(int, 0));
	},

	// Username is a justinfan username..
	isJustinfan: function isJustinfan(username) {
		return RegExp("^(justinfan)(\\d+$)", "g").test(username);
	},

	// Value is null..
	isNull: function isNull(obj) {
		return obj === null;
	},

	// Value is a regex..
	isRegex: function isRegex(str) {
		return (/[\|\\\^\$\*\+\?\:\#]/.test(str)
		);
	},

	// Value is a string..
	isString: function isString(str) {
		return typeof str === "string";
	},

	// Value is a valid url..
	isURL: function isURL(str) {
		return RegExp("^(?:(?:https?|ftp)://)(?:\\S+(?::\\S*)?@)?(?:(?!(?:10|127)(?:\\.\\d{1,3}){3})(?!(?:169\\.254|192\\.168)(?:\\.\\d{1,3}){2})(?!172\\.(?:1[6-9]|2\\d|3[0-1])(?:\\.\\d{1,3}){2})(?:[1-9]\\d?|1\\d\\d|2[01]\\d|22[0-3])(?:\\.(?:1?\\d{1,2}|2[0-4]\\d|25[0-5])){2}(?:\\.(?:[1-9]\\d?|1\\d\\d|2[0-4]\\d|25[0-4]))|(?:(?:[a-z\\u00a1-\\uffff0-9]-*)*[a-z\\u00a1-\\uffff0-9]+)(?:\\.(?:[a-z\\u00a1-\\uffff0-9]-*)*[a-z\\u00a1-\\uffff0-9]+)*(?:\\.(?:[a-z\\u00a1-\\uffff]{2,}))\\.?)(?::\\d{2,5})?(?:[/?#]\\S*)?$", "i").test(str);
	},

	// Return a random justinfan username..
	justinfan: function justinfan() {
		return "justinfan" + Math.floor(Math.random() * 80000 + 1000);
	},

	// Return a valid password..
	password: function password(str) {
		return str === "SCHMOOPIIE" || "" || null ? "SCHMOOPIIE" : "oauth:" + str.toLowerCase().replace("oauth:", "");
	},

	// Race a promise against a delay..
	promiseDelay: function promiseDelay(time) {
		return new Promise(function (resolve) {
			setTimeout(resolve, time);
		});
	},

	// Replace all occurences of a string using an object..
	replaceAll: function replaceAll(str, obj) {
		if (str === null || typeof str === "undefined") {
			return null;
		}
		for (var x in obj) {
			str = str.replace(new RegExp(x, "g"), obj[x]);
		}
		return str;
	},

	unescapeHtml: function unescapeHtml(safe) {
		return safe.replace(/\\&amp\\;/g, "&").replace(/\\&lt\\;/g, "<").replace(/\\&gt\\;/g, ">").replace(/\\&quot\\;/g, "\"").replace(/\\&#039\\;/g, "'");
	},

	// Add word to a string..
	addWord: function addWord(line, word) {
		if (line.length != 0) {
			line += " ";
		}
		return line += word;
	},

	// Return a valid channel name..
	channel: function channel(str) {
		var channel = typeof str === "undefined" || str === null ? "" : str;
		return channel.charAt(0) === "#" ? channel.toLowerCase() : "#" + channel.toLowerCase();
	},

	// Extract a number from a string..
	extractNumber: function extractNumber(str) {
		var parts = str.split(" ");
		for (var i = 0; i < parts.length; i++) {
			if (self.isInteger(parts[i])) {
				return ~~parts[i];
			}
		}
		return 0;
	},

	// Format the date..
	formatDate: function formatDate(date) {
		var hours = date.getHours();
		var mins = date.getMinutes();

		hours = (hours < 10 ? "0" : "") + hours;
		mins = (mins < 10 ? "0" : "") + mins;

		return hours + ":" + mins;
	},

	// Inherit the prototype methods from one constructor into another..
	inherits: function inherits(ctor, superCtor) {
		ctor.super_ = superCtor;
		var TempCtor = function TempCtor() {};
		TempCtor.prototype = superCtor.prototype;
		ctor.prototype = new TempCtor();
		ctor.prototype.constructor = ctor;
	},

	// Merge two objects..
	merge: function merge(obj1, obj2) {
		for (var p in obj2) {
			try {
				if (obj2[p].constructor == Object) {
					obj1[p] = self.merge(obj1[p], obj2[p]);
				} else {
					obj1[p] = obj2[p];
				}
			} catch (e) {
				obj1[p] = obj2[p];
			}
		}
		return obj1;
	},

	// Split a line but don't cut a word in half..
	splitLine: function splitLine(input, length) {
		var lastSpace = input.substring(0, length).lastIndexOf(" ");
		return [input.substring(0, lastSpace), input.substring(lastSpace + 1)];
	},

	// Parse string to number. Returns NaN if string can't be parsed to number..
	toNumber: function toNumber(num, precision) {
		if (num === null) return 0;
		var factor = Math.pow(10, self.isFinite(precision) ? precision : 0);
		return Math.round(num * factor) / factor;
	},

	// Merge two arrays..
	union: function union(arr1, arr2) {
		var hash = {};
		var ret = [];
		for (var i = 0; i < arr1.length; i++) {
			var e = arr1[i];
			if (!hash[e]) {
				hash[e] = true;
				ret.push(e);
			}
		}
		for (var i = 0; i < arr2.length; i++) {
			var e = arr2[i];
			if (!hash[e]) {
				hash[e] = true;
				ret.push(e);
			}
		}
		return ret;
	},

	// Return a valid username..
	username: function username(str) {
		var username = typeof str === "undefined" || str === null ? "" : str;
		return username.charAt(0) === "#" ? username.substring(1).toLowerCase() : username.toLowerCase();
	}
};