local Slot = require 'slot'
local Hubs = {}
local SLOTWIDTH = 80
local SLOTHEIGHT = 47
local SLOTSPACING = 170
local LEFTOFFSET = 15
local TOPOFFSET = 5
local screenWidth = love.graphics.getWidth()
local screenHeight = love.graphics.getHeight()

function Hubs:new(x, y, width, height)
    local newObj = {
      x = x or 0,
      y = y or 0,
      width = width or screenWidth,
      height = height or 50,
      slots = {Slot:new(LEFTOFFSET, TOPOFFSET, SLOTWIDTH, SLOTHEIGHT),
               Slot:new(LEFTOFFSET + SLOTSPACING, TOPOFFSET, SLOTWIDTH, SLOTHEIGHT),
               Slot:new(LEFTOFFSET + SLOTSPACING*2, TOPOFFSET, SLOTWIDTH, SLOTHEIGHT),
               Slot:new(LEFTOFFSET + SLOTSPACING*3, TOPOFFSET, SLOTWIDTH, SLOTHEIGHT),
               Slot:new(LEFTOFFSET + SLOTSPACING*4, TOPOFFSET, SLOTWIDTH, SLOTHEIGHT)}
    }
    self.__index = self
    newObj = setmetatable(newObj, self)
    return newObj
end

function Hubs:drawHubs()
    love.graphics.setColor(0, 255, 0)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    love.graphics.setColor(255, 255, 255)
    for i, slot in ipairs(self.slots) do
        slot:drawSlot()
    end
end

function Hubs:fillSlots()
    for i, slot in ipairs(self.slots) do
        slot:fillSlot()
    end
end


return Hubs
