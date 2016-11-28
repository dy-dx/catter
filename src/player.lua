local Player = Class:new()

local BLOCK_SIZE = 64
local BLOCK_W = 64
local BLOCK_H = 50
local yBlockOffset = (BLOCK_H - 44) / 2
local MAX_Y = BLOCK_H * 12 + yBlockOffset
local INITIAL_POSITION = { x = BLOCK_W * 7, y = MAX_Y }
local SOUND = 'meow'

local MOVE_TIMEOUT = 0.15

function Player:init(image)
    local imageWidth, imageHeight = image:getDimensions()
    self.image = image
    self.width = imageWidth
    self.height = imageHeight
    self.SOUND = SOUND
    self.moveTimer = Timer.new()
    self:reset()
end

function Player:reset()
    self.x = INITIAL_POSITION.x
    self.y = INITIAL_POSITION.y
    self.isAlive = true -- sould not be changed externally
    self.isInSlot = false
    self.isGod = false
    self._isMoving = false
    self.moveTimer:clear()
end

function Player:canMove()
    return not self._isMoving
end

function Player:makeSound()
    print ('I AM A CAT HERE ME ' .. self.sound)
end

function Player:move(xDir, yDir)
    if not self:canMove() then
        return false
    end

    self._isMoving = true
    self.moveTimer:clear()
    self.moveTimer:tween(
        MOVE_TIMEOUT,
        self,
        { x = self.x + xDir*BLOCK_W, y = self.y + yDir*BLOCK_H },
        'in-out-quad',
        function() self._isMoving = false end
    )
    Signal.emit('meow')
end

-- shhh is ok
function Player:handleInput(dt)
    self.moveTimer:update(dt)

    if love.keyboard.isDown("up") then
        self:move(0, -1)
    elseif love.keyboard.isDown("down") then
        self:move(0, 1)
    elseif love.keyboard.isDown("left") then
        self:move(-1, 0)
    elseif love.keyboard.isDown("right") then
        self:move(1, 0)
    end
end

function Player:kill()
    if not self.isGod then
        self.isAlive = false
        Signal.emit('hit')
    end
end

function Player:update(dt, occupiedLog)
    if self:canMove() and occupiedLog ~= nil then
        self.x = self.x + occupiedLog.speed * dt
    end

    self.x = lume.clamp(self.x, 0, love.graphics.getWidth() - self.width)
    self.y = lume.clamp(self.y, 0, MAX_Y)
end

return Player
