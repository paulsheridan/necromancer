npcs = {}

function spawnNpc(x, y)
    local npc = {}
    npc.x = x
    npc.y = y
    npc.speed = 30
    npc.width = 10
    npc.height = 16
    npc.direction = "down"
    npc.moveTimer = 0
    npc.moveInterval = 2
    npc.color = { 0, 0, 1 }
    npc.marked = false
    -- NPC states:
    -- 0: idle, standing
    -- 1: wander, stopped
    npc.state = 1

    function npc:mark()
        self.marked = true
    end

    function npc:isMarked()
        return self.marked
    end

    function npc:update(dt, possessedNpc)
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

    return npc
end

function npcs:update(dt, possessedNpc)
    for _, npc in ipairs(self) do
        npc:update(dt, possessedNpc)
    end
end
