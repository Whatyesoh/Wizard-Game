Game = {}

function Game:new (arguments)
    local game = {}
    setmetatable(game,{__index = self})
    
    game.name = arguments.name
    game.cards = arguments.cards or {}
    game.handLocs = arguments.handLocs or {}
    game.playedLocs = arguments.playedLocs or {}
    game.deckLocs = arguments.deckLocs or {}
    game.players = arguments.players or {}
    game.buttons = arguments.buttons or {}
    game.usesCards = arguments.usesCards or true
    game.cardSize = arguments.cardSize or 1
    game.active = false
    game.players = {}
    game.gameActions = {}

    game.update = arguments.update or emptyUpdate
    game.mousePress = arguments.mousePress or emptyMousePress
    game.mouseRelease = arguments.mouseRelease or emptyMouseRelease
    game.draw = arguments.draw or emptyDraw

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