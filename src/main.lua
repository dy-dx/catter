local Player = require 'player'
local Hubs = require 'hubs'
local Spawner = require 'spawner'
local leonCat = nil

local Log = require 'log'
local Car = require 'car'

local screenWidth = love.graphics.getWidth()
local screenHeight = love.graphics.getHeight()

-- environment
local river = {x = 0, y = 50, width = screenWidth, height = 250}
local hubs = Hubs:new()

local logSpawners = {
    Spawner:new(Log, 80),
    Spawner:new(Log, 160, -1),
    Spawner:new(Log, 240)
}

local carSpawners = {
    Spawner:new(Car, 360, -1),
    Spawner:new(Car, 440),
    Spawner:new(Car, 520, -1)
}

function tableConcat(t1, t2)
    both = {}
    for i=1,#t1 do
        both[#both+1] = t1[i]
    end

    for i=1,#t2 do
        both[#both+1] = t2[i]
    end
    return both
end

local allSpawners = tableConcat(logSpawners, carSpawners)

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
    for i, spawner in ipairs(allSpawners) do
        spawner:init()
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
    hubs:drawHubs()
    love.graphics.setColor(255, 255, 255)

    for i, spawner in ipairs(allSpawners) do
        for i, item in ipairs(spawner.items) do
            item:draw()
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
    local isOnLog = false
    local occupiedLog = nil

    -- The order of these statements matters!

    leonCat:handleInput(dt)

    -- todo: not this
    for i, logSpawner in ipairs(logSpawners) do
        for i, log in ipairs(logSpawner.items) do
            if checkCollision(leonCat.x, leonCat.y, leonCat.width, leonCat.height, log.x, log.y, log.width, log.height) then
                isOnLog = true
                occupiedLog = log
                break
            end
        end
        if isOnLog then
            break
        end
    end

    for i, carSpawner in ipairs(carSpawners) do
        for i, car in ipairs(carSpawner.items) do
            if checkCollision(leonCat.x, leonCat.y, leonCat.width, leonCat.height, car.x, car.y, car.width, car.height) then
                leonCat.isAlive = false
                break
            end
        end
    end

    leonCat:update(dt, occupiedLog)
    for i, spawner in ipairs(allSpawners) do
        spawner:update(dt)
    end

    local hasDrowned = not isOnLog and checkIsWithin(leonCat.x, leonCat.y, leonCat.width, leonCat.height, river.x, river.y, river.width, river.height)

    if hasDrowned then
        leonCat.isAlive = false
    end
end
