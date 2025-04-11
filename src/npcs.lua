
npcs = {}

function spawnNpc(x, y)
    npc = world:newBSGRectangleCollider(x, y, 8, 12, 3)

    npc.x = x
    npc.y = y
    npc.speed = 90
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
    npc.baseDamping = 12

    npc:setCollisionClass("Player")
    npc:setFixedRotation(true)
    npc:setLinearDamping(npc.baseDamping)

    npc.spriteSheet = love.graphics.newImage('sprites/playerSheet.png')
    npc.grid = anim8.newGrid(16, 32, npc.spriteSheet:getWidth(), npc.spriteSheet:getHeight())

    npc.animations = {}
    npc.animations.down = anim8.newAnimation(npc.grid('1-1', 4), npc.animSpeed)
    npc.animations.right = anim8.newAnimation(npc.grid('1-2', 4), npc.animSpeed)
    npc.animations.up = anim8.newAnimation(npc.grid('1-3', 4), npc.animSpeed)
    npc.animations.left = anim8.newAnimation(npc.grid('1-4', 4), npc.animSpeed)
    npc.animations.idleDown = anim8.newAnimation(npc.grid('1-1', 1), 0.22)
    npc.animations.idleUp = anim8.newAnimation(npc.grid('3-1', 1), 0.22)

    npc.anim = npc.animations.idleDown

    function npc:mark()
        self.marked = true
    end

    function npc:isMarked()
        return self.marked
    end

    function npc:update(dt)
        self.x = self:getX()
        self.y = self:getY()

        local isMoving = false
        local vx = 0
        local vy = 0

        if self ~= possessedNpc then
            self.moveTimer = self.moveTimer + dt
            if self.moveTimer >= self.moveInterval then
                self.moveTimer = 0
                local directions = { "up", "down", "left", "right", "stop" }
                self.direction = directions[math.random(#directions)]
            end

            if self.direction == "up" then
                vx = self.speed
            elseif self.direction == "down" then
                vx = self.speed * -1
            elseif self.direction == "left" then
                vy = self.speed
            elseif self.direction == "right" then
                vy = self.speed * -1
            elseif self.direction == "stop" then
                vx, vy = 0, 0
            end
            self:setLinearVelocity(vx, vy)
        end
    end

    function npc:stop()
        if self.prevDirY < 0 then
            self.anim = self.animations.idleUp
        else
            self.anim = self.animations.idleDown
        end
        self.anim:gotoFrame(1)
        self:setLinearVelocity(0, 0)
    end

    function npc:draw()
        local scaleX = 1
        if npc.anim == npc.animations.left then
            scaleX = -1
        end

        npc.anim:draw(npc.spriteSheet, npc.x, npc.y - 2, nil, scaleX, 1, 9.5, 10.5)
    end

    return npc
end

function npcs:update(dt)
    for _, npc in ipairs(self) do
        npc:update(dt)
    end
end

function npcs:spawn()
    for i = 1, numNpcs do
        local npc = spawnNpc(math.random(250, 600), math.random(250, 600))
        table.insert(npcs, npc)
    end
end
