local Spawner = {}

function Spawner:new(type, yPos, xDirection)
    local newObj = {
        yPos = yPos or 100,
        xDirection = xDirection or 1,
        type = type
    }
    self.__index = self
    newObj = setmetatable(newObj, self)
    newObj:init()
    return newObj
end

function Spawner:init()
    self.items = {}
end

function Spawner:update(dt)
    for i, item in ipairs(self.items) do
        item.x = item.x + item.speed * dt * self.xDirection
        if self.xDirection == 1 and item.x > love.graphics.getWidth() then
            table.remove(self.items, 1)
        end

        if self.xDirection == -1 and item.x < 0 then
            table.remove(self.items, 1)
        end
    end

    if self.xDirection == 1 and self:hasRoomForAnotherLeft() then
        -- Todo: spawn from the right if direction is negative
        table.insert(self.items, self.type:new(-100, self.yPos, 100, 33))
    end

    if self.xDirection == -1 and self:hasRoomForAnotherRight() then
        -- Todo: spawn from the right if direction is negative
        table.insert(self.items, self.type:new(love.graphics.getWidth() + 100, self.yPos, 100, 33))
    end
end

function Spawner:hasRoomForAnotherLeft()
    if table.getn(self.items) == 0 then
        return true
    end

    -- Todo: spawn from the right if direction is negative
    leftmostItemX = math.huge
    for i, item in ipairs(self.items) do
        leftmostItemX = math.min(leftmostItemX, item.x)
    end

    if leftmostItemX > 200 then
        return true
    else
        return false
    end
end

function Spawner:hasRoomForAnotherRight()
    if table.getn(self.items) == 0 then
        return true
    end

    -- Todo: spawn from the right if direction is negative
    rightMostItemX = -math.huge
    for i, item in ipairs(self.items) do
        rightMostItemX = math.max(rightMostItemX, item.x)
    end

    if rightMostItemX < love.graphics.getWidth() - 200 then
        return true
    else
        return false
    end
end

return Spawner
