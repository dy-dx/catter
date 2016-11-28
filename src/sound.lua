local meow = love.audio.newSource('CatMeow-SoundBible.com-1453940411.mp3')
local roar = love.audio.newSource('Lion-SoundBible.com-621763115.wav')
local hitCat = love.audio.newSource('CatMeow-SoundBible.com-1977450526.mp3')

function randomInt(num)
    return math.floor(math.random(1, num) - 1)
end

local catSounds = { meow1, meow2 }

Signal.register('meow', function ()
    if randomInt(5) == 0 then meow:play() end
end)

Signal.register('roar', function ()
    roar:play()
end)

Signal.register('hit', function ()
    hitCat:play()
end)
