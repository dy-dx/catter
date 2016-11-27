local Slot = {}

function Slot:new(x, y, width, height)
    local newObj = {
      x = x,
      y = y,
      width = width,
      height = height,
      isFilled = false
    }
    self.__index = self
    newObj = setmetatable(newObj, self)
    return newObj
end

function Slot:drawSlot()
    love.graphics.setColor(40, 50, 60)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    love.graphics.setColor(255, 255, 255)
    self:fillSlot()
end

function Slot:fillSlot()
    if self.isFilled then
        love.graphics.setColor(255, 0, 0)
        love.graphics.circle('fill', self.x + 40, self.y + 5, self.width/2, self.height/2)
        love.graphics.setColor(255, 255, 255)
    end
end

return Slot
