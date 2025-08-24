function updateControlledCharacter(dt)
    controlledCharacter = possessedNpc or player

    local currentDirX = 0
    local currentDirY = 0

    if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
        controlledCharacter.dirX = 1
        currentDirX = 1
        controlledCharacter.x = controlledCharacter.x + controlledCharacter.speed * dt
    elseif love.keyboard.isDown("a") or love.keyboard.isDown("left") then
        controlledCharacter.dirX = -1
        currentDirX = -1
        controlledCharacter.x = controlledCharacter.x - controlledCharacter.speed * dt
    end
    if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
        controlledCharacter.dirY = 1
        currentDirY = 1
        controlledCharacter.y = controlledCharacter.y + controlledCharacter.speed * dt
    elseif love.keyboard.isDown("w") or love.keyboard.isDown("up") then
        controlledCharacter.dirY = -1
        currentDirY = -1
        controlledCharacter.y = controlledCharacter.y - controlledCharacter.speed * dt
    end

    if currentDirY == 1 then
        controlledCharacter.anim = controlledCharacter.animations.down
    elseif currentDirY == -1 then
        controlledCharacter.anim = controlledCharacter.animations.up
    elseif currentDirX == 1 then
        controlledCharacter.anim = controlledCharacter.animations.left
    elseif currentDirX == -1 then
        controlledCharacter.anim = controlledCharacter.animations.right
    end

    local vec = vector(currentDirX, currentDirY):normalized() * controlledCharacter.speed
    if vec.x ~= 0 or vec.y ~= 0 then
        controlledCharacter:setLinearVelocity(vec.x, vec.y)
    end

    if currentDirX == 0 and currentDirY == 0 then
        controlledCharacter.walking = false
        controlledCharacter:stop()
    else
        controlledCharacter.walking = true
    end

    controlledCharacter.anim:update(dt)
end
