skeletons = {}

local skeletonDistance = 50   -- Distance from player or target
local baseWanderRange = 10    -- Base range for wander offsets
local baseFollowPrecision = 5 -- Base range for follow precision drift
local minDelayFactor = 0.05   -- Minimum delay factor for following
local maxDelayFactor = 0.15   -- Maximum delay factor for following
skeletons.npcTarget = nil
skeletons.state = "defending" -- Initial state of skeletons

function spawnSkeleton(x, y, summoner, angle, timeOffset)
    local skeleton = {}
    skeleton.summoner = summoner
    skeleton.x = x
    skeleton.y = y
    skeleton.target = nil
    skeleton.timeOffset = love.math.random() * 2 * math.pi -- Random initial time offset for oscillations
    skeleton.wanderTimer = love.math.random(1, 3)
    skeleton.baseFollowDelay = love.math.random() * (maxDelayFactor - minDelayFactor) + minDelayFactor


    function skeleton:update(dt, i)
        print("summoner xy: ", self.summoner.x, self.summoner.y)
        -- Increment time offset to create smooth oscillations
        skeleton.timeOffset = skeleton.timeOffset + dt

        local targetX
        local targetY
        if self.target and skeletons.state == "attacking" then
            -- Calculate each skeleton's target position around the NPC in a circle
            local angle = (2 * math.pi / #skeletons) * i
            targetX = self.target.x + math.cos(angle) * skeletonDistance
            targetY = self.target.y + math.sin(angle) * skeletonDistance
        elseif skeletons.state == "defending" then
            -- Idle state: follow player with oscillations
            local angle = (math.pi / 2) + (i - 2) * (math.pi / (2 * #skeletons))
            targetX = self.summoner.x + math.cos(angle) * skeletonDistance +
                baseWanderRange * math.sin(skeleton.timeOffset)
            targetY = self.summoner.y + math.sin(angle) * skeletonDistance +
                baseWanderRange * math.cos(skeleton.timeOffset)
        end
        print("target xy: ", targetX, targetY)

        -- Calculate each skeleton's movement toward the target with some delay and randomness
        local delayFactor = skeleton.baseFollowDelay + 0.05 * math.sin(skeleton.timeOffset * 0.5)
        skeleton.x = skeleton.x + (targetX - skeleton.x) * delayFactor
        skeleton.y = skeleton.y + (targetY - skeleton.y) * delayFactor
    end

    function skeleton:draw()
        love.graphics.circle("fill", skeleton.x, skeleton.y, 8)
    end


    return skeleton
end

function skeletons:spawn(num, summoner)
    print("%s skeletons!", num)
    local numSkeletons = num
    local angleStep = math.pi / (numSkeletons - 1) -- Divide the semicircle evenly

    for i = 0, numSkeletons - 1 do
        local angle = angleStep * i - math.pi / 2 -- Start from -90 degrees
        local x = summoner.x + math.cos(angle) * skeletonDistance
        local y = summoner.y + math.sin(angle) * skeletonDistance
        local skeleton = spawnSkeleton(x, y, summoner, angle, timeOffset)
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
