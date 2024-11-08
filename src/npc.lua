npcs = {}

function spawnNpc(x, y)
    local npc = {}
    npc.collider = world:newBSGRectangleCollider(100, 100, 8, 12, 3)
    npc.collider:setFixedRotation(true)
    npc.x = x
    npc.y = y
    npc.speed = 30
    npc.width = 10
    npc.height = 16
    npc.dirX = 1
    npc.dirY = 1
    npc.prevDirX = 1
    npc.prevDirY = 1
    npc.moveTimer = 0
    npc.moveInterval = 2
    npc.color = { 0, 0, 1 }
    npc.marked = false
    npc.animSpeed = 0.14
    npc.walking = false

    npc.spriteSheet = love.graphics.newImage('sprites/npcSheet.png')
    npc.grid = anim8.newGrid(19, 21, npc.spriteSheet:getWidth(), npc.spriteSheet:getHeight())

    npc.animations = {}
    npc.animations.downRight = anim8.newAnimation(npc.grid('1-2', 1), npc.animSpeed)
    npc.animations.downLeft = anim8.newAnimation(npc.grid('1-2', 1), npc.animSpeed)
    npc.animations.upRight = anim8.newAnimation(npc.grid('1-2', 2), npc.animSpeed)
    npc.animations.upLeft = anim8.newAnimation(npc.grid('1-2', 2), npc.animSpeed)
    npc.animations.stopDown = anim8.newAnimation(npc.grid('1-3', 6), 0.22,
        function() npc.anim = npc.animations.idleDown end)
    npc.animations.stopUp = anim8.newAnimation(npc.grid('1-3', 7), 0.22,
        function() npc.anim = npc.animations.idleUp end)
    npc.animations.idleDown = anim8.newAnimation(npc.grid('1-4', 8), { 1.2, 0.1, 2.4, 0.1 })
    npc.animations.idleUp = anim8.newAnimation(npc.grid('1-2', 9), 0.22)

    npc.anim = npc.animations.idleDown

    function npc:mark()
        self.marked = true
    end

    function npc:isMarked()
        return self.marked
    end

    function npc:update(dt)
        self.x = self.collider:getX()
        self.y = self.collider:getY()

        if self ~= possessedNpc then
            self.moveTimer = self.moveTimer + dt
            if self.moveTimer >= self.moveInterval then
                self.moveTimer = 0
                local directions = { "up", "down", "left", "right" }
                self.direction = directions[math.random(#directions)]
            end

            if self.direction == "up" then
                self.y = self.y - self.speed * dt
            elseif self.direction == "down" then
                self.y = self.y + self.speed * dt
            elseif self.direction == "left" then
                self.x = self.x - self.speed * dt
            elseif self.direction == "right" then
                self.x = self.x + self.speed * dt
            end
        end
    end

    function npc:stop()
        if npc.prevDirY < 0 then
            npc.anim = npc.animations.stopUp
        else
            npc.anim = npc.animations.stopDown
        end
        npc.anim:gotoFrame(1)
        npc.collider:setLinearVelocity(0, 0)
    end

    return npc
end

function npcs:update(dt)
    for _, npc in ipairs(self) do
        npc:update(dt)
    end
end
