local Player = {}

local SPEED = 200
local INITIAL_POSITION = { x = 350, y = 520 }
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
end

function Player:makeSound()
    print ('I AM A CAT HERE ME ' .. self.sound)
end

function Player:update(dt, occupiedLog)
    local distance = dt * SPEED
    if occupiedLog ~= nil then
        self.x = self.x + occupiedLog.speed * dt
    end
    local dimensionWidth, dimensionHeight = love.graphics.getDimensions()

    if love.keyboard.isDown("up") then
        self.y = self.y - distance;
    end
    if love.keyboard.isDown("down") then
        self.y = self.y + distance;
    end
    if love.keyboard.isDown("left") then
        self.x = self.x - distance;
    end
    if love.keyboard.isDown("right") then
        self.x = self.x + distance
    end

    self.x = math.max(0, self.x)
    self.x = math.min(dimensionWidth - self.width, self.x)
    self.y = math.max(0, self.y)
    self.y = math.min(dimensionHeight - self.height, self.y)
end

return Player
