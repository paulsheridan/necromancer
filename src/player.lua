local player = {}

player.x = 100
player.y = 100
player.speed = 100
player.width = 16
player.height = 16

-- Mark a nearby NPC if player is close
function player:markNearbyNpc(npcs)
    for _, npc in ipairs(npcs) do
        if isNear(self, npc, 20) and not npc.marked then
            npc:mark()
            insertMarkedNpc(npc)
            return npc
        end
    end
    return nil
end

return player
