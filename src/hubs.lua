local Hubs = Class:new()
local Slot = require 'slot'
local screenWidth = love.graphics.getWidth()
local screenHeight = love.graphics.getHeight()
local SIDEOFFSET = 50
local SLOTWIDTH = 100
local SLOTSPACE = screenWidth - SIDEOFFSET*2 - SLOTWIDTH*5
local SLOTHEIGHT = 50
local SLOTSPACING = SLOTSPACE/4
local TOPOFFSET = 2

function slotSpace(num)
    return SLOTSPACING*num + SLOTWIDTH*num
end

function Hubs:init(x, y, width, height)
    self.x = x or 0
    self.y = y or 0
    self.width = width or screenWidth
    self.height = height or 50
    self:reset()
end

function Hubs:reset()
    self.slots = {Slot:new(SIDEOFFSET, TOPOFFSET, SLOTWIDTH, SLOTHEIGHT),
             Slot:new(SIDEOFFSET + slotSpace(1), TOPOFFSET, SLOTWIDTH, SLOTHEIGHT),
             Slot:new(SIDEOFFSET + slotSpace(2), TOPOFFSET, SLOTWIDTH, SLOTHEIGHT),
             Slot:new(SIDEOFFSET + slotSpace(3), TOPOFFSET, SLOTWIDTH, SLOTHEIGHT),
             Slot:new(SIDEOFFSET + slotSpace(4), TOPOFFSET, SLOTWIDTH, SLOTHEIGHT)}
end

function Hubs:drawHubs()
    love.graphics.setColor(0, 255, 0)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    love.graphics.setColor(255, 255, 255)
    for i, slot in ipairs(self.slots) do
        slot:drawSlot()
    end
end

function Hubs:AllSlotsFilled()
    for i, slot in ipairs(self.slots) do
        if not slot.isFilled then
          return false
        end
    end
    return true
end
return Hubs
