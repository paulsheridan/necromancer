-- src/draw/slotSelection.lua
local slotSelectionDraw = {}

function slotSelectionDraw.draw()
    local startX, startY = 250, 50
    love.graphics.print("Select Part", startX, startY - 20)

    for i, part in ipairs(filteredParts) do
        if i == selectedFilteredIndex then
            love.graphics.setColor(0, 1, 0) -- highlight
        else
            love.graphics.setColor(1, 1, 1)
        end
        love.graphics.print(part.name, startX, startY + i * 20)
    end
    love.graphics.setColor(1, 1, 1)
end

return slotSelectionDraw
