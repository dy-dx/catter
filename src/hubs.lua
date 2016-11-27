local Slot = require 'slot'
local Hubs = {}
local screenWidth = love.graphics.getWidth()
local screenHeight = love.graphics.getHeight()
local SIDEOFFSET = 50
local SLOTWIDTH = 100
local SLOTSPACE = screenWidth - SIDEOFFSET*2 - SLOTWIDTH*5
local SLOTHEIGHT = 50
local SLOTSPACING = SLOTSPACE/4
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
    self.slots = {Slot:new(SIDEOFFSET, TOPOFFSET, SLOTWIDTH, SLOTHEIGHT),
             Slot:new(SIDEOFFSET + SLOTSPACING + SLOTWIDTH, TOPOFFSET, SLOTWIDTH, SLOTHEIGHT),
             Slot:new(SIDEOFFSET + SLOTSPACING*2 + SLOTWIDTH*2, TOPOFFSET, SLOTWIDTH, SLOTHEIGHT),
             Slot:new(SIDEOFFSET + SLOTSPACING*3 + SLOTWIDTH*3, TOPOFFSET, SLOTWIDTH, SLOTHEIGHT),
             Slot:new(SIDEOFFSET + SLOTSPACING*4 + SLOTWIDTH*4, TOPOFFSET, SLOTWIDTH, SLOTHEIGHT)}
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
