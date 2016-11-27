-- https://love2d.org/wiki/Config_Files
function love.conf(t)
    t.modules.joystick = false
    t.modules.physics = false
    t.window.title = "Catter"
    t.window.width = 896
    t.window.height = 700
end
