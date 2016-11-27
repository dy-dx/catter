local Slot = require 'slot'
local Hubs = {}
local screenWidth = love.graphics.getWidth()
local screenHeight = love.graphics.getHeight()
local SLOTWIDTH = 90
local SLOTHEIGHT = 50
local SLOTSPACING = 190
local LEFTOFFSET = 20
local TOPOFFSET = 2

function Hubs:new(x, y, width, height)
    local newObj = {
      x = x or 0,
      y = y or 0,
      width = width or screenWidth,
      height = height or 50
    }
    self.__index = self
    newObj = setmetatable(newObj, self)
    newObj:init()
    return newObj
end

function Hubs:init()
    self.slots = {Slot:new(LEFTOFFSET, TOPOFFSET, SLOTWIDTH, SLOTHEIGHT),
             Slot:new(LEFTOFFSET + SLOTSPACING, TOPOFFSET, SLOTWIDTH, SLOTHEIGHT),
             Slot:new(LEFTOFFSET + SLOTSPACING*2, TOPOFFSET, SLOTWIDTH, SLOTHEIGHT),
             Slot:new(LEFTOFFSET + SLOTSPACING*3, TOPOFFSET, SLOTWIDTH, SLOTHEIGHT),
             Slot:new(LEFTOFFSET + SLOTSPACING*4, TOPOFFSET, SLOTWIDTH, SLOTHEIGHT)}
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
