cardsToDeal = 0
cardsDealt = 0
updateTime = 0
trickWinner = 1
waitingToStartTrick = false
waitingForNewTrick = false
doneDealing = false
recentInfo = ""

function startGame()
    startingPlayer = love.math.random(1,numPlayers)
    roundNum = 0
    startRound()
end

function startRound()
    dealingCards = true
    gameState = 1
    startingPlayer = startingPlayer + 1
    if (startingPlayer > numPlayers) then
        startingPlayer = 1
    end
    currentPlayer = startingPlayer
    roundNum = roundNum + 1
    trickWinner = currentPlayer

    waitingToStartTrick = false
    waitingForNewTrick = false

    shuffleDeck()

    cardsToDeal = roundNum
    cardsDealt = 0
    doneDealing = false

    for i,player in ipairs(allPlayers) do
        player.bet = "-"
        player.tricks = 0
    end

end

function controlUpdate(dt)
    updateTime = updateTime + dt
    if (updateTime > .4) then
        updateTime = 0
        if (cardsDealt < cardsToDeal) then
            for i,player in ipairs(allPlayers) do
                drawCards(player.hand,1,i)
            end
            cardsDealt = cardsDealt + 1
            if (cardsDealt == cardsToDeal) then
                finishedDraw()
                doneDealing = true
            end
        end

        if (gameState == 1) then
            if (currentPlayer ~= mainPlayer) then
                makeBet(currentPlayer)
                currentPlayer = currentPlayer + 1
                if (currentPlayer > numPlayers) then
                    currentPlayer = 1
                end
                if (currentPlayer == startingPlayer) then
                    gameState = 2
                end
            end     
        end

        if (gameState == 2) then
            if (currentPlayer ~= mainPlayer and waitingForNewTrick == false) then
                local cardToPlay = love.math.random(1,#allPlayers[currentPlayer].hand)
                allPlayers[currentPlayer].hand[cardToPlay]:playCard(currentPlayer,cardToPlay)
            end
        end
    end
end

function progressGame()
    if (waitingForNewTrick) then
        prepareForNewTrick()
    end
    if (waitingToStartTrick) then
        gameState = 2
        waitingToStartTrick = false
    end
end

function evaluatePlayedCards()
    local trump = ""
    if (currentCard > #allCards) then
        trump = ""
    else
        trump = allCards[currentCard].suit
    end

    winningCard = {playedCards[1].value,playedCards[1].suit,playedCards[1].player}

    for i,card in ipairs(playedCards) do
        if (winningCard[1] == "14") then
            goto continue
        elseif (winningCard[1] == "0" and card.value ~= "0") then
            winningCard = {card.value,card.suit,card.player}
        elseif (card.value == "14") then
            winningCard = {card.value,card.suit,card.player}
        elseif (card.value == "0") then
            goto continue
        elseif (card.suit == trump) then
            if (winningCard[2] ~= trump or tonumber(card.value) > tonumber(winningCard[1])) then
                winningCard = {card.value,card.suit,card.player}
            end
        elseif (card.suit == playedCards[1].suit and winningCard[2] ~= trump) then
            if (tonumber(card.value) > tonumber(winningCard[1])) then
                winningCard = {card.value,card.suit,card.player}
            end
        end
        ::continue::
    end
    allPlayers[winningCard[3]].tricks = allPlayers[winningCard[3]].tricks + 1 
    trickWinner = winningCard[3]
end

function prepareForNewTrick ()
    waitingForNewTrick = false
    clearPlayed()
    currentPlayer = trickWinner
    if (#allPlayers[mainPlayer].hand == 0) then
        endRound()
        startRound() 
    end
end

function endRound()
    for i,player in ipairs(allPlayers) do
        if (player.bet == player.tricks) then
            player.score = player.score + 20 + 10 * player.bet
        else
            player.score = player.score - 10 * math.abs(player.bet - player.tricks)
        end
    end
end

function makeBet(player)
    --[[
    HANDLE ONLINE GAME STUFF HERE
    ]]
    allPlayers[player].bet = love.math.random(0,roundNum)
end