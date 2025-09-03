local BodyPartPickup = require("src/monster/bodypartPickup")
bodyParts = {}

function love.load()
    require("src/startup/gameStart")
    gameStart()

    gamePaused = false
    markedNpcs = {}
    possessedNpc = nil
    menuOpen = false
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

    cam:detach()

    -- HUD / menus stay outside of camera
    if gamePaused then
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Game Paused", 0, love.graphics.getHeight() / 2 - 10, love.graphics.getWidth(), "center")
    end

    if menuOpen then
        -- === NPC selection window ===
        love.graphics.setColor(0, 0, 0, 0.7)
        love.graphics.rectangle("fill", 100, 100, 200, 200)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Select an NPC to possess", 110, 110, 180, "center")

        for i, npc in ipairs(markedNpcs) do
            if i == selectedMenuIndex then
                love.graphics.setColor(1, 1, 0) -- Highlight selected NPC
            else
                love.graphics.setColor(1, 1, 1)
            end
            love.graphics.printf("NPC " .. i, 110, 120 + i * 20, 180, "center")
        end

        -- === Inventory window ===
        local invX, invY = 320, 100
        love.graphics.setColor(0, 0, 0, 0.7)
        love.graphics.rectangle("fill", invX, invY, 200, 200)

        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Inventory", invX, invY + 5, 200, "center")

        if player.inventory and #player.inventory.items > 0 then
            for i, part in ipairs(player.inventory.items) do
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
end

function love.keypressed(key)
    if key == "p" then
        gamePaused = not gamePaused
    elseif key == "f" then
        markedNpc = player:markNearbyNpc()
    elseif key == "m" then
        menuOpen = not menuOpen
        selectedMenuIndex = 1
    elseif key == "e" and menuOpen then
        possessedNpc = markedNpcs[selectedMenuIndex]
        menuOpen = false
    elseif key == "up" and menuOpen then
        selectedMenuIndex = math.max(1, selectedMenuIndex - 1)
    elseif key == "down" and menuOpen then
        selectedMenuIndex = math.min(#markedNpcs, selectedMenuIndex + 1)
    elseif key == "e" and possessedNpc then
        possessedNpc = nil
    end
end

function insertMarkedNpc(npc)
    table.insert(markedNpcs, npc)
end
