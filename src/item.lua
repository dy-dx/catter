local Item = Class:new()

function Item:init(x, y, width, height, speed, drawFn)
    self.x = x or 0
    self.y = y or 75
    self.width = width
    self.height = height
    self.speed = speed or 200
    self.drawFn = drawFn
end

function Item:draw()
    self.drawFn(self.x, self.y, self.width, self.height)
end

function Item:update(dt)
    self.x = self.x + self.speed * dt
end

return Item
