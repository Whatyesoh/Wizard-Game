function setupScreen()
    resolution = {600,400}
    screenResolution = {screenWidth,screenHeight}
    scalingFactor = math.min(screenWidth/resolution[1],screenHeight/resolution[2])
    usableResolution = {resolution[1] * scalingFactor, resolution[2] * scalingFactor}
    pixelSize = scalingFactor

    barWidth = (screenWidth-usableResolution[1])/2
    barHeight = (screenHeight-usableResolution[2])/2
    barWidth = barWidth - barWidth % pixelSize
    barHeight = barHeight - barHeight % pixelSize

    if (shadowShader:hasUniform("pixelSize")) then
        shadowShader:send("pixelSize",pixelSize)
    end
    if (shadowShader:hasUniform("barWidth")) then
        shadowShader:send("barWidth",barWidth)
    end
    if (shadowShader:hasUniform("barHeight")) then
        shadowShader:send("barHeight",barHeight)
    end

    fontScale = 98
    pixelFont = love.graphics.newFont(pixelFontFile,pixelSize*fontScale/6)
    pixelFont:setFilter("nearest", "nearest")
    pixelFontBig = love.graphics.newFont(pixelFontFile,1.5 * pixelSize*fontScale/6)

    roundSquare = love.graphics.newImage("assets/roundSquare.png")
    roundSquareFill = love.graphics.newImage("assets/roundSquareFill.png")
end

function pixelAdjusted(x,y)
    newX = (x - screenWidth/2) / (screenWidth / usableResolution[1]) + screenWidth/2
    newY = (y - screenHeight/2) / (screenHeight / usableResolution[2]) + screenHeight/2 
    newX = newX - newX % pixelSize + pixelSize/2
    newY = newY - newY % pixelSize + pixelSize/2
    return 2*x-newX,2*y-newY
end

function adjustTransform(x,y,width,height)
    newX = (x - screenWidth/2) / (screenWidth / usableResolution[1]) + screenWidth/2
    newY = (y - screenHeight/2) / (screenHeight / usableResolution[2]) + screenHeight/2
    newX = newX - newX % pixelSize + pixelSize/2
    newY = newY - newY % pixelSize + pixelSize/2
    width = width or 0
    height = height or 0
    newWidth = width - width % pixelSize
    newHeight = height - height % pixelSize
    return newX,newY,newWidth,newHeight
end

function perfectRect(style,x,y,width,height)
    x,y,width,height = adjustTransform(x,y,width,height)
    love.graphics.setLineWidth(pixelSize*1.5)
    love.graphics.rectangle(style,x,y,newWidth,newHeight)
end

function perfectRoundSquare(style,x,y,width,height)
    x,y,width,height = adjustTransform(x,y,width,height)
    local square
    if (style == "line") then
        square = roundSquare
    else 
        square = roundSquareFill
    end
    love.graphics.draw(square,x,y,0,width/100,height/100)
end

function perfectPrint(text,x,y)
    x,y,width,height = adjustTransform(x,y)
    love.graphics.print(text,x,y,0,1,1)
end

function perfectDraw(drawObject,x,y,rotation,width,height)
    x,y= adjustTransform(x,y)
    love.graphics.draw(drawObject,x,y,rotation,width,height)
end

function clearToResolution()
    love.graphics.clear(0,1,0,1)
    love.graphics.setColor(.2,.3,.4,1)
    love.graphics.rectangle("fill",barWidth,barHeight,screenWidth - barWidth,screenHeight - barHeight)
end

function cutoffBars()
    love.graphics.setColor(0,0,0,1)
    if (screenResolution[1] == usableResolution[1]) then
        love.graphics.rectangle("fill",0,0,screenWidth,barHeight)
        love.graphics.rectangle("fill",0,screenHeight-barHeight,screenWidth,barHeight)
    else
        love.graphics.rectangle("fill",0,0,barWidth,screenHeight)
        love.graphics.rectangle("fill",screenWidth-barWidth,0,barWidth,screenHeight)
    end
end