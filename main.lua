function love.load()

    require("src/startup/gameStart")
    gameStart()

    gamePaused = false
    numNpcs = 4

    walls = {}
    -- if gameMap.layers["Objects"] then
    --     for i, obj in pairs(gameMap.layers["Objects"].objects) do
    --         local wall = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
    --         wall:setType("static")
    --         table.insert(walls, wall)
    --     end
    -- end

   npcs:spawn()
end

function love.update(dt)
    if not gamePaused then
        updateAll(dt)
    end
end

function love.draw()
    cam:attach()
        drawCamera()
    cam:detach()

    if gamePaused then
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Game Paused", 0, love.graphics.getHeight() / 2 - 10, love.graphics.getWidth(), "center")
    end
end

function love.keypressed(key)
    if key == "p" then
        gamePaused = not gamePaused
    end
end
