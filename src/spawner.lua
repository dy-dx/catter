local Spawner = {}

function Spawner:new(type, yPos, xDirection)
    local newObj = {
        yPos = yPos or 100,
        xDirection = xDirection or 1
    }
    self.type = type
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
        -- Todo: spawn from the right if direction is negative
        if item.x > love.graphics.getWidth() then
            table.remove(self.items, 1)
        end
    end

    if self:hasRoomForAnother() then
        -- Todo: spawn from the right if direction is negative
        local item = self.type:new(-100, self.yPos, 100, 33)
        table.insert(self.items, item)
    end
end

function Spawner:hasRoomForAnother()
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

return Spawner
