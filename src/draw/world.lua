-- src/draw/world.lua
local worldDraw = {}

function worldDraw.draw()
    -- world/map
    if gameMap then
        gameMap:draw()
    end

    -- body part pickups
    if bodyParts then
        for _, pickup in ipairs(bodyParts) do
            pickup:draw()
        end
    end

    -- monsters
    if monsters then
        for _, monster in ipairs(monsters) do
            monster:draw()
        end
    end

    -- npcs
    if npcs then
        for _, npc in ipairs(npcs) do
            if npc.draw then
                npc:draw()
            end
        end
    end

    -- player
    if player and player.draw then
        player:draw()
    end
end

return worldDraw
