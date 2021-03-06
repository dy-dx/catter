require 'class'
lume = require '../vendor/lume'
Timer = require '../vendor/hump.timer'
Signal = require '../vendor/hump.signal'

local Player = require 'player'
local Hubs = require 'hubs'
local Spawner = require 'spawner'
local Item = require 'item'
local Turtle = require 'turtle'
local Hud = require 'hud'
local Sound = require 'sound'

local hud = Hud:new()
local leonCat = nil
local isGameOver = nil
local isGameLost = nil
local isGameWon = nil

local BLOCK_W = 64
local BLOCK_H = 50

local screenWidth = 14 * BLOCK_W
local screenHeight = 14 * BLOCK_H
local PADDING = 4

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
    love.graphics.rectangle('fill', x, y + PADDING, width, height - PADDING * 2)
    love.graphics.setColor(255, 255, 255)
end

function carDisplay(x, y, width, height)
    local padding = 2
    love.graphics.setColor(0, 255, 0)
    love.graphics.rectangle('fill', x, y + PADDING, width, height - PADDING * 2)
    love.graphics.setColor(255, 255, 255)
end

function twoTurtleDisplay(x, y, width, height)
    local parts = width/5
    love.graphics.setColor(0, 255, 0)
    love.graphics.ellipse('fill', x, y + 25, parts*2, height/3)
    love.graphics.ellipse('fill', x + parts*4, y + 25, parts*2, height/3)
    love.graphics.setColor(255, 255, 255)
end

function threeTurtleDisplay(x, y, width, height)
    local parts = width/10
    love.graphics.setColor(0, 255, 0)
    love.graphics.ellipse('fill', x, y + 25, parts*2, height/3)
    love.graphics.ellipse('fill', x + parts*4, y + 25, parts*2, height/3)
    love.graphics.ellipse('fill', x + parts*8, y + 25, parts*2, height/3)
    love.graphics.setColor(255, 255, 255)
end

function ItemFactory(width, height, speed, displayFn)
    return function(x, y)
        return Item:new(x, y, width, height, speed, displayFn)
    end
end

function TurtleFactory(width, height, speed, displayFn)
    return function(x, y)
        return Turtle:new(x, y, width, height, speed, displayFn)
    end
end

local turtleSpawners = {
    Spawner:new(TurtleFactory(blockWidth(1), BLOCK_H, 350, twoTurtleDisplay), row(2)),
    Spawner:new(TurtleFactory(blockWidth(2), BLOCK_H, -250, threeTurtleDisplay), row(5), -1)
}

