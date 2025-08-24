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
