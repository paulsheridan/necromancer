player = world:newBSGRectangleCollider(234, 184, 12, 12, 3)
player.x = 0
player.y = 0
player.speed = 90
player.width = 10
player.height = 16
player.dirX = 1
player.dirY = 1
player.prevDirX = 1
player.prevDirY = 1
player.animSpeed = 0.14
player.walking = false
player.baseDamping = 12

player:setCollisionClass("Player")
player:setFixedRotation(true)
player:setLinearDamping(player.baseDamping)

player.spriteSheet = love.graphics.newImage('sprites/playerSheet3.png')
player.grid = anim8.newGrid(19, 21, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())

player.animations = {}
player.animations.downRight = anim8.newAnimation(player.grid('1-2', 1), player.animSpeed)
player.animations.downLeft = anim8.newAnimation(player.grid('1-2', 1), player.animSpeed)
player.animations.upRight = anim8.newAnimation(player.grid('1-2', 2), player.animSpeed)
player.animations.upLeft = anim8.newAnimation(player.grid('1-2', 2), player.animSpeed)
player.animations.swordDownRight = anim8.newAnimation(player.grid('1-2', 1), player.animSpeed)
player.animations.swordDownLeft = anim8.newAnimation(player.grid('1-2', 1), player.animSpeed)
player.animations.swordUpRight = anim8.newAnimation(player.grid('1-2', 2), player.animSpeed)
player.animations.swordUpLeft = anim8.newAnimation(player.grid('1-2', 2), player.animSpeed)
player.animations.useDownRight = anim8.newAnimation(player.grid(2, 1), player.animSpeed)
player.animations.useDownLeft = anim8.newAnimation(player.grid(2, 1), player.animSpeed)
player.animations.useUpRight = anim8.newAnimation(player.grid(2, 2), player.animSpeed)
player.animations.useUpLeft = anim8.newAnimation(player.grid(2, 2), player.animSpeed)
player.animations.hold = anim8.newAnimation(player.grid(1, 1), player.animSpeed)
player.animations.rollDown = anim8.newAnimation(player.grid('1-3', 4), 0.11)
player.animations.rollUp = anim8.newAnimation(player.grid('1-3', 5), 0.11)
player.animations.stopDown = anim8.newAnimation(player.grid('1-3', 6), 0.22,
    function() player.anim = player.animations.idleDown end)
player.animations.stopUp = anim8.newAnimation(player.grid('1-3', 7), 0.22,
    function() player.anim = player.animations.idleUp end)
player.animations.idleDown = anim8.newAnimation(player.grid('1-4', 8), { 1.2, 0.1, 2.4, 0.1 })
player.animations.idleUp = anim8.newAnimation(player.grid('1-2', 9), 0.22)

player.anim = player.animations.idleDown

function player:stop()
    if player.prevDirY < 0 then
        player.anim = player.animations.stopUp
    else
        player.anim = player.animations.stopDown
    end
    player.anim:gotoFrame(1)
    player:setLinearVelocity(0, 0)
end

function player:idle()
    if player.prevDirY < 0 then
        player.anim = player.animations.idleUp
    else
        player.anim = player.animations.idleDown
    end
end

function player:update(dt)
    player.x = player:getX()
    player.y = player:getY()

    player = possessedNpc or player

    player.prevDirX = player.dirX
    player.prevDirY = player.dirY

    local dirX = 0
    local dirY = 0

    if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
        player.dirX = 1
        dirX = 1
        player.x = player.x + player.speed * dt
    elseif love.keyboard.isDown("a") or love.keyboard.isDown("left") then
        player.dirX = -1
        dirX = -1
        player.x = player.x - player.speed * dt
    end
    if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
        player.dirY = 1
        dirY = 1
        player.y = player.y + player.speed * dt
    elseif love.keyboard.isDown("w") or love.keyboard.isDown("up") then
        player.dirY = -1
        dirY = -1
        player.y = player.y - player.speed * dt
    end

    if player.walking then
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
    end

    local vec = vector(dirX, dirY):normalized() * player.speed
    if vec.x ~= 0 or vec.y ~= 0 then
        player:setLinearVelocity(vec.x, vec.y)
    end

    if dirX == 0 and dirY == 0 then
        player.walking = false
        player:stop()
    else
        player.walking = true
    end

    player.anim:update(dt)
end

function player:draw()
    local scaleX = 1
    if player.anim == player.animations.left then
        scaleX = -1
    end

    player.anim:draw(player.spriteSheet, player:getX(), player:getY() - 2, nil, player.dirX, 1, 9.5, 10.5)
end
