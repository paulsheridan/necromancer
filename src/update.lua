local update = {}

-- Update game state
function update.updateGame(dt, player, npcs, cam, possessedNpc, gamePaused)
    local controlledCharacter = possessedNpc or player

    if love.keyboard.isDown("right") then
        controlledCharacter.x = controlledCharacter.x + controlledCharacter.speed * dt
    elseif love.keyboard.isDown("left") then
        controlledCharacter.x = controlledCharacter.x - controlledCharacter.speed * dt
    end
    if love.keyboard.isDown("down") then
        controlledCharacter.y = controlledCharacter.y + controlledCharacter.speed * dt
    elseif love.keyboard.isDown("up") then
        controlledCharacter.y = controlledCharacter.y - controlledCharacter.speed * dt
    end

    cam:lookAt(controlledCharacter.x * scale, controlledCharacter.y * scale)
    npcs:update(dt, possessedNpc)
end

return update
