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
    if self.isFilled then
        love.graphics.setColor(255, 0, 0)
        love.graphics.circle('fill', self.x + self.width/2, self.y + self.height/2, self.width/4, self.height/3)
        love.graphics.setColor(255, 255, 255)
    end
end

return Slot
