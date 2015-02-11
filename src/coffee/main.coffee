jquery = require("jquery")
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
$continuousHitContainer = $ ".continuous-hit-container"
$continuousHit = $ ".continuous-hit"

$decorations = $ ".decorations"
$walls = null
$ground = $ ".ground"
$timeBar = $ ".time-bar"
$bar = $ ".time-bar .bar"

$$over = jquery("#over")
$$gameoverBrand = jquery(".gameover-brand")
$$overContainer = jquery(".over-container")
$$score = jquery(".over-container .score")
$$highestScore = jquery(".over-container .highest-score")
$$btnGroup = jquery(".btn-group")
$$againBtn = jquery(".again-btn")
$$shareBtn = jquery(".share-btn")
$$share = jquery("#share")
$$lotteryBtn = jquery(".lottery-btn")
$$focusBtn = jquery(".focus-btn")

MIN_SCORE = 72
score = 0
highestScore = 0
if localStorage
    if localStorage.highestScore
        highestScore = localStorage.highestScore 
seconds = config.SECONDS
timer = null

game.on "init", ->
    initArea()
    initBtns()
    initDecorations()
    initSheep()
    initFlutters()
    initOverState()

game.on "start", ->
    startTime = Date.now()
    sec = 0
    timer = setInterval ->
        sec++;
        percent = Math.floor((1 - sec / seconds) * 100)
        # update time bar view, -4 for view
        decorations.updateTimeBar percent - 4
        # if sec >= seconds * 2/3
        #     decorations.changeGroundToTimeBar()
        if sec >= seconds
            clearInterval timer
            game.stop()
            showover()
    , 1000
    $continuousHitContainer.style.display = "none"
    updateScoreView()
    $decorations.style.display = "block"
    $header.style.display = "block"
    $sheep.style.display = "block"
    $fluttersContainer.style.display = "block"

game.on 'stop', ->
    clearInterval timer

showover = ->
    $$over.show()
    $$score.text(score)
    highestScore = score if score > highestScore
    localStorage.highestScore = highestScore
    $$highestScore.text(highestScore)
    $$gameoverBrand.animate
        top: 0
    , 500, "swing", ->
        setTimeout ->
            $$gameoverBrand.hide()
            $$gameoverBrand.css "top", "-1000px"
            $$overContainer.fadeIn()
            $$btnGroup.fadeIn()
        , 800

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
    decorations.init($walls, $ground, $timeBar, $bar)

initSheep = ->
    sheep.init($sheep)
    sheep.on 'crash-bottom', ->
        if decorations.state is "ground" then sheep.rerise()
        else 
            sheep.emit 'game-over'
            showover()
    sheep.on 'continuous-hit', (hits)->
        displayString = "none"
        displayString = "block" if hits > 0
        $continuousHitContainer.style.display = displayString
        $continuousHit.innerHTML = hits
    sheep.on 'game-over', ->
        game.stop()
    sheep.on 'show-over', ->
        showover()
    $fluttersContainer.addEventListener "touchstart", touchHandler
    $fluttersContainer.addEventListener "touchmove", touchHandler
    game.add sheep

initFlutters = ->
    flutters.init($fluttersContainer)
    flutters.on 'rise-one-grid', ->
        score += config.METER_PER_GRID
        updateScoreView()
        flutters.changeStrategy score
        if score > config.GROUND_TO_TIME_BAR_SCORE and decorations.state is "ground"
            decorations.changeGroundToTimeBar()

initOverState = ->
    $$againBtn.click ->
        $$over.hide()
        decorations.reset()
        sheep.reset()
        flutters.reset()
        score = 0
        seconds = 120
        game.start()
    $$shareBtn.click ->
        $$share.fadeIn()
    $$share.click ->
        $$share.fadeOut()
    console.log $$shareBtn, $$share
    $$lotteryBtn.click ->
        # show lottery view
    $$focusBtn.click ->
        # show focus view

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