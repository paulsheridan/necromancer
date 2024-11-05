-- Load necessary libraries
Camera = require 'libraries/hump/camera'
Vector = require "libraries/hump/vector"

local Camera = require 'libraries/hump/camera'
local player = require 'src/player'
local update = require 'src/update'
require('src/npc')

-- Init Camera
local cam = Camera(0, 0)
cam.smoother = Camera.smooth.damped(8)

-- Game state
local gamePaused = false
local markedNpcs = {}
local possessedNpc = nil -- Track which NPC is possessed
local menuOpen = false
local selectedMenuIndex = 1 -- Tracks the selected NPC in the menu
local numNpcs = 6
local bush = {
    x = 200,
    y = 200,
    width = 32,
    height = 32
}

-- Load function
function love.load()
    love.graphics.setBackgroundColor(0.2, 0.7, 0.3) -- Green background
    for i = 1, numNpcs do
        local npc = spawnNpc(math.random(50, 400), math.random(50, 400))
        table.insert(npcs, npc)
    end
end

-- Update function
function love.update(dt)
    if not gamePaused then
        -- Update the game state by calling the function from update.lua
        update.updateGame(dt, player, npcs, cam, possessedNpc, gamePaused)
    end
end

-- Draw function
function love.draw()
    cam:attach()
    -- Draw player and world objects
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)

    love.graphics.setColor(0.3, 0.5, 0.2)     -- Green color for bush
    love.graphics.rectangle("fill", bush.x, bush.y, bush.width, bush.height)

    for _, npc in ipairs(npcs) do
        if npc.marked then
            love.graphics.setColor(1, 1, 0) -- Yellow for marked NPCs
        else
            love.graphics.setColor(0, 0, 1) -- Blue for unmarked NPCs
        end
        love.graphics.rectangle("fill", npc.x, npc.y, npc.width, npc.height)
    end

    love.graphics.setColor(1, 1, 1) -- Reset color for other elements
    -- Additional drawing for other elements like bushes, player, etc.
    cam:detach()

    -- Draw pause menu if game is paused
    if gamePaused then
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Game Paused", 0, love.graphics.getHeight() / 2 - 10, love.graphics.getWidth(), "center")
    end

    -- Draw marked NPC selection menu
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

-- Key press handler
function love.keypressed(key)
    if key == "p" then
        gamePaused = not gamePaused
    elseif key == "f" then
        markedNpc = player.markNearbyNpc(npcs)
    elseif key == "m" then
        menuOpen = not menuOpen -- Toggle the menu
        selectedMenuIndex = 1   -- Reset selection when menu is opened
    elseif key == "e" and menuOpen then
        -- Possess the selected NPC in the menu
        possessedNpc = markedNpcs[selectedMenuIndex]
        menuOpen = false                                                       -- Close the menu
    elseif key == "up" and menuOpen then
        selectedMenuIndex = math.max(1, selectedMenuIndex - 1)                 -- Move up
    elseif key == "down" and menuOpen then
        selectedMenuIndex = math.min(#markedNpcs, selectedMenuIndex + 1) -- Move down
    elseif key == "e" and possessedNpc then
        possessedNpc = nil                                                     -- Release control back to the player
    end
end

function insertMarkedNpc(npc)
    table.insert(markedNpcs, npc)
end
