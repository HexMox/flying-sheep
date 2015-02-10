EventEmitter = require("eventemitter2").EventEmitter2
Flutter = require("./flutter.coffee")
config = require("./config.coffee")

GRID_HEIGHT = config.GRID_HEIGHT

COLUMN_COUNT = config.COLUMN_COUNT
RAW_COUNT = config.RAW_COUNT
KINDS = config.KINDS
STRATEGY = config.STRATEGY

class Flutters extends EventEmitter
    constructor: ->
        super @
        @flutters = null
        @strategy = null
        @$fluttersContainer = null
        @accumulateDis = 0

    init: (@$fluttersContainer)->
        @flutters = []
        @strategy = STRATEGY
        @produce(RAW_COUNT)

    reset: ->
        @flutters = []
        @$fluttersContainer.innerHTML = ""
        @strategy = STRATEGY
        @accumulateDis = 0

    produce: (rowsCount)->
        # pre produce one raw if maxtop not exceed grid height
        for row in [1..rowsCount]
            produceCount = @getRandomProduceCount()
            cols = @getRandomColumns(produceCount)
            for col in cols
                kind = @getRandomKind()
                flutter = new Flutter(kind, row, col)
                @flutters.push flutter
                flutter.draw()

    fall: (distance)->
        @accumulateDis += distance
        if @accumulateDis > GRID_HEIGHT
            @produce 1
            @accumulateDis -= GRID_HEIGHT
            @emit 'rise-one-grid'
        flutters = []
        for flutter in @flutters
            flutter.fall distance
            if flutter.shouldRemove()
                flutter.remove()
            else
                flutters.push flutter
        @flutters = flutters

    isOneBeTreaded: (sheeploc)->
        one = null
        flutters = []
        for flutter in @flutters
            # if one be treaded by sheep then remove it
            # unless it is a black cloud(maybe)
            if flutter.isBeTreaded(sheeploc)
                flutter.remove() if flutter.kind isnt "black-cloud"
                one = flutter
            else
                flutters.push flutter
        @flutters = flutters
        one

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

module.exports = (new Flutters)