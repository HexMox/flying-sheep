EventEmitter = require("eventemitter2").EventEmitter2
utils = require("../../lib/utils")
config = require("./config.coffee")

$ = utils.$

HEIGHT = config.HEIGHT
DEFAULT_FLUTTER_WIDTH = config.DEFAULT_FLUTTER_WIDTH
DEFAULT_FLUTTER_HEIGHT = config.DEFAULT_FLUTTER_HEIGHT
KINDS = config.KINDS
GRID_HEIGHT = config.GRID_HEIGHT
GRID_OFFSET_Y = config.GRID_OFFSET_Y
OFFSET_X = config.WIDTH * config.SIDE_WALL_RATE / 2

$fluttersContainer = $(".flutters-container")

class Flutter extends EventEmitter
    constructor: (kind, row, col)->
        super @
        @x = OFFSET_X + DEFAULT_FLUTTER_WIDTH * (col - 1)
        @y = Math.random() * GRID_OFFSET_Y + (row - 1) * GRID_HEIGHT
        @width = DEFAULT_FLUTTER_WIDTH
        @height = DEFAULT_FLUTTER_HEIGHT
        @kind = kind
        @$flutter = @createDom()

    remove: ->
        $fluttersContainer.removeChild @$flutter

    fall: (distance)->
        @y += distance
        @draw()

    shouldRemove: ->
        @y > HEIGHT - GRID_HEIGHT

    isBeTreaded: (sheeploc)->
        (@x <= sheeploc.x + sheeploc.width/2 <= @x + @width) and \
        (@y + @height/4 <= sheeploc.y + sheeploc.height <= @y + @height*3/4)

    draw: ->
        @$flutter.style.webkitTransform = "translate3d(#{@x}px, #{@y}px, 0)"

    createDom: ->
        div = document.createElement "div"
        div.className = "#{@kind}"
        div.style.width = "#{@width}px"
        div.style.height = "#{@height}px"
        div.style.webkitTransform = "translate3d(#{@x}, #{@y}, 0)"
        $fluttersContainer.appendChild div
        div

module.exports = Flutter