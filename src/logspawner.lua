local Log = require 'log'

local LogSpawner = {}

function LogSpawner:new(yPos, xDirection)
    local newObj = {
        yPos = yPos or 100,
        xDirection = xDirection or 1
    }
    self.__index = self
    newObj = setmetatable(newObj, self)
    newObj:init()
    return newObj
end

function LogSpawner:init()
    self.logs = {}
end

function LogSpawner:update(dt)
    for i, log in ipairs(self.logs) do
        log.x = log.x + log.speed * dt * self.xDirection
        -- Todo: spawn from the right if direction is negative
        if log.x > love.graphics.getWidth() then
            table.remove(self.logs, 1)
        end
    end

    if self:hasRoomForAnother() then
        -- Todo: spawn from the right if direction is negative
        local log = Log:new(-100, self.yPos, 100, 33)
        table.insert(self.logs, log)
    end
end

function LogSpawner:hasRoomForAnother()
    if table.getn(self.logs) == 0 then
        return true
    end

    -- Todo: spawn from the right if direction is negative
    leftmostLogX = math.huge
    for i, log in ipairs(self.logs) do
        leftmostLogX = math.min(leftmostLogX, log.x)
    end
    if leftmostLogX > 200 then
        return true
    else
        return false
    end
end

return LogSpawner
