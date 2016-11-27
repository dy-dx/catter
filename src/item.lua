local Item = {}

function Item:new(x, y, width, height, speed, drawFn)
    local newObj = {
        width = width,
        height = height,
        x = x or 0,
        y = y or 75,
        speed = speed or 200,
        drawFn = drawFn
    }
    self.__index = self
    return setmetatable(newObj, self)
end

function Item:draw()
    self.drawFn(self.x, self.y, self.width, self.height)
end

return Item
