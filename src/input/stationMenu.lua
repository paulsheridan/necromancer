-- src/input/stationMenu.lua
local stationMenu = {}

function stationMenu.handle(key)
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
end

return stationMenu
