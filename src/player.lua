local Player = Class:new()

local BLOCK_SIZE = 64
local BLOCK_W = 64
local BLOCK_H = 50
local yBlockOffset = (BLOCK_H - 44) / 2
local MAX_Y = BLOCK_H * 12 + yBlockOffset
local INITIAL_POSITION = { x = BLOCK_W * 7, y = MAX_Y }
local SOUND = 'meow'

function Player:init(image)
    local imageWidth, imageHeight = image:getDimensions()
    self.image = image
    self.width = imageWidth
    self.height = imageHeight
    self.SOUND = SOUND
    self:reset()
end

function Player:reset()
    self.x = INITIAL_POSITION.x
    self.y = INITIAL_POSITION.y
    self.isAlive = true
    self.isInSlot = false
    self.timeSinceMoved = 0
    self.moveTimeout = 0.15
end

function Player:makeSound()
    print ('I AM A CAT HERE ME ' .. self.sound)
end

-- shhh is ok
function Player:handleInput(dt)
    self.timeSinceMoved = self.timeSinceMoved + dt

    if self.timeSinceMoved >= self.moveTimeout then
        if love.keyboard.isDown("up") then
            self.y = self.y - BLOCK_H
            self.timeSinceMoved = 0
        elseif love.keyboard.isDown("down") then
            self.y = self.y + BLOCK_H
            self.timeSinceMoved = 0
        elseif love.keyboard.isDown("left") then
            self.x = self.x - BLOCK_W
            self.timeSinceMoved = 0
        elseif love.keyboard.isDown("right") then
            self.x = self.x + BLOCK_W
            self.timeSinceMoved = 0
        end
    end
end

function Player:update(dt, occupiedLog)
    if occupiedLog ~= nil then
        self.x = self.x + occupiedLog.speed * dt
    end

    self.x = lume.clamp(self.x, 0, love.graphics.getWidth() - self.width)
    self.y = lume.clamp(self.y, 0, MAX_Y)
end

return Player
