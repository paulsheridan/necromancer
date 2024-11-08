function love.load()
    wf = require('libraries/windfield')
    world = wf.newWorld(0,0)

    vector = require("libraries/hump/vector")

    anim8 = require('libraries/anim8')
    love.graphics.setDefaultFilter("nearest", "nearest")

    sti = require 'libraries/sti'
    gameMap = sti('maps/zeldaLikeOverworld.lua')


    player = require('src/player')
    update = require('src/update')
    utils = require('src/utilities')
    npcUtils = require('src/npc')
    character = require('src/character')
    require('src/cam')

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

    setWindowSize(fullscreen, 1920, 1080)
end

function love.update(dt)
    if not gamePaused then
        update.updateGame(dt)
    end
end

function love.draw()
    -- love.graphics.scale(scale)
    cam:attach()
        gameMap:drawLayer(gameMap.layers["GroundLayer"])
        gameMap:drawLayer(gameMap.layers["GroundCover"])
        player.anim:draw(player.spriteSheet, player.x, player.y - 2, nil, player.dirX, 1, 9.5, 10.5)

        for _, npc in ipairs(npcs) do
            if npc.marked then
                love.graphics.setColor(1, 1, 0) -- Yellow for marked NPCs
            else
                love.graphics.setColor(0, 0, 1) -- Blue for unmarked NPCs
            end
            npc.anim:draw(npc.spriteSheet, npc.x, npc.y - 2, nil, npc.dirX, 1, 9.5, 10.5)
        end

        love.graphics.setColor(1, 1, 1)
        world:draw()

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
    cam:detach()
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

function setWindowSize(full, width, height)
    if full then
        fullscreen = true
        love.window.setFullscreen(true)
        windowWidth = love.graphics.getWidth()
        windowHeight = love.graphics.getHeight()
    else
        fullscreen = false
        if width == nil or height == nil then
            windowWidth = 1920
            windowHeight = 1080
        else
            windowWidth = width
            windowHeight = height
        end
        love.window.setMode(windowWidth, windowHeight, { resizable = not testWindow })
    end
    scale = (7.3 / 1200) * windowHeight


    cam:zoomTo(scale)

end
