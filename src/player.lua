local player = {}

player.x = 100
player.y = 100
player.speed = 90
player.width = 10
player.height = 16
player.dirX = 1
player.dirY = 1
player.prevDirX = 1
player.prevDirY = 1
player.animSpeed = 0.14
player.walking = false

player.spriteSheet = love.graphics.newImage('sprites/playerSheet.png')
player.grid = anim8.newGrid(19, 21, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())

player.animations = {}
player.animations.downRight = anim8.newAnimation(player.grid('1-2', 1), player.animSpeed)
player.animations.downLeft = anim8.newAnimation(player.grid('1-2', 1), player.animSpeed)
player.animations.upRight = anim8.newAnimation(player.grid('1-2', 2), player.animSpeed)
player.animations.upLeft = anim8.newAnimation(player.grid('1-2', 2), player.animSpeed)
player.animations.stopDown = anim8.newAnimation(player.grid('1-3', 6), 0.22,
    function() player.anim = player.animations.idleDown end)
player.animations.stopUp = anim8.newAnimation(player.grid('1-3', 7), 0.22,
    function() player.anim = player.animations.idleUp end)
player.animations.idleDown = anim8.newAnimation(player.grid('1-4', 8), { 1.2, 0.1, 2.4, 0.1 })
player.animations.idleUp = anim8.newAnimation(player.grid('1-2', 9), 0.22)

player.anim = player.animations.idleDown

function player:markNearbyNpc()
    for _, npc in ipairs(npcs) do
        if isNear(self, npc, 20) and not npc.marked then
            npc:mark()
            insertMarkedNpc(npc)
            return npc
        end
    end
    return nil
end

function player:stop()
    if player.prevDirY < 0 then
        player.anim = player.animations.stopUp
    else
        player.anim = player.animations.stopDown
    end
    player.anim:gotoFrame(1)
end

function player:update(dt)
    player.prevDirX = player.dirX
    player.prevDirY = player.dirY

    local currentDirX = 0
    local currentDirY = 0

    local controlledCharacter = possessedNpc or player

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

    cam:lookAt(controlledCharacter.x * scale, controlledCharacter.y * scale)

    if player.dirX == 1 then
        if player.dirY == 1 then
            player.anim = player.animations.downRight
        else
            player.anim = player.animations.upRight
        end
    else
        if player.dirY == 1 then
            player.anim = player.animations.downLeft
        else
            player.anim = player.animations.upLeft
        end
    end

    if currentDirX == 0 and currentDirY == 0 then
        player.walking = false
        player:stop()
    else
        player.walking = true
    end

    player.anim:update(dt)
end

return player
