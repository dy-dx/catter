local Hud = Class:new()

function Hud:init()
    self.livesFont = love.graphics.newFont(22)
    self:reset()
end

function Hud:reset()
end

function Hud:updateLives(lives)
    self.livesString = "Lives: " .. lives
    self.livesText = love.graphics.newText(self.livesFont, self.livesString)
end

function Hud:draw()
    local screenHeight = love.graphics.getHeight()
    love.graphics.draw(
        self.livesText,
        12,
        screenHeight - self.livesFont:getHeight(self.livesString) - 12
    )
end

return Hud
