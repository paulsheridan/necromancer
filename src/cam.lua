Camera = require "libraries/hump/camera"
cam = Camera(0, 0)
cam.smoother = Camera.smooth.damped(8)

function cam:update(dt)
    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()

    -- Left border
    if cam.x < w / 2 then
        cam.x = w / 2
    end

    -- Right border
    if cam.y < h / 2 then
        cam.y = h / 2
    end

    -- Get width/height of background
    local mapW = gameMap.width * gameMap.tilewidth
    local mapH = gameMap.height * gameMap.tileheight

    -- Right border
    if cam.x > (mapW - w / 2) then
        cam.x = (mapW - w / 2)
    end
    -- Bottom border
    if cam.y > (mapH - h / 2) then
        cam.y = (mapH - h / 2)
    end
end
