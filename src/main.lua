--function love.draw()
--    love.graphics.print("Hello World", 400, 300)
--end

Player = {}

SPEED = 200
INITIAL_POSITION = { x = 300, y = 200 }
SOUND = 'meow'



function Player:new(image)
    imageWidth, imageHeight = image:getDimensions()
    newObj = {
        sound = SOUND,
        x = INITIAL_POSITION.x,
        y = INITIAL_POSITION.y,
        image = image,
        width = imageWidth,
        height = imageHeight
      }
    self.__index = self
    return setmetatable(newObj, self)
end

function Player:makeSound()
    print ('I AM A CAT HERE ME ' .. self.sound)
end


function love.load()
    image = love.graphics.newImage("cat.jpg")
    leonCat = Player:new(image)
end

function love.draw()
    love.graphics.draw(leonCat.image, leonCat.x, leonCat.y)
end

function love.update(dt)

    distance = dt * SPEED

    dimensionWidth, dimensionHeight = love.graphics.getDimensions()
    print ("dimensionHeight = " .. dimensionHeight)
    print ("dimensionWidth = " .. dimensionWidth)
    print ("leon cat is " .. leonCat.x .. ", " .. leonCat.y);

    if love.keyboard.isDown("up") then
        newY = leonCat.y - distance;
        if leonCat.y >= 0 then
          leonCat.y = newY
        end
    end
    if love.keyboard.isDown("down") then
        newY = leonCat.y + distance;
        if leonCat.y + leonCat.height <= dimensionHeight then
          leonCat.y = newY
        end
    end
    if love.keyboard.isDown("left") then
        newX = leonCat.x - distance;

        if leonCat.x >= 0 then
          leonCat.x = newX
        end
    end
    if love.keyboard.isDown("right") then
        newX = leonCat.x + distance;

        if leonCat.x + leonCat.width <= dimensionWidth then
          leonCat.x = newX
        end
    end
end
