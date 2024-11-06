function love.load()
    camera = require('libraries/hump/camera')
    cam = camera()
    cam.smoother = camera.smooth.damped(8)

    love.graphics.setDefaultFilter("nearest", "nearest")

    sti = require 'libraries/sti'
    gameMap = sti('maps/sampleMap.lua')

    player = require('src/player')
    update = require('src/update')
    utils = require('src/utilities')
    npcUtils = require('src/npc')

    gamePaused = false
    markedNpcs = {}
    possessedNpc = nil
    menuOpen = false
    selectedMenuIndex = 1
    numNpcs = 6
    scale = 1


    for i = 1, numNpcs do
        local npc = spawnNpc(math.random(50, 400), math.random(50, 400))
        table.insert(npcs, npc)
    end
end

function love.update(dt)
    if not gamePaused then
        update.updateGame(dt, player, npcs, cam, possessedNpc, gamePaused)
    end
end

function love.draw()
    love.graphics.scale(1 * scale, 1 * scale)
    cam:attach()
        gameMap:drawLayer(gameMap.layers["GroundLayer"])
        gameMap:drawLayer(gameMap.layers["GroundCover"])
        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)

        for _, npc in ipairs(npcs) do
            if npc.marked then
                love.graphics.setColor(1, 1, 0) -- Yellow for marked NPCs
            else
                love.graphics.setColor(0, 0, 1) -- Blue for unmarked NPCs
            end
            love.graphics.rectangle("fill", npc.x, npc.y, npc.width, npc.height)
        end

        love.graphics.setColor(1, 1, 1)
    cam:detach()

    if gamePaused then
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Game Paused", 0, love.graphics.getHeight() / 2 - 10, love.graphics.getWidth(), "center")
    end

    if menuOpen then
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
    elseif key == "o" then
        scale = scale + 1
    end
end

function insertMarkedNpc(npc)
    table.insert(markedNpcs, npc)
end
