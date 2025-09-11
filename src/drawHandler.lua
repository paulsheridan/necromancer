-- src/drawHandler.lua
local worldDraw         = require("src.draw.world")
local stationMenuDraw   = require("src.draw.stationMenu")
local slotSelectionDraw = require("src.draw.slotSelection")
local mainMenuDraw      = require("src.draw.mainMenu")
local debugDraw         = require("src.draw.debug")

local drawHandler       = {}

function drawHandler.handleDraw()
    -- Always draw world
    worldDraw.draw()

    -- UI overlays
    if stationMenuOpen then
        stationMenuDraw.draw()
        if slotSelectionMenuOpen then
            slotSelectionDraw.draw()
        end
    end

    if menuOpen then
        mainMenuDraw.draw()
    end

    -- Debug
    debugDraw.draw()
end

return drawHandler
