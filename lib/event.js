var EventEmitter = require("eventemitter2").EventEmitter2
var utils = require("./utils")

EventEmitter.extend = utils.extend

module.exports = EventEmitter