-- bodypart.lua
local BodyPart = {}
BodyPart.__index = BodyPart

function BodyPart.new(name, slot, attributes)
    local self = setmetatable({}, BodyPart)
    self.name = name
    self.slot = slot or "generic"
    self.attributes = attributes or {}
    return self
end

function BodyPart:describe()
    return self.name .. " (" .. self.slot .. ")"
end

return BodyPart
