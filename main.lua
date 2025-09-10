local BodyPartPickup = require("src/monster/bodypartPickup")
local keyHandler = require("src/input/keyHandler")
bodyParts = {}

assemblyStation = { x = 400, y = 200, w = 32, h = 32 }
stationMenuOpen = false
slotSelectionMenuOpen = false

equippedParts = {
    head = nil,
    torso = nil,
    leftArm = nil,
    rightArm = nil,
    leftLeg = nil,
    rightLeg = nil
}
selectedSlotIndex = 1
slots = {
    { label = "head",          key = "head" },
    { label = "torso",         key = "torso" },
    { label = "left arm",      key = "leftArm" },
    { label = "right arm",     key = "rightArm" },
    { label = "left leg",      key = "leftLeg" },
    { label = "right leg",     key = "rightLeg" },
    { label = "BUILD MONSTER", key = "BUILD" }
}

filteredParts = {}
selectedFilteredIndex = 1

function allSlotsFilled()
    for _, slot in ipairs(slots) do
        if slot.key ~= "BUILD" and not equippedParts[slot.key] then
            return false
        end
    end
    return true
end

function spawnBuiltMonster()
    local monster = spawnMonster(assemblyStation.x + 50, assemblyStation.y + 50)
    table.insert(monsters, monster)

    -- ✅ Add monster to controllable pool (same as NPCs)
    monster.isMonster = true
    insertMarkedNpc(monster)

    -- Clear equipped slots
    for _, slot in ipairs(slots) do
        if slot.key ~= "BUILD" then
            equippedParts[slot.key] = nil
        end
    end

    -- Close menus
    stationMenuOpen = false
    slotSelectionMenuOpen = false
end

function love.load()
    require("src/startup/gameStart")
    gameStart()

    gamePaused = false
    markedNpcs = {}
    possessedNpc = nil
    menuOpen = false
    menuPane = "npcs"
    selectedInventoryIndex = 1
    selectedMenuIndex = 1
    numNpcs = 4

    walls = {}
    if gameMap.layers["Objects"] then
        for i, obj in pairs(gameMap.layers["Objects"].objects) do
            local wall = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            wall:setType("static")
            table.insert(walls, wall)
        end
    end

    npcs:spawn()

    -- Spawn pickups in the world
    table.insert(bodyParts, BodyPartPickup.new(400, 600, "Fresh Left Arm", "leftArm", { strength = 1 }))
    table.insert(bodyParts, BodyPartPickup.new(450, 600, "Fresh Right Arm", "rightArm", { strength = 2 }))
    table.insert(bodyParts, BodyPartPickup.new(400, 650, "Fresh Left Leg", "leftLeg", { speed = 1 }))
    table.insert(bodyParts, BodyPartPickup.new(450, 650, "Putrid Right Leg", "rightLeg", { speed = 1 }))
    table.insert(bodyParts, BodyPartPickup.new(425, 625, "Putrid Head", "head", { smarts = 3 }))
    table.insert(bodyParts, BodyPartPickup.new(475, 625, "Putrid Torso", "torso", { toughness = 4 }))

    -- give player some sample parts
    player:addBodyPart("Rotten Left Arm", "leftArm", { strength = 1 })
    player:addBodyPart("Rotten Right Arm", "rightArm", { strength = 2 })
    player:addBodyPart("Zombie Left Leg", "leftLeg", { speed = 1 })
    player:addBodyPart("Zombie Right Leg", "rightLeg", { speed = 1 })
    player:addBodyPart("Rotten Head", "head", { smarts = 3 })
    player:addBodyPart("Rotten Torso", "torso", { toughness = 4 })
end

function love.update(dt)
    if not gamePaused then
        updateAll(dt)

        for _, part in ipairs(bodyParts) do
            part:update(dt, player)
        end
    end
end

function love.draw()
    cam:attach()
    drawCamera()

    -- draw body parts in world space
    for _, part in ipairs(bodyParts) do
        part:draw()
    end

    -- draw monsters
    for _, monster in ipairs(monsters) do
        monster:draw()
    end

    cam:detach()

    -- pause overlay
    if gamePaused then
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Game Paused", 0, love.graphics.getHeight() / 2 - 10, love.graphics.getWidth(), "center")
    end

    -- NPC + Inventory menu
    if menuOpen then
        -- NPC window
        love.graphics.setColor(0, 0, 0, 0.7)
        love.graphics.rectangle("fill", 100, 100, 200, 200)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("NPCs", 100, 105, 200, "center")

        for i, character in ipairs(markedNpcs) do
            if menuPane == "npcs" and i == selectedMenuIndex then
                love.graphics.setColor(1, 1, 0)
            else
                love.graphics.setColor(1, 1, 1)
            end

            local label = "NPC " .. i
            if character.isMonster then
                label = "Monster " .. i
            end

            love.graphics.printf(label, 110, 120 + i * 20, 180, "left")
        end


        -- Inventory window
        local invX, invY = 320, 100
        love.graphics.setColor(0, 0, 0, 0.7)
        love.graphics.rectangle("fill", invX, invY, 200, 200)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Inventory", invX, invY + 5, 200, "center")

        if player.inventory and #player.inventory.items > 0 then
            for i, part in ipairs(player.inventory.items) do
                if menuPane == "inventory" and i == selectedInventoryIndex then
                    love.graphics.setColor(1, 1, 0)
                else
                    love.graphics.setColor(1, 1, 1)
                end
                love.graphics.printf(
                    part.name .. " (" .. part.slot .. ")",
                    invX + 10,
                    invY + 20 + i * 20,
                    180,
                    "left"
                )
            end
        else
            love.graphics.printf("Empty", invX, invY + 40, 200, "center")
        end
    end

    -- Station Menu (always stays up if open)
    if stationMenuOpen then
        love.graphics.setColor(0, 0, 0, 0.7)
        love.graphics.rectangle("fill", 540, 100, 200, 220)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Assembly Station", 540, 110, 200, "center")

        for i, slot in ipairs(slots) do
            if i == selectedSlotIndex then
                love.graphics.setColor(1, 1, 0)
            else
                love.graphics.setColor(1, 1, 1)
            end
            local part = equippedParts[slot.key]
            local label
            if slot.key == "BUILD" then
                label = slot.label
            else
                label = slot.label .. ": " .. (part and part.name or "[empty]")
            end
            love.graphics.print(label, 550, 120 + i * 20)
        end

        -- If slot selection menu is open, draw it alongside
        if slotSelectionMenuOpen then
            love.graphics.setColor(0, 0, 0, 0.9)
            love.graphics.rectangle("fill", 760, 100, 200, 200)
            love.graphics.setColor(1, 1, 1)
            love.graphics.printf("Choose Part", 760, 110, 200, "center")

            if #filteredParts == 0 then
                love.graphics.printf("[no available parts]", 760, 140, 200, "center")
            else
                for i, part in ipairs(filteredParts) do
                    if i == selectedFilteredIndex then
                        love.graphics.setColor(1, 1, 0)
                    else
                        love.graphics.setColor(1, 1, 1)
                    end
                    love.graphics.print(part.name, 770, 130 + i * 20)
                end
            end
        end
    end
end

function love.keypressed(key)
    keyHandler.handleKeyPressed(key)
end

function insertMarkedNpc(npc)
    table.insert(markedNpcs, npc)
end

function getControlled()
    return possessedNpc or player
end
