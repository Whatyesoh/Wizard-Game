allButtons = {}
Button = {x = 0, y = 0, width = 10, height = 10}

function Button:new (x, y, width, height, execute, text, visibility)
    local button = {}
    setmetatable(button,{__index = self})
    button.execute = execute or function ()
        print("implement a function for this button please")
    end
    button.text = text
    button.x = x
    button.y = y
    button.width = width
    button.height = height
    button.visibility = visibility or 1
    button.held = 0
    button.color = {1,1,1}
    table.insert(allButtons,button)
    return button
end

function checkMousePress(x, y, buttonPressed)
    x,y = pixelAdjusted(x,y)
    for i, button in ipairs(allButtons) do
        if (x >= button.x and x <= button.x + button.width and y >= button.y and y <= button.y + button.height and buttonPressed == 1 and button.visibility == 1) then
            button.held = 1
        end
    end
end

function checkMouseRelease(x,y,buttonPressed)
    for i, button in ipairs(allButtons) do
        if (button.held == 1) then
            button.held = 0
            button.execute()
        end
    end
end

function Button:setVisibility(vis)
    self.visibility = vis
end

function drawButtons()
    local x,y = love.mouse.getPosition()
    x,y = pixelAdjusted(x,y)
    for i, button in ipairs(allButtons) do
        if (button.visibility == 1) then
            local xOffset = pixelSize*2
            local yOffset = pixelSize*2

            love.graphics.setColor(0,.0,.0,.5)
            perfectRoundSquare("fill",button.x+xOffset,button.y+xOffset,button.width,button.height)
            if (button.held == 1) then
                love.graphics.setColor(.35*button.color[1],.35*button.color[2],.35*button.color[3],1)
                perfectRoundSquare("fill",button.x,button.y,button.width,button.height)
                love.graphics.setColor(button.color[1],button.color[2],button.color[3],.5)
                perfectRoundSquare("fill",button.x+xOffset*1.2,button.y+yOffset*1.2,button.width*.9,button.height*.9)
            elseif (x >= button.x and x <= button.x + button.width and y >= button.y and y <= button.y + button.height) then
                love.graphics.setColor(.7*button.color[1],.7*button.color[2],.7*button.color[3],1)
                perfectRoundSquare("fill",button.x,button.y,button.width,button.height)
                love.graphics.setColor(button.color[1],button.color[2],button.color[3],1)
                perfectRoundSquare("fill",button.x+2,button.y+2,button.width*.9,button.height*.9)
                love.graphics.setColor(.0,.0,.0,.5)
                perfectRoundSquare("fill",button.x,button.y,button.width,button.height)
            else
                love.graphics.setColor(.7*button.color[1],.7*button.color[2],.7*button.color[3],1)
                perfectRoundSquare("fill",button.x,button.y,button.width,button.height)
                love.graphics.setColor(button.color[1],button.color[2],button.color[3],1)
                perfectRoundSquare("fill",button.x+2,button.y+2,button.width*.9,button.height*.9)
            end

            love.graphics.setColor(0,0,0,1)
            perfectRoundSquare("line",button.x,button.y,button.width,button.height)
            love.graphics.setFont(pixelFontBig)
            local sizeW = pixelFontBig:getWidth(tostring(button.text))
            local sizeH = pixelFontBig:getHeight()
            local newX, newY, newWidth, newHeight = adjustTransform(0,0,button.width,button.height)
            perfectPrint(button.text,button.x + (newWidth - sizeW)/2,button.y+(newHeight-sizeH*.9))
        end
    end
end

function Button:sayHi()
    print(self.height)
end