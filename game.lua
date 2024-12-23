Game = {}

function Game:new (name, cards, handLocs, playedLocs, players, buttons, usesCards, cardSize, update, mousePress, mouseRelease, draw)
    local game = {}
    setmetatable(game,{__index = self})
    
    game.name = name
    game.cards = cards or {}
    game.handLocs = handLocs or {}
    game.playedLocs = playedLocs or {}
    game.players = players or {}
    game.buttons = buttons or {}
    game.usesCards = usesCards or true
    game.cardSize = cardSize or 1
    game.active = false

    game.update = update or emptyUpdate
    game.mousePress = mousePress or emptyMousePress
    game.mouseRelease = mouseRelease or emptyMouseRelease
    game.draw = draw or emptyDraw

    return game
end

function Game:checkButtons()
    for i,button in ipairs(self.buttons) do
        button.buttonCheck(button)
    end
end

function Game:drawButtons()
    for i,button in ipairs(self.buttons) do
        button.draw(button)
    end
end

function emptyUpdate(dt, game)
    print("missing update function for: "..game.name)
end

function emptyMousePress(x, y, buttonPressed, game)
    print("missing mouse press function for: "..game.name)
end

function emptyMouseRelease(x, y, buttonPressed, game)
    print("missing mouse release function for: "..game.name)
end

function emptyDraw(game)
    print("missing draw function for: "..game.name)
end