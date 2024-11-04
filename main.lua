-- Load necessary libraries
Camera = require 'libraries/hump/camera'
cam = Camera(0, 0)
cam.smoother = Camera.smooth.damped(8)

-- Require other files
player = require 'player'
world = require 'world'
update = require 'update'

-- Game state
local gamePaused = false
local markedNpc = nil
local possessedNpc = nil -- Track which NPC is possessed
local menuOpen = false
local selectedMenuIndex = 1 -- Tracks the selected NPC in the menu

-- Load function
function love.load()
    love.graphics.setBackgroundColor(0.2, 0.7, 0.3) -- Green background
    world.spawnNpcs()
end

-- Update function
function love.update(dt)
    if not gamePaused then
        -- Update the game state by calling the function from update.lua
        update.updateGame(dt, player, world.npcs, cam, possessedNpc, gamePaused)
    end
end

-- Draw function
function love.draw()
    cam:attach()
    -- Draw player and world objects
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)

    love.graphics.setColor(0.3, 0.5, 0.2)     -- Green color for bush
    love.graphics.rectangle("fill", world.bush.x, world.bush.y, world.bush.width, world.bush.height)

    world.drawWorld(markedNpc, possessedNpc)
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

        for i, npc in ipairs(world.markedNpcs) do
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
        markedNpc = world.markNearbyNpc(player)
    elseif key == "m" then
        menuOpen = not menuOpen -- Toggle the menu
        selectedMenuIndex = 1   -- Reset selection when menu is opened
    elseif key == "e" and menuOpen then
        -- Possess the selected NPC in the menu
        possessedNpc = world.markedNpcs[selectedMenuIndex]
        menuOpen = false                                                       -- Close the menu
    elseif key == "up" and menuOpen then
        selectedMenuIndex = math.max(1, selectedMenuIndex - 1)                 -- Move up
    elseif key == "down" and menuOpen then
        selectedMenuIndex = math.min(#world.markedNpcs, selectedMenuIndex + 1) -- Move down
    elseif key == "e" and possessedNpc then
        possessedNpc = nil                                                     -- Release control back to the player
    end
end
