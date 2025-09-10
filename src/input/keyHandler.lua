-- src/input/keyHandler.lua
local keyHandler = {}

function keyHandler.getControlled()
    return possessedNpc or player
end

function keyHandler.handleKeyPressed(key)
    -- Pause toggle
    if key == "p" then
        gamePaused = not gamePaused
        return
    end

    -- Station Slot Selection Menu
    if stationMenuOpen and slotSelectionMenuOpen then
        if key == "up" then
            selectedFilteredIndex = math.max(1, selectedFilteredIndex - 1)
        elseif key == "down" then
            selectedFilteredIndex = math.min(#filteredParts, selectedFilteredIndex + 1)
        elseif key == "e" then
            local chosen = filteredParts[selectedFilteredIndex]
            if chosen then
                for i, item in ipairs(player.inventory.items) do
                    if item == chosen then
                        table.remove(player.inventory.items, i)
                        break
                    end
                end
                local slot = slots[selectedSlotIndex]
                equippedParts[slot.key] = chosen
            end
            slotSelectionMenuOpen = false
        elseif key == "escape" or key == "q" then
            slotSelectionMenuOpen = false
        end
        return
    end

    -- Station Menu
    if stationMenuOpen then
        if key == "up" then
            selectedSlotIndex = math.max(1, selectedSlotIndex - 1)
        elseif key == "down" then
            selectedSlotIndex = math.min(#slots, selectedSlotIndex + 1)
        elseif key == "e" then
            local slot = slots[selectedSlotIndex]
            if slot.key == "BUILD" then
                if allSlotsFilled() then
                    spawnBuiltMonster()
                end
            else
                filteredParts = {}
                for _, part in ipairs(player.inventory.items) do
                    if part.slot == slot.key then
                        table.insert(filteredParts, part)
                    end
                end
                if #filteredParts > 0 then
                    slotSelectionMenuOpen = true
                    selectedFilteredIndex = 1
                end
            end
        elseif key == "q" then
            local slot = slots[selectedSlotIndex]
            if slot.key ~= "BUILD" then
                local part = equippedParts[slot.key]
                if part then
                    table.insert(player.inventory.items, part)
                    equippedParts[slot.key] = nil
                end
            end
        elseif key == "escape" then
            stationMenuOpen = false
        end
        return
    end

    -- NPC + Inventory Menu
    if menuOpen then
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
        return
    end

    -- Normal gameplay
    local entity = keyHandler.getControlled()

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

return keyHandler
