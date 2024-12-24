allCards = {}
Card = {}
playedCards = {}
previouslyPlayedCards = {}
currentCard = 1

function Card:new (x, y, size, suit, value, game)
    local card = {}
    setmetatable(card,{__index = self})
    card.x = screenWidth - sizeOfCards * baseWidth * 1.1
    card.y = screenHeight - sizeOfCards * baseHeight * 1.1
    card.targetX = x
    card.targetY = y
    card.speed = 10
    card.suit = suit
    card.value = value
    card.size = size
    card.hovered = 0
    card.held = 0
    card.visibility = 0
    card.visibleSide = 0
    card.player = nil
    card.inHand = false
    card.played = false
    card.game = game or {}
    table.insert(allCards,card)
    if (card.game.cards) then
        table.insert(card.game.cards,card)
    end
    return card
end

function Card:setVisibility(vis,side)
    self.visibility = vis
    self.visibleSide = side
end

function moveCards(dt)
    for i,card in ipairs(allCards) do
        card.x = card.x + card.speed * dt* (card.targetX - card.x)
        card.y = card.y + card.speed * dt* (card.targetY - card.y)
    end
end

function shuffleDeck()
    currentCard = 1
    for i,card in ipairs(allCards) do
        card.visibleSide = 0
        card.player = nil
        card.played = false
        card.inHand = false
        card.size = sizeOfCards
        card.held = 0
        card.hovered = 0
    end

    for i,player in ipairs(allPlayers) do
        player.hand = {}
    end

    for i = 1, #allCards - 1 do
        local r = love.math.random(1,#allCards)
        allCards[i], allCards[r] = allCards[r], allCards[i]
    end
end

function Card:calculateTarget(playerHandSize,position,playerNum)
    local maxCards = 60 / #allPlayers
    local cardW = self.size * baseWidth
    local cardH = self.size * baseHeight

    if (self.played) then
        return self.game.playedLocs[self.player][1],self.game.playedLocs[self.player][2]
    end

    if (self.held == 1) then
        local x,y = love.mouse.getPosition()
        x,y = pixelAdjusted(x,y)
        return x - self.size * baseWidth/2,y - (self.size * baseHeight)/2
    end

    local checkHover = 0

    if (self.hovered == 1) then
        checkHover = baseHeight*.1*card.size
    end

    if (self.inHand == false and self.played == false) then
        return self.game.deckLocs[1][1],self.game.deckLocs[1][2]
    end

    local maxHoriz = 9 * cardW
    local maxVert = 2 * cardH
    local minHoriz = 1.5 * cardW
    local minVert = 2 * cardH

    if (playerNum ~= mainPlayer) then
        if ((playerNum-mainPlayer)%2 == 0) then
            minHoriz = 1 * cardW
            maxHoriz = 5 * cardW
        end
    end
    
    local horizBound = minHoriz * (1-math.pow((playerHandSize/maxCards),.5)) + maxHoriz * math.pow(playerHandSize/maxCards,.5)
    local vertBound = minVert * (1-(maxCards / playerHandSize)) + maxVert * (maxCards/playerHandSize)

    if (self.game.handLocs[playerNum][2] == false) then
        return ((screenWidth - horizBound)/2) + (position*((horizBound)/(playerHandSize))) - cardW/2, self.game.handLocs[playerNum][1] - checkHover
    else
        return self.game.handLocs[playerNum][1], ((screenHeight - vertBound)/2) + (position*((vertBound)/(playerHandSize))) - cardH/2 - checkHover
    end
end

function calculateTargets()
    for i, player in ipairs(allPlayers) do
        local side
        if (i == mainPlayer) then
            side = 1
        else
            side = 0
        end
        for j, card in ipairs(player.hand) do
            card.targetX, card.targetY = card:calculateTarget(#player.hand+1,j,i)
            card.visibleSide = side
        end
    end
end

function showAllHands()
    local maxCards = 60 / #allPlayers
    local heldCard
    for i, player in ipairs(allPlayers) do
        for j, card in ipairs(player.hand) do
            if (card.held == 1) then
                heldCard = card
            else
                card:displayCard()
            end
        end
    end
    for i,card in ipairs(allCards) do
        if (card.inHand == false) then
            if (card.played) then
                card.targetX,card.targetY = card:calculateTarget(0,0,mainPlayer)
                card:displayCard()
            end
        end
    end
    for i = #allCards,currentCard,-1 do
        allCards[i].targetX, allCards[i].targetY = allCards[i]:calculateTarget(0,0,mainPlayer)
        allCards[i]:displayCard()
    end
    if (heldCard) then
        heldCard:displayCard()
    end
end

function Card:displayCard()
    if (self.visibleSide == 0) then
        love.graphics.setColor(.2,.2,.2,1)
    elseif (self.value == "0" or self.value == "14") then
        love.graphics.setColor(1,1,1,1)
    elseif (self.suit == "e") then
        love.graphics.setColor(.7,1,.5,1)
    elseif (self.suit == "h") then
        love.graphics.setColor(.5,.7,1,1)
    elseif (self.suit == "g") then
        love.graphics.setColor(1,1,.7,1)
    else    
        love.graphics.setColor(1,.5,.5,1)
    end
    perfectRoundSquare("fill",self.x,self.y,baseWidth * self.size,baseHeight * self.size)

    love.graphics.setColor(0,0,0,1)
    
    if (self.y < screenHeight * .55 and self.visibleSide == 1 and self.inHand and currentPlayer == mainPlayer and gameState == 2) then
        love.graphics.setColor(.5,.9,1,1)
    end

    perfectRoundSquare("line",self.x,self.y,baseWidth * self.size,baseHeight * self.size)

    if (self.visibleSide == 0) then
        return
    end

    love.graphics.setColor(1,1,1,1)
        
    local icon

    if (self.suit == "e") then
        icon = elfIcon
    elseif (self.suit == "h") then
        icon = humanIcon
    elseif (self.suit == "g") then
        icon = giantIcon
    else    
        icon = dwarveIcon
    end

    
    perfectDraw(icon,self.size*baseWidth/5+self.x,self.size*baseHeight/5+self.y,0,self.size/1.5,self.size/1.5)

    if (self.suit == "e") then
        love.graphics.setColor(.4,.8,.2,1)
    elseif (self.suit == "h") then
        love.graphics.setColor(.2,.4,.8,1)
    elseif (self.suit == "g") then
        love.graphics.setColor(.8,.8,.2,1)
    else    
        love.graphics.setColor(.8,.2,.2,1)
    end

    love.graphics.setColor(0,0,0,1)

    local cardText = self.value
    if cardText == "14" then
        cardText = "W"
    end
    if cardText == "0" then
        cardText = "J"
    end

    love.graphics.setFont(pixelFont)
    perfectPrint(cardText,sizeOfCards*baseWidth/9+self.x,sizeOfCards*baseHeight/10+self.y)
end

function checkCardHeld(x,y,button)
    if (button == 1) then
        for i, card in ipairs(allCards) do
            if (card.hovered == 1) then
                card.held = 1
            else
                card.held = 0
            end
        end
    end
end

function Card:playCard(player, index)
    allPlayers[player].playedCard = self
    table.insert(playedCards,self)
    self.visibleSide = 1
    self.size = 1.5
    self.played = true
    self.inHand = false

    table.remove(allPlayers[player].hand,index)
    calculateTargets()
    currentPlayer = currentPlayer + 1
    if (currentPlayer > numPlayers) then
        currentPlayer = 1
    end
    if (currentPlayer == trickWinner) then
        evaluatePlayedCards()
        waitingForNewTrick = true
    end
end

function finishedDraw()
    if (currentCard <= #allCards) then
        allCards[currentCard].visibleSide = 1
    end
end

function clearPlayed()
    previouslyPlayedCards = {}
    for i,card in ipairs(playedCards) do
        table.insert(previouslyPlayedCards,card)
    end
    playedCards = {}
    for i,card in ipairs(allCards) do
        if (card.played) then
            card.size = sizeOfCards
            card.played = false
        end        
    end
end

function drawCards(hand,num,player)
    local start = currentCard
    for i = start,math.min(#allCards,num+start-1) do
        if (player == mainPlayer) then
            allCards[i].visibleSide = 1
        else
            allCards[i].visibleSide = 0
        end
        allCards[i].player = player
        allCards[i].inHand = true
        table.insert(hand,allCards[i])
        currentCard = currentCard + 1
    end
    calculateTargets()
end

function Card:sayHi()
    print(self.x)
end