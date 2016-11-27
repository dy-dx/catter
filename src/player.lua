local Player = {}

local BLOCK_SIZE = 64
local BLOCK_W = 64
local BLOCK_H = 50
local yBlockOffset = (BLOCK_H - 44) / 2
local MAX_Y = BLOCK_H * 12 + yBlockOffset
local INITIAL_POSITION = { x = BLOCK_W * 7, y = MAX_Y }
local SOUND = 'meow'

function Player:new(image)
    local imageWidth, imageHeight = image:getDimensions()
    local newObj = {
        sound = SOUND,
        image = image,
        width = imageWidth,
        height = imageHeight
    }
    self.__index = self
    newObj = setmetatable(newObj, self)
    newObj:init()
    return newObj
end

function Player:init()
    self.x = INITIAL_POSITION.x
    self.y = INITIAL_POSITION.y
    self.isAlive = true
    self.timeSinceMoved = math.huge
    self.moveTimeout = 0.25
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

    local dimensionWidth, dimensionHeight = love.graphics.getDimensions()

    self.x = math.max(0, self.x)
    self.x = math.min(dimensionWidth - self.width, self.x)
    self.y = math.max(0, self.y)
    self.y = math.min(MAX_Y, self.y)
end

return Player
