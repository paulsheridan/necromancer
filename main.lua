require('src/npc')
require('src/utilities')
local player = require('src/player')
local update = require('src/update')
local camera = require('libraries/hump/camera')

local cam = camera(0, 0)
cam.smoother = camera.smooth.damped(8)

local gamePaused = false
local markedNpcs = {}
local possessedNpc = nil
local menuOpen = false
local selectedMenuIndex = 1
local numNpcs = 6
local bush = {
    x = 200,
    y = 200,
    width = 32,
    height = 32
}

function love.load()
    sti = require 'libraries/sti'
    gameMap = sti('maps/sampleMap.lua')

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
    gameMap:draw()
    cam:attach()
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)

    love.graphics.setColor(0.3, 0.5, 0.2)
    love.graphics.rectangle("fill", bush.x, bush.y, bush.width, bush.height)

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
    end
end

function insertMarkedNpc(npc)
    table.insert(markedNpcs, npc)
end
