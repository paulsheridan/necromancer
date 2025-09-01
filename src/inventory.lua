-- inventory.lua
local Inventory = {}
Inventory.__index = Inventory

function Inventory.new()
    local self = setmetatable({}, Inventory)
    self.items = {}
    return self
end

function Inventory:add(item)
    table.insert(self.items, item)
end

function Inventory:remove(index)
    table.remove(self.items, index)
end

function Inventory:list()
    for i, item in ipairs(self.items) do
        print(i .. ". " .. item.name .. " (" .. item.slot .. ")")
    end
end

return Inventory
