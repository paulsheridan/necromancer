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
    for _, npc in ipairs(npcs) do
        if npc ~= possessedNpc then
            npc.moveTimer = npc.moveTimer + dt
            if npc.moveTimer >= npc.moveInterval then
                npc.moveTimer = 0
                local directions = { "up", "down", "left", "right" }
                npc.direction = directions[math.random(#directions)]
            end

            if npc.direction == "up" then
                npc.y = npc.y - npc.speed * dt
            elseif npc.direction == "down" then
                npc.y = npc.y + npc.speed * dt
            elseif npc.direction == "left" then
                npc.x = npc.x - npc.speed * dt
            elseif npc.direction == "right" then
                npc.x = npc.x + npc.speed * dt
            end
        end
    end
end

return update
