-- src/input/slotSelection.lua
local slotSelection = {}

function slotSelection.handle(key)
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
end

return slotSelection
