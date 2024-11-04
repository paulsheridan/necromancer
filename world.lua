local world = {}
world.markedNpcs = {} -- Store marked NPCs

-- Bush setup
world.bush = {
    x = 200,
    y = 200,
    width = 32,
    height = 32
}

-- NPC setup
world.npcs = {}
local numNpcs = 6

-- Spawn NPCs
function world.spawnNpcs()
    for i = 1, numNpcs do
        local npc = {
            x = math.random(50, 400),
            y = math.random(50, 400),
            speed = 50,
            width = 16,
            height = 16,
            direction = "down",
            moveTimer = 0,
            moveInterval = 2,
            color = { 0, 0, 1 }
        }
        table.insert(world.npcs, npc)
    end
end

-- Helper function to check if an NPC is marked
function world.isNpcMarked(npc)
    for _, markedNpc in ipairs(world.markedNpcs) do
        if markedNpc == npc then
            return true
        end
    end
    return false
end

-- Drawing function to render NPCs with appropriate colors
function world.drawWorld(markedNpc, possessedNpc)
    for _, npc in ipairs(world.npcs) do
        if world.isNpcMarked(npc) then
            love.graphics.setColor(1, 1, 0) -- Yellow for marked NPCs
        else
            love.graphics.setColor(0, 0, 1) -- Blue for unmarked NPCs
        end
        love.graphics.rectangle("fill", npc.x, npc.y, npc.width, npc.height)
    end

    -- Draw other world elements...
    love.graphics.setColor(1, 1, 1) -- Reset color for other elements
    -- Additional drawing for other elements like bushes, player, etc.
end

-- Mark a nearby NPC if player is close
function world.markNearbyNpc(player)
    for _, npc in ipairs(world.npcs) do
        if isNear(player, npc, 20) and not world.isNpcMarked(npc) then
            table.insert(world.markedNpcs, npc)
            return npc
        end
    end
    return nil
end

-- Check proximity
function isNear(entity1, entity2, distance)
    local dx = entity1.x - entity2.x
    local dy = entity1.y - entity2.y
    return (dx * dx + dy * dy) <= (distance * distance)
end

return world
