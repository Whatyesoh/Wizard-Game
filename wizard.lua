function createWizard()
    local game = Game:new({
        name = "wizard", 
        cardSize = sizeOfCards,
        update = updateWizard,
        mousePress = wizardMousePress,
        mouseRelease = wizardMouseRelease,
        draw = drawWizard
    })
    
    game.active = true


    humanIcon = love.graphics.newImage("assets/humanIcon.png")
    dwarveIcon = love.graphics.newImage("assets/dwarveIcon.png")
    giantIcon = love.graphics.newImage("assets/giantIcon.png")
    elfIcon = love.graphics.newImage("assets/elfIcon.png")
    blankCard = love.graphics.newImage("assets/blankCard.png")

    baseWidth = blankCard:getWidth()
    baseHeight = blankCard:getHeight()

    local newCard

    for i = 0,14 do
        newCard = Card:new(0,0,sizeOfCards,"e",tostring(i),game)
        newCard = Card:new(0,0,sizeOfCards,"d",tostring(i),game)
        newCard = Card:new(0,0,sizeOfCards,"g",tostring(i),game)
        newCard = Card:new(0,0,sizeOfCards,"h",tostring(i),game)
    end

    local cardHeight = baseHeight * newCard.size
    local cardWidth = baseWidth * newCard.size

    game.handLocs = {
        {screenHeight - cardHeight*1.1,false},
        {cardWidth * .1,true},
        {cardHeight * .1,false},
        {screenWidth - cardWidth*1.1,true}
    }
    
    game.deckLocs = {{screenWidth-game.cardSize*baseWidth,screenHeight-game.cardSize*baseHeight}}

    for i,card in ipairs(game.cards) do
        card.x = game.deckLocs[1][1]
        card.y = game.deckLocs[1][2]
    end

    game.playedLocs = {
        {screenWidth/2 - game.cardSize * baseWidth/2, screenHeight - 2.5 * game.cardSize * baseHeight},
        {6 * game.cardSize * baseWidth/2, screenHeight/2 - game.cardSize * baseHeight/2},
        {screenWidth/2 - game.cardSize * baseWidth/2, 1.5 * game.cardSize * baseHeight},
        {screenWidth - 7 * game.cardSize * baseWidth/2, screenHeight/2 - game.cardSize * baseHeight/2}
    }

    local buttonsPerRow = 7
    local buttonSpacing = 4 * widthScaling


    for i = 0,20 do
        local newButton = Button:new(((i%buttonsPerRow)*buttonSpacing*20+20),20+buttonSpacing*20*math.floor(i/buttonsPerRow),60*widthScaling,60*widthScaling,
        
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
        newPlayer = Player:new(game)
    end

    game.cardsToDeal = 0
    game.cardsDealt = 0

    game.dealCards = GameAction:new({
        game = game,
        waitTime = .2,
        execute = 
        function (gameActionGame)
            drawCards(gameActionGame.players[gameActionGame.playerBeingDealt].hand,1,gameActionGame.playerBeingDealt)
            gameActionGame.playerBeingDealt = gameActionGame.playerBeingDealt + 1
            if (gameActionGame.playerBeingDealt > numPlayers) then
                gameActionGame.playerBeingDealt = 1
            end
            if (gameActionGame.playerBeingDealt == startingPlayer) then
                gameActionGame.cardsDealt = gameActionGame.cardsDealt + 1
            end
            if (gameActionGame.cardsDealt == gameActionGame.cardsToDeal) then
                finishedDraw()
                doneDealing = true
            end
        end,
        check = 
        function (gameActionGame)
            return gameActionGame.cardsDealt < gameActionGame.cardsToDeal
        end
    })

    return game
end

function updateWizard(dt,game)
    game:checkButtons()
    for i,gameAction in ipairs(game.gameActions) do
        gameAction:update(dt,game)
    end
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

    for i,card in ipairs(allCards) do
        if (card.held) then
            --release all cards
            card.held = 0

            --if it can be played, then play it
            if (card.y < .55 * screenHeight and currentPlayer == mainPlayer and gameState == 2 and doneDealing == true) then
                for j,newCard in ipairs(allPlayers[mainPlayer].hand) do
                    if (newCard.suit == card.suit and card.value == newCard.value) then
                        card:playCard(mainPlayer, j)
                    end
                end
            end
        end
        card.held = 0
    end
end

function drawWizard(game)
    game:drawButtons()
end