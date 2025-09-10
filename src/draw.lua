function drawBeforeCamera()
end

function drawCamera()
    if gameMap.layers["GroundLayer"] then
        gameMap:drawLayer(gameMap.layers["GroundLayer"])
    end
    if gameMap.layers["GroundCover"] then
        gameMap:drawLayer(gameMap.layers["GroundCover"])
    end
    if gameMap.layers["BuildingLayer"] then
        gameMap:drawLayer(gameMap.layers["BuildingLayer"])
    end
    if gameMap.layers["DoorWindowLayer"] then
        gameMap:drawLayer(gameMap.layers["DoorWindowLayer"])
    end
    -- draw assembly station
    love.graphics.setColor(0.2, 0.8, 0.2)
    love.graphics.rectangle("fill", assemblyStation.x, assemblyStation.y, assemblyStation.w, assemblyStation.h)
    love.graphics.setColor(1, 1, 1)

    player:draw()
    for _, npc in ipairs(npcs) do
        npc:draw()
    end
    if gameMap.layers["RoofLayer"] then
        gameMap:drawLayer(gameMap.layers["RoofLayer"])
    end
end

function drawAfterCamera()

end
