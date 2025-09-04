local BodyPartPickup = require("src/monster/bodypartPickup")
bodyParts = {}

assemblyStation = { x = 400, y = 200, w = 32, h = 32 }
stationMenuOpen = false

equippedParts = {
    head = nil,
    torso = nil,
    arms = nil,
    legs = nil
}
selectedSlotIndex = 1
slots = { "head", "torso", "arms", "legs" }


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

    table.insert(bodyParts, BodyPartPickup.new(75, 400, "Rotten Torso", "torso", { strength = 2 }))
    table.insert(bodyParts, BodyPartPickup.new(35, 400, "Stitched Head", "head", { intelligence = 1 }))
end

function love.update(dt)
    if not gamePaused then
        updateAll(dt)

        -- update all body parts
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

    -- draw assembly station
    love.graphics.setColor(0.2, 0.8, 0.2) -- green square
    love.graphics.rectangle("fill", assemblyStation.x, assemblyStation.y, assemblyStation.w, assemblyStation.h)
    love.graphics.setColor(1, 1, 1)

    cam:detach()

    -- HUD / menus stay outside of camera
    if gamePaused then
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Game Paused", 0, love.graphics.getHeight() / 2 - 10, love.graphics.getWidth(), "center")
    end

    if menuOpen then
        -- === NPC window ===
        love.graphics.setColor(0, 0, 0, 0.7)
        love.graphics.rectangle("fill", 100, 100, 200, 200)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("NPCs", 100, 105, 200, "center")

        for i, npc in ipairs(markedNpcs) do
            if menuPane == "npcs" and i == selectedMenuIndex then
                love.graphics.setColor(1, 1, 0) -- highlight
            else
                love.graphics.setColor(1, 1, 1)
            end
            love.graphics.printf("NPC " .. i, 110, 120 + i * 20, 180, "left")
        end

        -- === Inventory window ===
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

    if stationMenuOpen then
        love.graphics.setColor(0, 0, 0, 0.7)
        love.graphics.rectangle("fill", 400, 100, 200, 200)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Assembly Station", 400, 110, 200, "center")

        for i, slot in ipairs(slots) do
            local y = 120 + i * 30
            if i == selectedSlotIndex then
                love.graphics.setColor(1, 1, 0) -- highlight selected
            else
                love.graphics.setColor(1, 1, 1)
            end
            local part = equippedParts[slot]
            local text = slot:sub(1, 1):upper() .. slot:sub(2) .. ": "
            if part then
                text = text .. part.name
            else
                text = text .. "[Empty]"
            end
            love.graphics.printf(text, 410, y, 180, "left")
        end

        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("↑/↓ to move | E equip | Q unequip", 400, 280, 200, "center")
    end
end

function love.keypressed(key)
    -- Pause always works
    if key == "p" then
        gamePaused = not gamePaused
        return
    end

    -- === Station menu handling ===
    if stationMenuOpen then
        if key == "up" then
            selectedSlotIndex = math.max(1, selectedSlotIndex - 1)
        elseif key == "down" then
            selectedSlotIndex = math.min(#slots, selectedSlotIndex + 1)
        elseif key == "e" then
            -- Equip from inventory (first item for now)
            if #player.inventory.items > 0 then
                local part = table.remove(player.inventory.items, 1)
                equippedParts[slots[selectedSlotIndex]] = part
            end
        elseif key == "q" then
            -- Unequip
            local part = equippedParts[slots[selectedSlotIndex]]
            if part then
                table.insert(player.inventory.items, part)
                equippedParts[slots[selectedSlotIndex]] = nil
            end
        elseif key == "escape" then
            stationMenuOpen = false
        end
        return -- 🚪 stop here so player doesn't also move
    end

    -- === NPC + inventory menu handling ===
    if menuOpen then
        if key == "left" then
            menuPane = "npcs"
        elseif key == "right" then
            menuPane = "inventory"
        elseif key == "up" then
            if menuPane == "npcs" then
                selectedMenuIndex = math.max(1, selectedMenuIndex - 1)
            else
                selectedInventoryIndex = math.max(1, selectedInventoryIndex - 1)
            end
        elseif key == "down" then
            if menuPane == "npcs" then
                selectedMenuIndex = math.min(#markedNpcs, selectedMenuIndex + 1)
            else
                selectedInventoryIndex = math.min(#player.inventory.items, selectedInventoryIndex + 1)
            end
        elseif key == "e" then
            if menuPane == "npcs" then
                possessedNpc = markedNpcs[selectedMenuIndex]
                menuOpen = false
            elseif menuPane == "inventory" then
                local chosen = player.inventory.items[selectedInventoryIndex]
                if chosen then
                    print("Selected part:", chosen.name)
                end
            end
        elseif key == "escape" or key == "m" then
            menuOpen = false
        end
        return -- 🚪 stop here so no movement happens
    end

    -- === Normal gameplay input ===
    if key == "f" then
        markedNpc = player:markNearbyNpc()
    elseif key == "m" then
        menuOpen = not menuOpen
        menuPane = "npcs"
        selectedMenuIndex = 1
        selectedInventoryIndex = 1
    elseif key == "e" then
        -- check if near station
        local dx = player.x - assemblyStation.x
        local dy = player.y - assemblyStation.y
        if math.abs(dx) < 40 and math.abs(dy) < 40 then
            stationMenuOpen = true
            selectedSlotIndex = 1
        elseif possessedNpc then
            possessedNpc = nil
        end
    end
end

function insertMarkedNpc(npc)
    table.insert(markedNpcs, npc)
end
