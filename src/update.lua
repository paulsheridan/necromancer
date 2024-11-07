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
    player:update(dt)


    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()

    -- Left border
    if cam.x < w/2 then
        cam.x = w/2
    end

    -- Right border
    if cam.y < h/2 then
        cam.y = h/2
    end

    -- Get width/height of background
    local mapW = gameMap.width * gameMap.tilewidth
    local mapH = gameMap.height * gameMap.tileheight

    -- Right border
    if cam.x > (mapW - w/2) then
        cam.x = (mapW - w/2)
    end
    -- Bottom border
    if cam.y > (mapH - h/2) then
        cam.y = (mapH - h/2)
    end
end

return update
