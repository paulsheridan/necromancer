npcs = {}

function spawnNpc(x, y)
    local npc = world:newBSGRectangleCollider(x, y, 8, 12, 3)

    npc.x = x
    npc.y = y
    npc.speed = 50
    npc.width = 10
    npc.height = 16
    npc.dirX = 0
    npc.dirY = 0
    npc.prevDir = "down" -- last facing direction
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

    npc.spriteSheet          = love.graphics.newImage("sprites/tilemap_packed.png")
    npc.grid                 = anim8.newGrid(16, 16, npc.spriteSheet:getWidth(), npc.spriteSheet:getHeight())

    npc.animations           = {}
    npc.animations.down      = anim8.newAnimation(npc.grid(25, 7, 25, 8, 25, 7, 25, 9), npc.animSpeed)
    npc.animations.right     = anim8.newAnimation(npc.grid(24, 7, 24, 8, 24, 7, 24, 9), npc.animSpeed)
    npc.animations.up        = anim8.newAnimation(npc.grid(26, 7, 26, 8, 26, 7, 26, 9), npc.animSpeed)
    npc.animations.left      = anim8.newAnimation(npc.grid(24, 7, 24, 8, 24, 7, 24, 9), npc.animSpeed)

    npc.animations.idleDown  = anim8.newAnimation(npc.grid(25, 7), 0.22)
    npc.animations.idleUp    = anim8.newAnimation(npc.grid(26, 7), 0.22)
    npc.animations.idleLeft  = anim8.newAnimation(npc.grid(27, 7), 0.22)
    npc.animations.idleRight = anim8.newAnimation(npc.grid(27, 7), 0.22)


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

        local vx, vy = 0, 0

        if self ~= possessedNpc then
            self.moveTimer = self.moveTimer + dt
            if self.moveTimer >= self.moveInterval then
                self.moveTimer = 0
                local directions = { "up", "down", "left", "right", "stop" }
                self.direction = directions[math.random(#directions)]
            end

            if self.direction == "up" then
                vy = -self.speed
            elseif self.direction == "down" then
                vy = self.speed
            elseif self.direction == "left" then
                vx = -self.speed
            elseif self.direction == "right" then
                vx = self.speed
            elseif self.direction == "stop" then
                vx, vy = 0, 0
            end

            self:setLinearVelocity(vx, vy)

            -- Update prevDir based on actual velocity
            local eps = 1 -- threshold to ignore tiny jitter
            if math.abs(vx) > eps or math.abs(vy) > eps then
                if math.abs(vx) > math.abs(vy) then
                    self.prevDir = (vx > 0) and "right" or "left"
                else
                    self.prevDir = (vy > 0) and "down" or "up"
                end
            end
        end
    end

    function npc:stop()
        if self.prevDir == "up" then
            self.anim = self.animations.idleUp
        elseif self.prevDir == "down" then
            self.anim = self.animations.idleDown
        elseif self.prevDir == "left" then
            self.anim = self.animations.idleLeft
        elseif self.prevDir == "right" then
            self.anim = self.animations.idleRight
        else
            self.anim = self.animations.idleDown
        end

        self.anim:gotoFrame(1)
        self:setLinearVelocity(0, 0)
    end

    function npc:draw()
        local scaleX = 1
        if self.anim == self.animations.left or self.anim == self.animations.idleLeft then
            scaleX = -1
        end

        self.anim:draw(self.spriteSheet, self.x, self.y - 2, nil, scaleX, 1, 9.5, 10.5)
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
