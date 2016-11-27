local Spawner = {}

function Spawner:new(factory, yPos, xDirection)
    local newObj = {
        yPos = yPos or 100,
        xDirection = xDirection or 1,
        factory = factory
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
        item.x = item.x + item.speed * dt
        if self.xDirection == 1 and item.x > love.graphics.getWidth() then
            table.remove(self.items, 1)
        end

        if self.xDirection == -1 and item.x < -350 then
            table.remove(self.items, 1)
        end
    end

    if self.xDirection == 1 and self:hasRoomForAnotherLeft() then
        table.insert(self.items, self.factory(-350, self.yPos))
    end

    if self.xDirection == -1 and self:hasRoomForAnotherRight() then
        table.insert(self.items, self.factory(love.graphics.getWidth() + 350, self.yPos))
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

    if leftmostItemX > 350 then
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

    if rightMostItemX < love.graphics.getWidth() - 350 then
        return true
    else
        return false
    end
end

return Spawner
