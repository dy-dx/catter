local Turtle = Class:new()

-- function Turtle:init(x, y, radiusx, radiusy, speed, nturtles)
function Turtle:init(x, y, width, height, speed, drawFn)
    self.x = x
    self.y = y
    -- self.radiusx = radiusx
    -- self.radiusy = radiusy
    self.width = width
    self.height = height
    self.speed = speed or 200
    -- self.nturtles = nturtles
    self.drawFn = drawFn
    self.submergeTimer = Timer.new()
    self:reset()
end

function Turtle:reset()
    self.submergeTimer:clear()
    self:surface()
end

function Turtle:submerge()
    self.isSubmerged = true
    self.submergeTimer:after(
        1.5,
        function() self:surface() end
    )
end

function Turtle:surface()
    self.isSubmerged = false
    self.submergeTimer:after(
        2,
        function() self:submerge() end
    )
end

function Turtle:draw()
    if not self.isSubmerged then
        self.drawFn(self.x, self.y, self.width, self.height)
    end
end

function Turtle:update(dt)
    self.submergeTimer:update(dt)
    self.x = self.x + self.speed * dt
end

-- function Turtle:draw(x, y, radiusx, radiusy)
--     local parts = radiusx
--     love.graphics.setColor(0, 255, 0)
--     love.graphics.ellipse('fill', x, y, parts*2, radiusy)
--     love.graphics.ellipse('fill', x + parts*4, y, parts*2, radiusy)
--     love.graphics.setColor(255, 255, 255)
-- end

return Turtle
