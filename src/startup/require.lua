function requireAll()
    require("src/startup/collisionClasses")
    createCollisionClasses()

    require('src/utilities/cam')
    require('src/utilities/utils')
    require('src/player')
    require('src/update')
    require('src/npcs')
    require('src/character')
    require('src/draw')
end
