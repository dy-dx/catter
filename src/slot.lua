local Slot = {}

function Slot:new(x, y, width, height)
    local newObj = {
      x = x,
      y = y,
      width = width,
      height = height
    }
    self.__index = self
    newObj = setmetatable(newObj, self)
    newObj:init()
    return newObj
end

function Slot:init()
    self.isFilled = false
end

function Slot:drawSlot()
    love.graphics.setColor(40, 50, 60)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    love.graphics.setColor(255, 255, 255)
end

return Slot
