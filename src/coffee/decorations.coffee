EventEmitter = require("eventemitter2").EventEmitter2
config = require("./config.coffee")

TIME_BAR_HEIGHT = config.TIME_BAR_HEIGHT
GROUND_HEIGHT = config.GROUND_HEIGHT

class Decorations extends EventEmitter
    constructor: ->
        super @
        @state = "ground"
        @$walls = null
        @$ground = null
        @$timeBar = null
        @$bar = null

    init: (@$walls, @$ground, @$timeBar, @$bar)->
        # @$ground.style.height = "#{GROUND_HEIGHT}px"
        @$timeBar.style.height = "#{TIME_BAR_HEIGHT}px"

    reset: ->
        @$ground.style.display = "block"
        @$timeBar.style.display = "none"
        @state = "ground"

    changeGroundToTimeBar: ->
        @$ground.style.display = "none"
        @$timeBar.style.display = "block"
        @state = "timeBar"

    updateTimeBar: (percent)->
        @$bar.style.width = "#{percent}%"

    risingWalls: ->
        @$walls.style.backgroundImage = ""

module.exports = (new Decorations)