-- src/input/gameplay.lua
local gameplay = {}

local function getControlled()
    return possessedNpc or player
end

function gameplay.handle(key)
    local entity = getControlled()

    if key == "f" then
        markedNpc = player:markNearbyNpc()
    elseif key == "m" then
        menuOpen = not menuOpen
        menuPane = "npcs"
        selectedMenuIndex = 1
        selectedInventoryIndex = 1
    elseif key == "e" then
        local dx = entity.x - assemblyStation.x
        local dy = entity.y - assemblyStation.y

        if math.abs(dx) < 40 and math.abs(dy) < 40 then
            stationMenuOpen = true
            selectedSlotIndex = 1
        elseif possessedNpc then
            possessedNpc = nil
        end
    end
end

return gameplay
