monsters = {}

function spawnMonster(x, y)
    local monster = world:newBSGRectangleCollider(x, y, 8, 12, 3)

    monster.x = x
    monster.y = y
    monster.speed = 50
    monster.width = 10
    monster.height = 16
    monster.dirX = 0
    monster.dirY = 0
    monster.prevDir = "down" -- last facing direction
    monster.moveTimer = 0
    monster.moveInterval = 2
    monster.color = { 0, 0, 1 }
    monster.marked = false
    monster.animSpeed = 0.14
    monster.walking = false
    monster.baseDamping = 12

    monster:setCollisionClass("Player")
    monster:setFixedRotation(true)
    monster:setLinearDamping(monster.baseDamping)

    monster.spriteSheet          = love.graphics.newImage("sprites/tilemap_packed.png")
    monster.grid                 = anim8.newGrid(16, 16, monster.spriteSheet:getWidth(), monster.spriteSheet:getHeight())

    monster.animations           = {}
    monster.animations.down      = anim8.newAnimation(monster.grid(25, 16, 25, 17, 25, 16, 25, 18), monster.animSpeed)
    monster.animations.right     = anim8.newAnimation(monster.grid(24, 16, 24, 17, 24, 16, 24, 18), monster.animSpeed)
    monster.animations.up        = anim8.newAnimation(monster.grid(26, 16, 26, 17, 26, 16, 26, 18), monster.animSpeed)
    monster.animations.left      = anim8.newAnimation(monster.grid(24, 16, 24, 17, 24, 16, 24, 18), monster.animSpeed)

    monster.animations.idleDown  = anim8.newAnimation(monster.grid(25, 16), 0.22)
    monster.animations.idleUp    = anim8.newAnimation(monster.grid(26, 16), 0.22)
    monster.animations.idleLeft  = anim8.newAnimation(monster.grid(27, 16), 0.22)
    monster.animations.idleRight = anim8.newAnimation(monster.grid(27, 16), 0.22)


    monster.anim = monster.animations.idleDown

    function monster:mark()
        self.marked = true
    end

    function monster:isMarked()
        return self.marked
    end

    function monster:update(dt)
        self.x = self:getX()
        self.y = self:getY()

        -- Use actual body velocity, not inputs
        local vx, vy = self:getLinearVelocity()
        local eps = 5

        if math.abs(vx) > eps or math.abs(vy) > eps then
            if math.abs(vx) > math.abs(vy) then
                self.prevDir = (vx > 0) and "right" or "left"
            else
                self.prevDir = (vy > 0) and "down" or "up"
            end
        end
    end

    function monster:stop()
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

    function monster:draw()
        local scaleX = 1
        if self.anim == self.animations.left or self.anim == self.animations.idleLeft then
            scaleX = -1
        end

        self.anim:draw(self.spriteSheet, self.x, self.y - 2, nil, scaleX, 1, 9.5, 10.5)
    end

    return monster
end

function monsters:update(dt)
    for _, monster in ipairs(self) do
        monster:update(dt)
    end
end

-- function monsters:spawn()
--     for i = 1, numMonsters do
--         local monster = spawnMonster(math.random(250, 600), math.random(250, 600))
--         table.insert(monsters, monster)
--     end
-- end
