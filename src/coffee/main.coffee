Game = require("../../lib/game")
utils = require("../../lib/utils")
config = require("./config.coffee")
flutters = require("./flutters.coffee")
sheep = require("./sheep.coffee")
decorations = require("./decorations.coffee")

$ = utils.$
game = new Game()

$area = $ ".area"

$initContainer = $ ".init-container"
$startBtn = $ ".start-btn"
$showInstructionBtn = $ ".show-instruction-btn"
$instruction = $ ".instruction"
$instructionBackBtn = $ ".instruction-back-btn"

$header = $ ".header"
$score = $ ".header .score"
$fluttersContainer = $ ".flutters-container"
$sheep = $ ".sheep"
$continuousHit = $ ".continuous-hit"

$walls = null
$ground = $ ".ground"
$timeBar = $ ".time-bar"

MIN_SCORE = 72
score = 0
seconds = 120

game.on "init", ->
    initArea()
    initBtns()
    initDecorations()
    initSheep()
    initFlutters()

game.on "start", ->
    $header.style.display = "block"
    $sheep.style.display = "block"
    $fluttersContainer.style.display = "block"

game.on 'stop', ->
    ##

initArea = ->
    $area.style.width = "#{config.WIDTH}px"
    $area.style.height = "#{config.HEIGHT}px"

initBtns = ->
    $startBtn.addEventListener "click", ->
        $initContainer.style.display = "none"
        game.start()
    $showInstructionBtn.addEventListener "click", ->
        $instruction.style.display = "block"
    $instructionBackBtn.addEventListener "click", ->
        $instruction.style.display = "none"

initDecorations = ->
    decorations.init($walls, $ground, $timeBar)

initSheep = ->
    sheep.init($sheep)
    sheep.on 'crash-bottom', ->
        if decorations.state is "ground"
            sheep.rerise()
    sheep.on 'continuous-hit', (hits)->
        displayString = "none"
        displayString = "block" if hits > 0
        $continuousHit.style.display = displayString
        $continuousHit.innerHTML = hits
    sheep.on 'game-over', ->
        game.stop()
    $fluttersContainer.addEventListener "touchstart", touchHandler
    $fluttersContainer.addEventListener "touchmove", touchHandler
    game.add sheep

initFlutters = ->
    flutters.init($fluttersContainer)
    flutters.on 'rise-one-grid', ->
        score += config.METER_PER_GRID
        updateScoreView()
        if score > config.GROUND_TO_TIME_BAR_SCORE
            decorations.changeGroundToTimeBar()

touchHandler = do ->
    lasttime = 0
    return (event)->
        event.preventDefault()
        now = Date.now()
        time = now - lasttime
        lasttime = now
        if time > 100
            targetX = event.touches[0].clientX
            sheep.drift targetX

updateScoreView = ->
    $score.innerHTML = score

game.init()