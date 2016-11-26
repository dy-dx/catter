local Player = require 'player'
local leonCat = nil

local screenWidth = love.graphics.getWidth()
local screenHeight = love.graphics.getHeight()

local river = {x = 0, y = 50, width = screenWidth, height = 100}

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
    love.graphics.setColor(0, 255, 0)
    love.graphics.rectangle('fill', river.x, river.y, river.width, river.height)

    love.graphics.setColor(255, 255, 255)

    if leonCat.isAlive then
        love.graphics.draw(leonCat.image, leonCat.x, leonCat.y)
    else
        drawGameOver() 
    end
end

function CheckCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and
         x2 < x1 + w1 and
         y1 < y2 + h2 and
         y2 < y1 + h1
end

function love.update(dt)
    leonCat:update(dt)
    
    local hasCollided = CheckCollision(leonCat.x, leonCat.y, leonCat.width, leonCat.height, river.x, river.y, river.width, river.height)
    
    if hasCollided then
        leonCat.isAlive = false
    end
end
