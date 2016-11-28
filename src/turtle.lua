local Turtle = Class:new()

function Turtle:init(x, y, radiusx, radiusy, speed, nturtles)
    self.x = x
    self.y = y
    self.radiusx = radiusx
    self.radiusy = radiusy
    self.nturtles = nturtles
    self:reset()
end

function Turtle:reset()
    self.isVisible = true
end

function Turtle:draw(x, y, radiusx, radiusy)
    parts = radiusx
    love.graphics.setColor(0, 255, 0)
    love.graphics.ellipse('fill', x, y, parts*2, radiusy)
    love.graphics.ellipse('fill', x + parts*4, y, parts*2, radiusy)
    love.graphics.setColor(255, 255, 255)
end

