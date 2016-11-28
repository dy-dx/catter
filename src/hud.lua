local Hud = Class:new()

function Hud:init()
    self.livesFont = love.graphics.newFont(22)
    self.godFont = love.graphics.newFont(22)
    self.godString = 'GOD MODE'
    self.godText = love.graphics.newText(self.godFont, self.godString)
    self:reset()
end

function Hud:reset()
    self.isGodMode = false
end

function Hud:updateLives(lives)
    self.livesString = "Lives: " .. lives
    self.livesText = love.graphics.newText(self.livesFont, self.livesString)
end

function Hud:setGodMode(isGodMode)
    self.isGodMode = isGodMode
end

function Hud:draw()
    local screenHeight = love.graphics.getHeight()
    local screenWidth = love.graphics.getWidth()
    love.graphics.draw(
        self.livesText,
        12,
        screenHeight - self.livesFont:getHeight(self.livesString) - 12
    )
    if self.isGodMode then
        love.graphics.draw(
            self.godText,
            screenWidth - self.godFont:getWidth(self.godString) - 12,
            screenHeight - self.godFont:getHeight(self.godString) - 12
        )
    end
end

return Hud
