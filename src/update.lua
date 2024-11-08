local update = {}

-- Update game state
function update.updateGame(dt)
    npcs:update(dt)
    updateControlledCharacter(dt)
    player:update(dt)
    world:update(dt)
    cam:update(dt)
end

return update
