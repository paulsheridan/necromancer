function gameStart()
    math.randomseed(os.time())
    love.graphics.setBackgroundColor(26 / 255, 26 / 255, 26 / 255)

    -- Make pixels scale!
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- 3 parameters: fullscreen, width, height
    -- width and height are ignored if fullscreen is true
    fullscreen = false
    testWindow = false
    vertical = false
    setWindowSize(fullscreen, 1280, 800)

    if vertical then
        fullscreen = false
        testWindow = true
        setWindowSize(fullscreen, 1360, 1920)
    end

    -- The game's graphics scale up, this method finds the right ratio
    setScale()

    vector = require "libraries/hump/vector"
    flux = require "libraries/flux/flux"
    anim8 = require("libraries/anim8/anim8")
    sti = require("libraries/sti")

    local windfield = require("libraries/windfield")
    world = windfield.newWorld(0, 0, false)
    world:setQueryDebugDrawing(true)

    -- This second world is for particles, and has downward gravity
    particleWorld = windfield.newWorld(0, 250, false)
    particleWorld:setQueryDebugDrawing(true)


    love.graphics.setDefaultFilter("nearest", "nearest")

    gameMap = sti('maps/kenney/roguelikeMap.lua')

    require("src/startup/require")
    requireAll()
end

function setScale(input)
    scale = (3 / 1200) * windowHeight

    if vertical then
        scale = (7 / 1200) * windowHeight
    end

    if cam then
        cam:zoomTo(scale)
    end
end

function setWindowSize(full, width, height)
    if full then
        fullscreen = true
        love.window.setFullscreen(true)
        windowWidth = love.graphics.getWidth()
        windowHeight = love.graphics.getHeight()
    else
        fullscreen = false
        if width == nil or height == nil then
            windowWidth = 1920
            windowHeight = 1080
        else
            windowWidth = width
            windowHeight = height
        end
        love.window.setMode(windowWidth, windowHeight, { resizable = not testWindow })
    end
end
