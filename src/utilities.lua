-- Check proximity
function isNear(entity1, entity2, distance)
    local dx = entity1.x - entity2.x
    local dy = entity1.y - entity2.y
    return (dx * dx + dy * dy) <= (distance * distance)
end
