EventEmitter = require("eventemitter2").EventEmitter2

class Decorations extends EventEmitter
    constructor: ->
        super @
        @state = "ground"
        @$walls = null
        @$ground = null
        @$timeBar = null

    init: (@$walls, @$ground, @$timeBar)->

    changeGroundToTimeBar: ->
        @$ground.style.display = "none"
        @$timeBar.style.display = "block"
        @state = "timeBar"

    risingWalls: ->
        @$walls.style.backgroundImage = ""

module.exports = (new Decorations)