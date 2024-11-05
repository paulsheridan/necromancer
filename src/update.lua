local update = {}

-- Update game state
function update.updateGame(dt, player, npcs, cam, possessedNpc, gamePaused)
    -- Determine the controlled character
    local controlledCharacter = possessedNpc or player

    -- Movement controls
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

    -- Camera follows the controlled character
    cam:lookAt(controlledCharacter.x, controlledCharacter.y)

    -- NPC wandering logic
    npcs:update(dt)
end

return update
