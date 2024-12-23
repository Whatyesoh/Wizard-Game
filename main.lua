if arg[2] == "debug" then
    require("lldebugger").start()
end

socket = require("socket")
require "buttons"
require "pixelPerfect"
require "cards"
require "players"
require "gameControl"
require "game"
require "wizard"

io.stdout:setvbuf("no")

numPlayers = 4
gameState = 0
roundNum = 0
startingPlayer = 0
currentPlayer = 1
pixelFontFile = "assets/alagard.ttf"
isServer = true
startedGame = false


function love.load()
    --Window settings
    love.window.setVSync(0)
    love.window.setFullscreen(true)
    love.graphics.setDefaultFilter("nearest")

    screenWidth,screenHeight = love.graphics.getWidth(), love.graphics.getHeight()

    shadowShader = love.graphics.newShader("shadowShader.frag")
    canvas = love.graphics.newCanvas()

    setupScreen()

    spacing = 200

    sizeOfCards = 2

    wizardGame = {}
    
    wizardGame = createWizard(wizardGame)

    love.math.random(200)
    love.math.random(60)

    smallerFont = love.graphics.newFont("assets/Qager-zrlmw.ttf",30)
    
end


function drawCanvas()
    love.graphics.setCanvas(canvas)

    clearToResolution()

    love.graphics.setColor(1,1,1,1)

    showAllHands()

    wizardGame.draw(wizardGame)

    drawBets()

    love.graphics.setColor(1,1,1)
    perfectPrint(recentInfo,0,0)

    cutoffBars()
    
    love.graphics.setCanvas()
end

function love.update(dt)
    if (gameState == 0) then
        gameState = 1
    end

    controlUpdate(dt)

    wizardGame.update(dt,wizardGame)


    moveCards(dt)
    checkMouseHover()
    reorder()
    drawCanvas()
end

function love.keypressed(key)
    
end

function love.mousepressed(x,y,button)
    checkCardHeld(x,y,button)
    wizardGame.mousePress(x,y,button,wizardGame)
    progressGame()
end

function love.mousereleased(x,y,button)
    wizardGame.mouseRelease(x,y,button,wizardGame)
    releaseCards()
end

function love.draw()

    love.graphics.setColor(1,1,1,1)   
    love.graphics.setShader(shadowShader)
    love.graphics.draw(canvas)
    love.graphics.setShader()
    --love.graphics.draw(elfIcon,10,10,0,1,1)
end