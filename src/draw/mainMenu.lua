-- src/draw/mainMenu.lua
local mainMenuDraw = {}

function mainMenuDraw.draw()
    local startX, startY = 50, 300
    love.graphics.print("Main Menu (" .. menuPane .. ")", startX, startY - 20)

    if menuPane == "npcs" then
        for i, npc in ipairs(markedNpcs) do
            if i == selectedMenuIndex then
                love.graphics.setColor(0, 1, 1)
            else
                love.graphics.setColor(1, 1, 1)
            end
            love.graphics.print("NPC " .. tostring(i), startX, startY + i * 20)
        end
    elseif menuPane == "inventory" then
        for i, item in ipairs(player.inventory.items) do
            if i == selectedInventoryIndex then
                love.graphics.setColor(0, 1, 1)
            else
                love.graphics.setColor(1, 1, 1)
            end
            love.graphics.print(item.name, startX, startY + i * 20)
        end
    end

    love.graphics.setColor(1, 1, 1)
end

return mainMenuDraw
