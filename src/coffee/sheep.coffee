EventEmitter = require("eventemitter2").EventEmitter2
jquery = require("jquery")
Vector = require("../../lib/vector")
config = require("./config.coffee")
flutters = require("./flutters.coffee")

WIDTH = config.WIDTH
HEIGHT = config.HEIGHT

ONE_RISE_HEIGHT = config.ONE_RISE_HEIGHT
BASE_LINE = config.BASE_LINE

DEFAULT_SHEEP_WIDTH = config.DEFAULT_SHEEP_WIDTH
DEFAULT_SHEEP_HEIGHT = config.DEFAULT_SHEEP_HEIGHT
DEFAULT_X = (WIDTH - DEFAULT_SHEEP_WIDTH) / 2
DEFAULT_Y = HEIGHT - DEFAULT_SHEEP_HEIGHT
MIN_X = 0
MAX_X = WIDTH - DEFAULT_SHEEP_WIDTH
# assume rising need 1sec, ONE_RISE_HEIGHT = 180px
G = 2 * ONE_RISE_HEIGHT / (60 * 60) 
DEFAULT_UP_SPEED = -G * 60

class Sheep extends EventEmitter
    constructor: ->
        super @
        @x = DEFAULT_X
        @y = DEFAULT_Y
        @width = DEFAULT_SHEEP_WIDTH
        @height = DEFAULT_SHEEP_HEIGHT
        @continuousHitsCount = 0
        @vector = new Vector(0, DEFAULT_UP_SPEED, 0, G)
        @$sheep = null

        @rising = no
        @falling = no
        @died = no

    init: (@$sheep)->
        @$sheep.style.width = "#{@width}px"
        @$sheep.style.height = "#{@height}px"
        @$sheep.className = "sheep normal-sheep"
        @draw()

    reset: ->
        @x = DEFAULT_X
        @y = DEFAULT_Y
        @width = DEFAULT_SHEEP_WIDTH
        @height = DEFAULT_SHEEP_HEIGHT
        @continuousHitsCount = 0
        @vector = new Vector(0, DEFAULT_UP_SPEED, 0, G)
        @$sheep.className = "sheep normal-sheep"
        @rising = no
        @falling = no
        @died = no
        @$sheep.style.left = @$sheep.style.bottom = ""

    draw: ->
        @$sheep.style.webkitTransform = "translate3d(#{@x}px, #{@y}px, 0)"

    drift: (targetX)->
        # the time of horizontal drift is 1sec
        targetX = WIDTH if targetX > WIDTH
        targetX = 0 if targetX < 0
        distance = targetX - @x
        @vector.vx = distance * 2 / 60
        @vector.ax = -@vector.vx / 60

    isFalling: ->
        @vector.vy >= 0

    move: ->
        @x = @x + @vector.vx
        @x = MIN_X if @x < MIN_X
        @x = MAX_X if @x > MAX_X
        newy = @y + @vector.vy
        if @isFalling(@vector) then @fallSheep(newy)
        else
            if newy < BASE_LINE then flutters.fall -@vector.vy
            else @riseSheep(newy)
        @vector.update()
        @draw()

    riseSheep: (@y)->
        # @changeFace "rising-sheep" if @rising isnt yes
        @rising = yes
        @falling = no

    fallSheep: (@y)->
        # @changeFace "falling-sheep" if @falling isnt yes
        @falling = yes
        @rising = no
        flutter = flutters.isOneBeTreaded @getLoc()
        if flutter isnt null
            @trigger flutter
        if @y >= DEFAULT_Y 
            @emit "crash-bottom"
        if @y >= HEIGHT
            @emit "game-over"

    getLoc: ->
        obj = 
            x: @x + @width/2
            y: @y + @height

    rerise: ->
        @vector.vy = DEFAULT_UP_SPEED
        @vector.vx = 0
        @vector.ax = 0

    beLightninged: ->
        @changeFace "lightning-sheep"
        @died = yes
        @falling = @rising = no
        @emit "game-over"
        # lightning effect
        setTimeout =>
            @$sheep.style.webkitTransform = ""
            @$sheep.style.left = "#{@x}px"
            @$sheep.style.bottom = "#{HEIGHT-@y-@height}px"
            jquery(".sheep").animate
                bottom: "#{-@height}px"
            , 500, "swing", =>
                @emit "show-over"
        , 500

    rush: ->
        @vector.vy = DEFAULT_UP_SPEED * 1.5

    trigger: (flutter)->
        switch flutter.kind
            when "white-cloud"
                if @continuousHitsCount is 5
                    @continuousHitsCount = 0
                    @rush()
                else
                    @continuousHitsCount++
                    @rerise()
                @emit 'continuous-hit', @continuousHitsCount
            when "black-cloud" then @beLightninged()
            when "red-packet" then @rush()
            else 
                @continuousHitsCount = 0
                @emit 'continuous-hit', @continuousHitsCount

    changeFace: (classname)->
        @$sheep.className = "sheep " + classname

module.exports = (new Sheep)