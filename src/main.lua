local Player = require 'player'
local leonCat = nil

function love.load()
    local image = love.graphics.newImage("cat.jpg")
    leonCat = Player:new(image)
end

function love.draw()
    love.graphics.draw(leonCat.image, leonCat.x, leonCat.y)
end

function love.update(dt)
    leonCat:update(dt)
end