local logSpawners = {
    --Spawner:new(ItemFactory(blockWidth(4), BLOCK_H, 400, logDisplay), row(2)),
    Spawner:new(ItemFactory(blockWidth(7), BLOCK_H, -350, logDisplay), row(3), -1),
    Spawner:new(ItemFactory(blockWidth(6), BLOCK_H, 275, logDisplay), row(4)),
   -- Spawner:new(ItemFactory(blockWidth(7), BLOCK_H, -225, logDisplay), row(5), -1),
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
allSpawners = tableConcat(allSpawners, turtleSpawners)

local pausedFont = love.graphics.newFont(120)
local pausedString = "Paused"
local pausedText = love.graphics.newText(pausedFont, pausedString)

local gameOverFont = love.graphics.newFont(120)
local gameOverString = "Game Over"
local gameOverText = love.graphics.newText(gameOverFont, gameOverString)

local restartFont = love.graphics.newFont(20)
local restartString = "Press R to restart. Stop Killing my cat!!!!"
local restartText = love.graphics.newText(restartFont, restartString)

local youWinFont = love.graphics.newFont(120)
local youWinString = "YOU WIN"
local youWinText = love.graphics.newText(youWinFont, youWinString)

local paused = false

function love.load()
    local image = love.graphics.newImage("cat64x44.jpg")
    leonCat = Player:new(image)
    init()
end

function toggleGodMode()
    leonCat.isGod = not leonCat.isGod
    hud:setGodMode(leonCat.isGod)
end

function love.keypressed(key)
    if key == 'r' or key == 'space' then
        reset()
    end

    if key == 'g' then
        toggleGodMode()
    end

    if key == 'p' then
        paused = not paused
    end
end

function init()
    leonCat.lives = 9
    isGameOver = false
    isGameLost = false
    isGameWon = false
    hud:updateLives(leonCat.lives)
end

function reset()
    paused = false
    init()
    leonCat:reset()
    hubs:reset()
    for i, spawner in ipairs(allSpawners) do
        spawner:reset()
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

function drawYouWin()
    love.graphics.draw(
        youWinText,
        screenWidth / 2 - youWinFont:getWidth(youWinString) / 2,
        screenHeight / 2 - youWinFont:getHeight(youWinString) / 2
    )
end

function drawPaused()
    love.graphics.draw(
        pausedText,
        screenWidth / 2 - pausedFont:getWidth(pausedString) / 2,
        screenHeight / 2 - pausedFont:getHeight(pausedString) / 2
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

    love.graphics.draw(leonCat.image, leonCat.x, leonCat.y, leonCat.rotation, leonCat.scale, leonCat.scale)
    hud:draw(leonCat.lives)

    if isGameLost then
        drawGameOver()
    end

    if isGameWon then
        drawYouWin()
    end

    if paused then
        drawPaused()
    end
end

function xYWidthHeight(item)
    return item.x, item.y, item.width, item.height
end

function checkIsWithin(item1, item2)
    local x1, y1, w1, h1 = xYWidthHeight(item1)
    local x2, y2, w2, h2 = xYWidthHeight(item2)

    return x1 >= x2 and
           y1 >= y2 and
           x1 + w1 <= x2 + w2 and
           y1 + h1 <=  y2 + h2
end

function checkCollision(item1, item2)
    local x1, y1, w1, h1 = xYWidthHeight(item1)
    local x2, y2, w2, h2 = xYWidthHeight(item2)

    return x1 < x2 + w2 and
         x2 < x1 + w1 and
         y1 < y2 + h2 and
         y2 < y1 + h1
end

function love.update(dt)
    if paused then return end

    local isOnLog = false
    local occupiedLog = nil
    -- The order of these statements matters!

    Timer.update(dt)

    for i, slot in ipairs(hubs.slots) do
        if checkIsWithin(leonCat, slot) then
            if slot.isFilled then
                leonCat:kill()
            else
                leonCat.isInSlot = true
                slot.isFilled = true
                Signal.emit('roar')
            end
        end
    end

    if not leonCat.isInSlot and checkIsWithin(leonCat, hubs) then
        leonCat:kill()
    end

    -- todo: not this
    for i, logSpawner in ipairs(logSpawners) do
        for i, log in ipairs(logSpawner.items) do
            if checkCollision(leonCat, log) then
                isOnLog = true
                occupiedLog = log
                break
            end
        end
        if isOnLog then
            break
        end
    end

    for i, turtleSpawner in ipairs(turtleSpawners) do
        for i, turtle in ipairs(turtleSpawner.items) do
            if not turtle.isSubmerged and checkCollision(leonCat, turtle) then
                isOnLog = true
                occupiedLog = turtle
                break
            end
        end
        if isOnLog then
            break
        end
    end

    for i, carSpawner in ipairs(carSpawners) do
        for i, car in ipairs(carSpawner.items) do
            if checkCollision(leonCat, car) then
                leonCat:kill()
                break
            end
        end
    end

    leonCat:update(dt, occupiedLog)
    for i, spawner in ipairs(allSpawners) do
        for j, item in ipairs(spawner.items) do
            item:update(dt)
        end
    end
    for i, spawner in ipairs(allSpawners) do
        spawner:update(dt)
    end

    local hasDrowned = not isOnLog and checkIsWithin(leonCat, river)

    if hasDrowned then
        leonCat:kill()
    end

    if leonCat.isInSlot then
        leonCat:reset()
    end

    if hubs:AllSlotsFilled() then
        isGameWon = true
    end

    if not leonCat.isAlive and not isGameOver then
        hud:updateLives(leonCat.lives)
        if leonCat.lives <= 0 then
            isGameOver = true
            isGameLost = true
        end
    end
end
