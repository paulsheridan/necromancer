skeletons = {}

local skeletonDistance = 50   -- Distance from player or target
local baseWanderRange = 10    -- Base range for wander offsets
local baseFollowPrecision = 5 -- Base range for follow precision drift
local minDelayFactor = 0.1   -- Minimum delay factor for following
local maxDelayFactor = 0.5   -- Maximum delay factor for following
skeletons.npcTarget = nil
skeletons.state = "defending" -- Initial state of skeletons

function spawnSkeleton(x, y, summoner)
    local skeleton = {}
    skeleton.collider = world:newBSGRectangleCollider(100, 100, 8, 12, 3)
    skeleton.collider:setFixedRotation(true)
    skeleton.summoner = summoner
    skeleton.x = x
    skeleton.y = y
    skeleton.speed = 90
    skeleton.dirX = 1
    skeleton.dirY = 1
    skeleton.prevDirX = 1
    skeleton.prevDirY = 1
    skeleton.moveCount = 0
    skeleton.moveDelay = love.math.random(0.5, 3.5)
    skeleton.target = nil
    skeleton.animSpeed = 0.14
    skeleton.spriteSheet = love.graphics.newImage('sprites/skeletonSheet.png')
    skeleton.grid = anim8.newGrid(19, 21, skeleton.spriteSheet:getWidth(), skeleton.spriteSheet:getHeight())

    skeleton.animations = {}
    skeleton.animations.downRight = anim8.newAnimation(skeleton.grid('1-2', 1), skeleton.animSpeed)
    skeleton.animations.downLeft = anim8.newAnimation(skeleton.grid('1-2', 1), skeleton.animSpeed)
    skeleton.animations.upRight = anim8.newAnimation(skeleton.grid('1-2', 2), skeleton.animSpeed)
    skeleton.animations.upLeft = anim8.newAnimation(skeleton.grid('1-2', 2), skeleton.animSpeed)
    skeleton.animations.stopDown = anim8.newAnimation(skeleton.grid('1-3', 6), 0.22,
        function() skeleton.anim = skeleton.animations.idleDown end)
    skeleton.animations.stopUp = anim8.newAnimation(skeleton.grid('1-3', 7), 0.22,
        function() skeleton.anim = skeleton.animations.idleUp end)
    skeleton.animations.idleDown = anim8.newAnimation(skeleton.grid('1-4', 8), { 1.2, 0.1, 2.4, 0.1 })
    skeleton.animations.idleUp = anim8.newAnimation(skeleton.grid('1-2', 9), 0.22)

    skeleton.anim = skeleton.animations.idleDown

    function skeleton:update(dt, i)
        skeleton.moveCount = skeleton.moveCount + dt

        local targetX
        local targetY
        if self.target and skeletons.state == "attacking" then
            local angle = math.pi / #skeletons * i
            targetX = self.target.x + math.cos(angle) * skeletonDistance
            targetY = self.target.y + math.sin(angle) * skeletonDistance
        elseif skeletons.state == "defending" then
            local angle = math.pi / #skeletons * i
            targetX = self.summoner.x + math.cos(angle) * skeletonDistance
            targetY = self.summoner.y + math.sin(angle) * skeletonDistance
        end

        local dx = targetX - self.x
        local dy = targetY - self.y
        local distance = (dx * dx + dy * dy) ^ 0.5
        local nx, ny = dx / distance, dy / distance

        local vec = vector(nx, ny):normalized() * self.speed
        if vec.x ~= 0 or vec.y ~= 0 then
            self.collider:setLinearVelocity(vec.x, vec.y)
        else
            skeleton:stop()
        end

        skeleton.x = skeleton.collider:getX()
        skeleton.y = skeleton.collider:getY()
    end

    function skeleton:draw()
        love.graphics.circle("fill", skeleton.x, skeleton.y, 8)
    end

    function skeleton:stop()
        if self.prevDirY < 0 then
            self.anim = self.animations.stopUp
        else
            self.anim = self.animations.stopDown
        end
        self.anim:gotoFrame(1)
        self.collider:setLinearVelocity(0, 0)
    end


    return skeleton
end

function skeletons:spawn(num, summoner)
    local numSkeletons = num
    local angleStep = math.pi / (numSkeletons - 1)

    for i = 0, numSkeletons - 1 do
        local angle = angleStep * i - math.pi / 2
        local x = summoner.x + math.cos(angle) * skeletonDistance
        local y = summoner.y + math.sin(angle) * skeletonDistance
        local skeleton = spawnSkeleton(x, y, summoner)
        table.insert(skeletons, skeleton)
    end
end

function skeletons:update(dt)
    for i, skeleton in ipairs(skeletons) do
        skeleton:update(dt, i)
    end
end

function skeletons:draw()
    love.graphics.setColor(1, 1, 1)
    for _, skeleton in ipairs(skeletons) do
        skeleton:draw()
    end
end

function skeletons:commandAttack()
    for _, skeleton in ipairs(skeletons) do
        skeleton.state = "attacking"
    end
end

function skeletons:commandReturn()
    for _, skeleton in ipairs(skeletons) do
        skeleton.state = "returning"
    end
end
