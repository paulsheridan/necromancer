local BodyPart = require("src/monster/bodypart")

local BodyPartPickup = {}
BodyPartPickup.__index = BodyPartPickup

-- assumes tilemap_packed.png is 16x16 tiles
local TILE_SIZE = 16
local spriteSheet = love.graphics.newImage("sprites/tilemap_packed.png")

-- define quads for slots
local quads = {
    torso = love.graphics.newQuad(5 * TILE_SIZE, 11 * TILE_SIZE, TILE_SIZE, TILE_SIZE, spriteSheet:getDimensions()),
    head  = love.graphics.newQuad(10 * TILE_SIZE, 10 * TILE_SIZE, TILE_SIZE, TILE_SIZE, spriteSheet:getDimensions()),
    arm   = love.graphics.newQuad(0 * TILE_SIZE, 0 * TILE_SIZE, TILE_SIZE, TILE_SIZE, spriteSheet:getDimensions()), -- placeholder
    leg   = love.graphics.newQuad(1 * TILE_SIZE, 0 * TILE_SIZE, TILE_SIZE, TILE_SIZE, spriteSheet:getDimensions()), -- placeholder
}

function BodyPartPickup.new(x, y, name, slot, attributes)
    local self = setmetatable({}, BodyPartPickup)
    self.x = x
    self.y = y
    self.width = TILE_SIZE
    self.height = TILE_SIZE
    self.part = BodyPart.new(name, slot, attributes)
    self.pickedUp = false
    self.slot = slot
    return self
end

function BodyPartPickup:draw()
    if not self.pickedUp then
        love.graphics.setColor(1, 0.5, 0, 1) -- orange
        love.graphics.rectangle("fill", self.x, self.y, 8, 8)
        love.graphics.setColor(1, 1, 1, 1)   -- reset to white
    end
end

function BodyPartPickup:update(dt, player)
    if self.pickedUp then return end

    local dx = self.x - player.x
    local dy = self.y - player.y
    local dist = math.sqrt(dx * dx + dy * dy)

    if dist < 20 and love.keyboard.isDown("e") then
        self.pickedUp = true
        player.inventory:add(self.part)
        print("Picked up: " .. self.part.name)
    end
end

return BodyPartPickup
