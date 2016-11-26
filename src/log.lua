local Log = {}

function Log:new(x, y, width, height, speed)
    local newObj = {
        width = width,
        height = height,
        x = x or 0,
        y = y or 75,
        speed = speed or 200
    }
    self.__index = self
    newObj = setmetatable(newObj, self)
    return newObj
end

function Log:drawLog()
    love.graphics.setColor(139, 69, 19)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    love.graphics.setColor(255, 255, 255)
end

return Log
