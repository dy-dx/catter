local Player = require 'player'
local leonCat = nil
local river = {x = 0, y = 50, width = love.graphics.getWidth(), height = 100}

function love.load()
    local image = love.graphics.newImage("cat.jpg")
    leonCat = Player:new(image)
end

function love.draw()
    love.graphics.setColor(0, 255, 0)
    love.graphics.rectangle('fill', river.x, river.y, river.width, river.height)
    love.graphics.setColor(255, 255, 255)
    if leonCat.isAlive then
        love.graphics.draw(leonCat.image, leonCat.x, leonCat.y)
    end
end

function CheckCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

function love.update(dt)
    leonCat:update(dt)
    local hasCollided = CheckCollision(leonCat.x, leonCat.y, leonCat.width, leonCat.height, river.x, river.y, river.width, river.height)
    if hasCollided then
        leonCat.isAlive = false
    end
end
