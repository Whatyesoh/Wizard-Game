if arg[2] == "debug" then
    require("lldebugger").start()
end
socket = require("socket")
require "buttons"
require "pixelPerfect"
require "cards"
require "players"
require "gameControl"
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

    for i = 1,13 do
        local newCard = Card:new(i*spacing,0,sizeOfCards,"e",tostring(i))
        local newCard = Card:new(i*spacing+spacing/4,0,sizeOfCards,"d",tostring(i))
        local newCard = Card:new(i*spacing+2*spacing/4,0,sizeOfCards,"g",tostring(i))
        local newCard = Card:new(i*spacing+3*spacing/4,0,sizeOfCards,"h",tostring(i))
    end
    local newCard = Card:new(14*spacing,0,sizeOfCards,"e",tostring(14))
    local newCard = Card:new(14*spacing+spacing/4,0,sizeOfCards,"d",tostring(14))
    local newCard = Card:new(14*spacing+2*spacing/4,0,sizeOfCards,"g",tostring(14))
    local newCard = Card:new(14*spacing+3*spacing/4,0,sizeOfCards,"h",tostring(14))
    local newCard = Card:new(15*spacing,0,sizeOfCards,"e",tostring(0))
    local newCard = Card:new(15*spacing+spacing/4,0,sizeOfCards,"d",tostring(0))
    local newCard = Card:new(15*spacing+2*spacing/4,0,sizeOfCards,"g",tostring(0))
    local newCard = Card:new(15*spacing+3*spacing/4,0,sizeOfCards,"h",tostring(0))

    love.math.random(200)
    love.math.random(60)
        
    humanIcon = love.graphics.newImage("assets/humanIcon.png")
    dwarveIcon = love.graphics.newImage("assets/dwarveIcon.png")
    giantIcon = love.graphics.newImage("assets/giantIcon.png")
    elfIcon = love.graphics.newImage("assets/elfIcon.png")
    blankCard = love.graphics.newImage("assets/blankCard.png")

    smallerFont = love.graphics.newFont("assets/Qager-zrlmw.ttf",30)

    betButtons = {}

    local buttonsPerRow = 7
    local buttonSpacing = 4

    thread = love.thread.newThread("thread.lua")

    for i = 0,20 do
        local newButton = Button:new(((i%buttonsPerRow)*buttonSpacing*20+20),20+buttonSpacing*20*math.floor(i/buttonsPerRow),60,60,function ()
            if (gameState == 1 and i <= roundNum) then
                allPlayers[mainPlayer].bet = i
                currentPlayer = currentPlayer + 1
                if (currentPlayer > numPlayers) then
                    currentPlayer = 1
                end
                if (currentPlayer == startingPlayer) then
                    gameState = 2
                end
            end
        end,i)
        table.insert(betButtons,newButton)
    end

    for i = 1,numPlayers do
        local newPlayer = Player:new()        
    end

    startGame()
    
end


function drawCanvas()
    love.graphics.setCanvas(canvas)

    clearToResolution()

    love.graphics.setColor(1,1,1,1)

    showAllHands()

    drawButtons()

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
    for i,v in ipairs(betButtons) do
        if (v.text > roundNum or currentPlayer ~= mainPlayer or gameState ~= 1 or waitingToStartTrick or doneDealing == false) then
            v:setVisibility(0)
        else
            v:setVisibility(1)
        end
    end
    controlUpdate(dt)
    moveCards(dt)
    checkMouseHover()
    reorder()
    drawCanvas()
end

function love.keypressed(key)
    if (key == "space") then
        thread:start(false, 53590, numPlayers)
        isServer = false
    end
    if (key == "w") then
        startRound()
    end
end

function love.mousepressed(x,y,button)
    checkCardHeld(x,y,button)
    checkMousePress(x,y,button)
    progressGame()
end

function love.mousereleased(x,y,button)
    checkMouseRelease(x,y,button)
    releaseCards()
end

function love.draw()

    love.graphics.setColor(1,1,1,1)   
    love.graphics.setShader(shadowShader)
    love.graphics.draw(canvas)
    love.graphics.setShader()
    --love.graphics.draw(elfIcon,10,10,0,1,1)
end