function updateAll(dt)
    updateGame(dt)
end

function updateGame(dt)
    player:update(dt)
    monsters:update(dt)
    npcs:update(dt)
    updateControlledCharacter(dt)
    world:update(dt)
    cam:update(dt)
end
