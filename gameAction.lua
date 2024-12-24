GameAction = {}

function GameAction:new (arguments)
    local gameAction = {}
    setmetatable(gameAction,{__index = self})
    
    gameAction.game = arguments.game or {}
    gameAction.waitTime = arguments.waitTime or 1
    gameAction.timer = 0
    gameAction.wait = 0
    gameAction.execute = arguments.execute or emptyGameActionExecute
    gameAction.check = arguments.check or emptyGameActionCheck
    gameAction.start = false

    table.insert(gameAction.game.gameActions,gameAction)

    return gameAction
end

function emptyGameActionExecute(game)
    print("implement gameAction execute function")
end

function emptyGameActionCheck(game)
    return true
end

function GameAction:update(dt, game)
    if (self.wait > 0) then
        self.wait = self.wait - dt
        if (self.wait <= 0) then
            self.wait = 0
        end
        return
    end
    if (self.timer <= 0) then
        if (self.start) then
            if (self.check(game)) then
                self.timer = self.waitTime
                self.start = false
            end
        end
        return
    end    
    self.timer = self.timer - dt
    if (self.timer <= 0) then
        self.execute(game)
    end
end