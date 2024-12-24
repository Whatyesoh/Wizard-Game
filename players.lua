allPlayers = {}
Player = {}
mainPlayer = 1

function Player:new (game)
    local player = {}
    setmetatable(player,{__index = self})

    player.playedCard = nil
    player.hand = {}
    player.bet = "-"
    player.tricks = 0
    player.score = 0
    player.name = ""

    table.insert(game.players,player)
    table.insert(allPlayers,player)
    return player
end

function Player:displayHand ()
    for i,card in ipairs(self.hand) do
        card:displayCard()
    end
end

function checkMouseHover ()
    local x,y = love.mouse.getPosition()
    x,y = pixelAdjusted(x,y)
    local player = allPlayers[mainPlayer]
    local found = 0
    for i = #player.hand, 1, -1 do
        card = player.hand[i]
        if (found == 1) then
            card.hovered = 0
        elseif (x >= card.x and x <= card.x + card.size * baseWidth and y >= card.y and y <= card.y + card.size * baseHeight) then
            found = 1
            card.hovered = 1
        else
            card.hovered = 0
        end
        card.targetX,card.targetY = card:calculateTarget(#player.hand+1,i,mainPlayer)
    end
end

function drawBets()
    love.graphics.setColor(1,1,1)

    local spaceWidth = pixelFontBig:getWidth(" ")
    local height = pixelFontBig:getHeight()
    love.graphics.setFont(pixelFontBig)
    local currentPos = 0
    for i,player in ipairs(allPlayers) do
        local betWidth = math.max(pixelFontBig:getWidth(player.tricks),pixelFontBig:getWidth(player.bet),pixelFontBig:getWidth(player.score))
        currentPos = currentPos + (betWidth + spaceWidth)
        perfectPrint(player.bet,screenWidth-currentPos,height)
    end
    local betWidth = pixelFontBig:getWidth("Bets: ")
    currentPos = currentPos + (betWidth + spaceWidth)
    perfectPrint("Bets: ",screenWidth -currentPos,height)

    currentPos = 0
    for i,player in ipairs(allPlayers) do
        local betWidth = math.max(pixelFontBig:getWidth(player.tricks),pixelFontBig:getWidth(player.bet),pixelFontBig:getWidth(player.score))
        currentPos = currentPos + (betWidth + spaceWidth)
        if (i == startingPlayer) then
            love.graphics.setColor(0,1,0)
        end
        if (i == mainPlayer) then
            love.graphics.setColor(0,1,1)
        end
        perfectPrint(i,screenWidth-currentPos,0)
        love.graphics.setColor(1,1,1)
    end
    betWidth = pixelFontBig:getWidth("Player: ")
    currentPos = currentPos + (betWidth + spaceWidth)
    perfectPrint("Player: ",screenWidth -currentPos,0)

    currentPos = 0
    for i,player in ipairs(allPlayers) do
        local betWidth = math.max(pixelFontBig:getWidth(player.tricks),pixelFontBig:getWidth(player.bet),pixelFontBig:getWidth(player.score))
        currentPos = currentPos + (betWidth + spaceWidth)
        perfectPrint(player.tricks,screenWidth-currentPos,height * 2)
    end
    local betWidth = pixelFontBig:getWidth("Wins: ")
    currentPos = currentPos + (betWidth + spaceWidth)
    perfectPrint("Wins: ",screenWidth -currentPos,height * 2)

    currentPos = 0
    for i,player in ipairs(allPlayers) do
        local betWidth = math.max(pixelFontBig:getWidth(player.tricks),pixelFontBig:getWidth(player.bet),pixelFontBig:getWidth(player.score))
        currentPos = currentPos + (betWidth + spaceWidth)
        perfectPrint(player.score,screenWidth-currentPos,height * 3)
    end
    local betWidth = pixelFontBig:getWidth("Score: ")
    currentPos = currentPos + (betWidth + spaceWidth)
    perfectPrint("Score: ",screenWidth -currentPos,height * 3)
end

function reorder()
    hand = allPlayers[mainPlayer].hand
    for i, card in ipairs(hand) do
        if (card.held == 1) then
            if (i > 1) then
                if (card.x < hand[i-1].x) then
                    local temp = card
                    hand[i] = hand[i-1]
                    hand[i-1] = temp
                    break
                end
            end
            if (i < #hand) then
                if (card.x > hand[i+1].x) then
                    local temp = card
                    hand[i] = hand[i+1]
                    hand[i+1] = temp
                    break
                end
            end
        end
    end
end