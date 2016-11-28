local Spawner = Class:new()

function Spawner:init(factory, yPos, xDirection)
    self.yPos = yPos or 100
    self.xDirection = xDirection or 1
    self.factory = factory
    self:reset()
end

function Spawner:reset()
    self.items = {}
end

function Spawner:update(dt)

    if table.getn(self.items) > 30 then
        error("memory leak! " .. table.getn(self.items) .. " items in spawner")
    end

    for i, item in lume.ripairs(self.items) do
        -- item.x = item.x + item.speed * dt
        if self.xDirection == 1 and item.x > love.graphics.getWidth() then
            table.remove(self.items, i)
        elseif self.xDirection == -1 and item.x < -350 then
            table.remove(self.items, i)
        end
    end

    if self.xDirection == 1 and self:hasRoomForAnotherLeft() then
        lume.push(self.items, self.factory(-350, self.yPos))
    end

    if self.xDirection == -1 and self:hasRoomForAnotherRight() then
        lume.push(self.items, self.factory(love.graphics.getWidth() + 350, self.yPos))
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
