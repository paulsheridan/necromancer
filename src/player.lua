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

player.spriteSheet = love.graphics.newImage('sprites/playerSheet.png')
player.grid = anim8.newGrid(16, 32, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())

player.animations = {}
player.animations.down = anim8.newAnimation(player.grid('1-1', 4), player.animSpeed)
player.animations.right = anim8.newAnimation(player.grid('1-2', 4), player.animSpeed)
player.animations.up = anim8.newAnimation(player.grid('1-3', 4), player.animSpeed)
player.animations.left = anim8.newAnimation(player.grid('1-4', 4), player.animSpeed)
player.animations.idleDown = anim8.newAnimation(player.grid('1-1', 1), 0.22)
player.animations.idleUp = anim8.newAnimation(player.grid('3-1', 1), 0.22)

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
    if self.prevDirY < 0 then
        self.anim = self.animations.idleUp
    else
        self.anim = self.animations.idleDown
    end
    self.anim:gotoFrame(1)
    self:setLinearVelocity(0, 0)
end

function player:update(dt)
    player.x = player:getX()
    player.y = player:getY()
end

function player:draw()
    local scaleX = 1
    if player.anim == player.animations.left then
        scaleX = -1
    end

    player.anim:draw(player.spriteSheet, player.x, player.y - 2, nil, scaleX, 1, 9.5, 10.5)
end
