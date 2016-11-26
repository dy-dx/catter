local Player = require 'player'
local LogSpawner = require 'logspawner'
local leonCat = nil

local screenWidth = love.graphics.getWidth()
local screenHeight = love.graphics.getHeight()

local river = {x = 0, y = 50, width = screenWidth, height = 250}
local logSpawners = {
    LogSpawner:new(80),
    LogSpawner:new(160),
    LogSpawner:new(240)
}

local gameOverFont = love.graphics.newFont(120)
local gameOverString = "Game Over"
local gameOverText = love.graphics.newText(gameOverFont, gameOverString)

local restartFont = love.graphics.newFont(20)
local restartString = "Press R to restart. Stop Killing my cat!!!!"
local restartText = love.graphics.newText(restartFont, restartString)

function love.load()
    local image = love.graphics.newImage("cat.jpg")
    leonCat = Player:new(image)
end

function love.keypressed(key)
    if key == 'r' then
        reset()
    end
end

function reset()
    leonCat:init()
    for i, logSpawner in ipairs(logSpawners) do
        logSpawner:init()
    end
end

function drawGameOver()
    love.graphics.draw(
        gameOverText,
        screenWidth / 2 - gameOverFont:getWidth(gameOverString) / 2,
        screenHeight / 2 - gameOverFont:getHeight(gameOverString) / 2
    )
    love.graphics.draw(
        restartText,
        screenWidth / 2 - restartFont:getWidth(restartString) / 2 ,
        screenHeight / 2 + gameOverFont:getHeight(gameOverString) / 2 + gameOverFont:getHeight(restartString) / 2
    )
end

function love.draw()
    love.graphics.setColor(0, 0, 255)
    love.graphics.rectangle('fill', river.x, river.y, river.width, river.height)

    love.graphics.setColor(255, 255, 255)
    for i, logSpawner in ipairs(logSpawners) do
        for i, log in ipairs(logSpawner.logs) do
            log:drawLog()
        end
    end

    if leonCat.isAlive then
        love.graphics.draw(leonCat.image, leonCat.x, leonCat.y)
    else
        drawGameOver()
    end
end

function checkIsWithin(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 >= x2 and
           y1 >= y2 and
           x1 + w1 <= x2 + w2 and
           y1 + h1 <=  y2 + h2
end

function checkCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and
         x2 < x1 + w1 and
         y1 < y2 + h2 and
         y2 < y1 + h1
end

function love.update(dt)
    leonCat:update(dt)
    for i, logSpawner in ipairs(logSpawners) do
        logSpawner:update(dt)
    end

    local isOnLog = false
    -- todo: not this
    for i, logSpawner in ipairs(logSpawners) do
        for i, log in ipairs(logSpawner.logs) do
            if checkCollision(leonCat.x, leonCat.y, leonCat.width, leonCat.height, log.x, log.y, log.width, log.height) then
                isOnLog = true
                break
            end
        end
    end
    local hasDrowned = not isOnLog and checkIsWithin(leonCat.x, leonCat.y, leonCat.width, leonCat.height, river.x, river.y, river.width, river.height)

    if hasDrowned then
        leonCat.isAlive = false
    end
end
