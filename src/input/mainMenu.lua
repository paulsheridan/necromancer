-- src/input/mainMenu.lua
local mainMenu = {}

function mainMenu.handle(key)
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
end

return mainMenu
