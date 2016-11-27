local Player = require 'player'
local Hubs = require 'hubs'
local Spawner = require 'spawner'
local Item = require 'item'

local BLOCK_W = 64
local BLOCK_H = 50

local screenWidth = 14 * BLOCK_W
local screenHeight = 14 * BLOCK_H
local PADDING = 2
local leonCat = nil

function row(num)
    return BLOCK_H * (num - 1)
end

function blockWidth(num)
    return BLOCK_W * num
end

-- environment
local river = {x = 0, y = BLOCK_H, width = screenWidth, height = BLOCK_H * 5}
local hubs = Hubs:new(0, 0, screenWidth, BLOCK_H)

function logDisplay(x, y, width, height)
    love.graphics.setColor(139, 69, 19)
    love.graphics.rectangle('fill', x + PADDING, y, width, height - PADDING * 2)
    love.graphics.setColor(255, 255, 255)
end

function carDisplay(x, y, width, height)
    local padding = 2
    love.graphics.setColor(0, 255, 0)
    love.graphics.rectangle('fill', x + PADDING, y, width, height - PADDING * 2)
    love.graphics.setColor(255, 255, 255)
end

function ItemFactory(width, height, speed, displayFn)
    return function(x, y)
        return Item:new(x, y, width, height, speed, displayFn)
    end
end

local logSpawners = {
    Spawner:new(ItemFactory(blockWidth(4), BLOCK_H, 400, logDisplay), row(2)),
    Spawner:new(ItemFactory(blockWidth(7), BLOCK_H, -350, logDisplay), row(3), -1),
    Spawner:new(ItemFactory(blockWidth(6), BLOCK_H, 275, logDisplay), row(4)),
    Spawner:new(ItemFactory(blockWidth(7), BLOCK_H, -225, logDisplay), row(5), -1),
    Spawner:new(ItemFactory(blockWidth(6), BLOCK_H, 325, logDisplay), row(6))
}

local carSpawners = {
    Spawner:new(ItemFactory(blockWidth(4), BLOCK_H, -425, carDisplay), row(8), -1),
    Spawner:new(ItemFactory(blockWidth(2), BLOCK_H, 500, carDisplay), row(9)),
    Spawner:new(ItemFactory(blockWidth(3), BLOCK_H, -375, carDisplay), row(10), -1),
    Spawner:new(ItemFactory(blockWidth(4), BLOCK_H, 250, carDisplay), row(11)),
    Spawner:new(ItemFactory(blockWidth(2), BLOCK_H, -300, carDisplay), row(12), -1)
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
    local image = love.graphics.newImage("cat64x44.jpg")
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
    -- safe areas
    love.graphics.setColor(148, 0, 211)
    love.graphics.rectangle('fill', 0, BLOCK_H * 6, screenWidth, BLOCK_H)
    love.graphics.rectangle('fill', 0, BLOCK_H * 12, screenWidth, BLOCK_H)
    -- highway
    love.graphics.setColor(100, 100, 100)
    love.graphics.rectangle('fill', 0, BLOCK_H * 7, screenWidth, BLOCK_H * 5)
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

    if leonCat.isInSlot then
        leonCat:init()
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

function checkInSlot(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 >= x2 and
           y1 >= y2 and
           x1 + w1 <= x2 + w2 and
           y1 + h1 <= y2 + h2

end
function love.update(dt)
    local isOnLog = false
    local occupiedLog = nil
    -- The order of these statements matters!

    leonCat:handleInput(dt)

    for i, slot in ipairs(hubs.slots) do
        if checkInSlot(leonCat.x, leonCat.y, leonCat.width, leonCat.height, slot.x, slot.y, slot.width, slot.height) then
            leonCat.isInSlot = true
            slot.isFilled = true
            break
        end
    end

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
