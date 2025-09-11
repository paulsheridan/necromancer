-- src/input/keyHandler.lua
local gameplay = require("src.input.gameplay")
local stationMenu = require("src.input.stationMenu")
local slotSelection = require("src.input.slotSelection")
local mainMenu = require("src.input.mainMenu")

local keyHandler = {}

function keyHandler.handleKeyPressed(key)
    if key == "p" then
        gamePaused = not gamePaused
        return
    end

    if stationMenuOpen and slotSelectionMenuOpen then
        slotSelection.handle(key)
    elseif stationMenuOpen then
        stationMenu.handle(key)
    elseif menuOpen then
        mainMenu.handle(key)
    else
        gameplay.handle(key)
    end
end

return keyHandler
