-- src/draw/stationMenu.lua
local stationMenuDraw = {}

function stationMenuDraw.draw()
    local startX, startY = 50, 50
    love.graphics.print("Station Menu", startX, startY - 20)

    for i, slot in ipairs(slots) do
        local label = slot.key
        if equippedParts[slot.key] then
            label = label .. ": " .. equippedParts[slot.key].name
        end

        if i == selectedSlotIndex then
            love.graphics.setColor(1, 1, 0) -- highlight
        else
            love.graphics.setColor(1, 1, 1)
        end
        love.graphics.print(label, startX, startY + i * 20)
    end
    love.graphics.setColor(1, 1, 1)
end

return stationMenuDraw
