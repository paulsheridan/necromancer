local Inventory = require("src/inventory")

player = world:newBSGRectangleCollider(234, 184, 12, 12, 3)
player.x = 0
player.y = 0
player.speed = 90
player.width = 10
player.height = 16
player.dirX = 0         -- no movement until input
player.dirY = 0
player.prevDir = "down" -- default facing down at start
player.animSpeed = 0.14
player.walking = false
player.baseDamping = 12

player:setCollisionClass("Player")
player:setFixedRotation(true)
player:setLinearDamping(player.baseDamping)

player.inventory            = Inventory.new()

player.spriteSheet          = love.graphics.newImage("sprites/tilemap_packed.png")
player.grid                 = anim8.newGrid(16, 16, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())

player.animations           = {}
player.animations.down      = anim8.newAnimation(player.grid(25, 1, 25, 2, 25, 1, 25, 3), player.animSpeed)
player.animations.right     = anim8.newAnimation(player.grid(24, 1, 24, 2, 24, 1, 24, 3), player.animSpeed)
player.animations.up        = anim8.newAnimation(player.grid(26, 1, 26, 2, 26, 1, 26, 3), player.animSpeed)
player.animations.left      = anim8.newAnimation(player.grid(24, 1, 24, 2, 24, 1, 24, 3), player.animSpeed)

player.animations.idleDown  = anim8.newAnimation(player.grid(25, 1), 0.22)
player.animations.idleUp    = anim8.newAnimation(player.grid(26, 1), 0.22)
player.animations.idleLeft  = anim8.newAnimation(player.grid(27, 1), 0.22)
player.animations.idleRight = anim8.newAnimation(player.grid(27, 1), 0.22)

player.anim                 = player.animations.idleDown

-- Example helper: find NPC nearby
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

-- Stop player movement + switch to idle
function player:stop()
    if self.prevDir == "up" then
        self.anim = self.animations.idleUp
    elseif self.prevDir == "down" then
        self.anim = self.animations.idleDown
    elseif self.prevDir == "left" then
        self.anim = self.animations.idleLeft
    elseif self.prevDir == "right" then
        self.anim = self.animations.idleRight
    else
        self.anim = self.animations.idleDown -- fallback
    end

    self.anim:gotoFrame(1)
    self:setLinearVelocity(0, 0)
end

-- Update position + last facing direction
function player:update(dt)
    self.x = self:getX()
    self.y = self:getY()

    -- Use actual body velocity, not inputs
    local vx, vy = self:getLinearVelocity()
    local eps = 5 -- pixels/sec threshold to ignore tiny jitter

    if math.abs(vx) > eps or math.abs(vy) > eps then
        if math.abs(vx) > math.abs(vy) then
            self.prevDir = (vx > 0) and "right" or "left"
        else
            self.prevDir = (vy > 0) and "down" or "up"
        end
    end
end

-- Draw sprite (flip if facing left)
function player:draw()
    local scaleX = 1
    if self.anim == self.animations.left or self.anim == self.animations.idleLeft then
        scaleX = -1
    end

    self.anim:draw(self.spriteSheet, self.x, self.y - 2, nil, scaleX, 1, 9.5, 10.5)

    -- Debug: show prevDir on screen
    love.graphics.setColor(1, 1, 1, 1) -- reset color to white
    love.graphics.print("prevDir: " .. tostring(self.prevDir), 10, 10)
end

function player:addBodyPart(name, slot, attributes)
    if not self.inventory then return end
    local part = BodyPart.new(name, slot, attributes)
    self.inventory:add(part)
end

function player:showInventory()
    if self.inventory then
        self.inventory:list()
    end
end
