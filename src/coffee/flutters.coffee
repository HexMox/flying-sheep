EventEmitter = require("eventemitter2").EventEmitter2
Flutter = require("./flutter.coffee")
config = require("./config.coffee")

DEFAULT_FLUTTER_WIDTH = config.DEFAULT_FLUTTER_WIDTH
DEFAULT_FLUTTER_HEIGHT = config.DEFAULT_FLUTTER_HEIGHT
OFFSET_X = config.WIDTH * config.SIDE_WALL_RATE / 2

COLUMN_COUNT = config.COLUMN_COUNT
ROW_COUNT = config.ROW_COUNT
KINDS = config.KINDS
STRATEGY = config.STRATEGY

class Flutters extends EventEmitter
    constructor: ->
        super @
        @flutters = null
        @strategyIndex = 0
        @strategy = null
        @$fluttersContainer = null
        @accumulateDis = 0

    init: (@$fluttersContainer)->
        @flutters = @getNewFlutters()
        @strategy = STRATEGY[@strategyIndex]
        @produce(ROW_COUNT)

    reset: ->
        @flutters = @getNewFlutters()
        @$fluttersContainer.innerHTML = ""
        @strategyIndex = 0
        @strategy = STRATEGY[@strategyIndex]
        @accumulateDis = 0
        @produce(ROW_COUNT)

    getNewFlutters: ->
        # flutters should cache 1 row that (ROW_COUNT+1)th row
        flutters = []
        for i in [1..ROW_COUNT+1]
            flutters.push new Array(COLUMN_COUNT)
        flutters

    produce: (rowsCount)->
        # pre produce one raw if maxtop not exceed grid height
        for row in [1..rowsCount]
            produceCount = @getRandomProduceCount()
            cols = @getRandomColumns(produceCount)
            for col in cols
                kind = @getRandomKind()
                flutter = new Flutter(kind, row, col)
                @flutters[row - 1][col - 1] = flutter
                flutter.draw()

    fall: (distance)->
        @accumulateDis += distance
        flag = if @accumulateDis > DEFAULT_FLUTTER_HEIGHT then 1 else 0
        flutters = @getNewFlutters()
        for aRowFlutters, rowIndex in @flutters
            for flutter, colIndex in aRowFlutters
                if flutter
                    flutter.fall distance
                    if flutter.shouldRemove()
                        flutter.remove()
                    else
                        if rowIndex + flag > ROW_COUNT
                            # special remove
                            flutter.remove()
                        else
                            flutters[rowIndex+flag][colIndex] = flutter
        @flutters = flutters
        if flag
            @produce 1
            @accumulateDis -= DEFAULT_FLUTTER_HEIGHT 
            @emit 'rise-one-grid'

    isOneBeTreaded: (sheeploc)->
        rowIndex = Math.floor(sheeploc.y/DEFAULT_FLUTTER_HEIGHT)
        colIndex = Math.floor((sheeploc.x - OFFSET_X)/DEFAULT_FLUTTER_WIDTH)
        return null if rowIndex > ROW_COUNT
        flutter = @flutters[rowIndex][colIndex]
        if flutter?.isBeTreaded(sheeploc)
            if flutter.kind isnt "black-cloud"
                flutter.remove()
                @flutters[rowIndex][colIndex] = null
        else
            flutter = null
        flutter

    getRandomProduceCount: ->
        left = right = 0
        random = Math.random()
        for probility, index in @strategy.amountProbilities
            right += probility
            if left <= random < right
                return index + 1
            left += right
        @strategy.amountProbilities.length

    getRandomColumns: (count)->
        result = []
        col = null
        for i in [1..count]
            while col is null or col in result
                col = Math.floor(Math.random() * COLUMN_COUNT) + 1
            result.push col
        result

    getRandomKind: ->
        left = right = 0
        random = Math.random()
        for probility, index in @strategy.kindProbilities
            right += probility
            if left <= random < right
                return KINDS[index]
            left += right
        "black-cloud"

    changeStrategy: (score)->
        if score < 50 then @strategyIndex = 0
        else if 50 <= score < 1500 then @strategyIndex = 1
        else if 1500 <= score < 5000 then @strategyIndex = 2
        else @strategyIndex = 3
        @strategy = STRATEGY[@strategyIndex]


module.exports = (new Flutters)