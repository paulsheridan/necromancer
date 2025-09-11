-- src/draw/debug.lua
local debugDraw = {}

function debugDraw.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)
end

return debugDraw
