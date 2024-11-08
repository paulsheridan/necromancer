local player = {}

player.collider = world:newBSGRectangleCollider(100, 100, 8, 12, 3)
player.collider:setFixedRotation(true)
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
    player.collider:setLinearVelocity(0, 0)
end

function player:update(dt)
    player.x = player.collider:getX()
    player.y = player.collider:getY()
end

return player
