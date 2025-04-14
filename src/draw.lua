function drawBeforeCamera()
end

function drawCamera()
    if gameMap.layers["Background"] then
        gameMap:drawLayer(gameMap.layers["Background"])
    end

    if gameMap.layers["Base"] then
        gameMap:drawLayer(gameMap.layers["Base"])
    end

    if gameMap.layers["Objects"] then
        gameMap:drawLayer(gameMap.layers["Objects"])
    end

    if gameMap.layers["Objects2"] then
        gameMap:drawLayer(gameMap.layers["Objects2"])
    end
    player:draw()
    for _, npc in ipairs(npcs) do
        npc.anim:draw(npc.spriteSheet, npc.x, npc.y - 2, nil, npc.dirX, 1, 9.5, 10.5)
    end
end

function drawAfterCamera()

end
