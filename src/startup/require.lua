function requireAll()
    require("src/startup/collisionClasses")
    createCollisionClasses()

    require('src/utilities/cam')
    require('src/utilities/utils')
    require('src/monster/bodypart')
    require('src/player')
    require('src/update')
    require('src/npcs')
    require('src/monster/monsters')
    require('src/character')
    require('src/draw')
end
