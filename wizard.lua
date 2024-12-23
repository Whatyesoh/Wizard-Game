humanIcon = nil
dwarveIcon = nil
elfIcon = nil
blankCard = nil

function createWizard(game)
    game = Game:new("wizard", {},{},{},{},{},true,sizeOfCards,updateWizard,wizardMousePress,wizardMouseRelease,drawWizard)
    game.active = true

    local newCard

    for i = 0,14 do
        newCard = Card:new(0,0,sizeOfCards,"e",tostring(i),game)
        newCard = Card:new(0,0,sizeOfCards,"d",tostring(i),game)
        newCard = Card:new(0,0,sizeOfCards,"g",tostring(i),game)
        newCard = Card:new(0,0,sizeOfCards,"h",tostring(i),game)
    end

    humanIcon = love.graphics.newImage("assets/humanIcon.png")
    dwarveIcon = love.graphics.newImage("assets/dwarveIcon.png")
    giantIcon = love.graphics.newImage("assets/giantIcon.png")
    elfIcon = love.graphics.newImage("assets/elfIcon.png")
    blankCard = love.graphics.newImage("assets/blankCard.png")

    local buttonsPerRow = 7
    local buttonSpacing = 4


    for i = 0,20 do
        local newButton = Button:new(((i%buttonsPerRow)*buttonSpacing*20+20),20+buttonSpacing*20*math.floor(i/buttonsPerRow),60,60,
        
        function ()
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
        end

        ,i,1,

        function (button)
            if (button.text > roundNum or currentPlayer ~= mainPlayer or gameState ~= 1 or waitingToStartTrick or doneDealing == false) then
                button.visible = false
            else
                button.visible = true
            end
        end

        ,game, genericButtonDraw)

    end

    local newPlayer

    for i = 1,numPlayers do
        newPlayer = Player:new()
    end

    startGame()

    return game
end

function updateWizard(dt,game)
    game:checkButtons()
end

function wizardMousePress(x, y, buttonPressed, game)
    for i,button in ipairs(game.buttons) do
        button:checkMousePress(x, y, buttonPressed)
    end
end

function wizardMouseRelease(x, y, buttonPressed, game)
    for i, button in ipairs(game.buttons) do
        button:checkMouseRelease(x,y,buttonPressed)
    end
end

function drawWizard(game)
    game:drawButtons()
end