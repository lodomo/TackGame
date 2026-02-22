-- Tack Game 2026
-- Copyright (c) 2026 by Lodomo.dev

require("scripts/tack")
require("scripts/platform")
require("scripts/tilemap")


---[[
function love.load()
    DEBUG = {
        draw_colliders= true,
        draw_collider_rays = true,
        illegal_movement = true
    }
    print("Debug mode is on")
    print("Debug options:")
    for option, value in pairs(DEBUG) do
        print(option .. ": " .. tostring(value))
    end

    -- Keeps pixel art crisp
    love.graphics.setDefaultFilter("nearest", "nearest")

    RESOLUTION = {
        width = 270,
        height = 480
    }

    SCALE = 2
    LOW_RES_CANVAS = love.graphics.newCanvas(RESOLUTION.width, RESOLUTION.height)
    JOYSTICKS = love.joystick.getJoysticks()

    -- Create a window at scaled resolution
    love.window.setMode(
        RESOLUTION.width * SCALE,
        RESOLUTION.height * SCALE,
        { fullscreen = false }
    )

    BACKGROUND = love.graphics.newImage("sprites/backgrounds/background.png")

    PLAYERS = {}
    TILEMAPS = {}
    OBJECTS = {}

    TILEMAP = TileMap(
        {x = 0, y = 0},
        16,
        "sprites/tilemaps/tilemap.png",
        {
            [0x23213dff] = Tile("block", "solid"),
            [0x5c3841ff] = Tile("platform", "platform"),
        }
    )

    CLOCK = 0
    GRAVITY = 1.75

    TACK = Tack({
        x = RESOLUTION.width / 2,
        -- y = 416
        y = 0
    })

    -- Turn off vsync
    love.window.setVSync(0)
end
--]]

---[[
function love.draw()
    -- Draw to the low-res canvas
    love.graphics.setCanvas(LOW_RES_CANVAS)
    love.graphics.clear()

    -- Draw the background stretched to fill the entire canvas
    love.graphics.draw(BACKGROUND, 0, 0, 0,
        RESOLUTION.width / BACKGROUND:getWidth(),
        RESOLUTION.height / BACKGROUND:getHeight())

    for _, tilemap in ipairs(TILEMAPS) do
        tilemap:draw()
    end

    for _, object in ipairs(OBJECTS) do
        object:draw()
    end

    for _, player in ipairs(PLAYERS) do
        player:draw()
    end

    -- Reset canvas to screen
    love.graphics.setCanvas()

    -- Draw the low-res canvas stretched to fullscreen
    love.graphics.draw(LOW_RES_CANVAS, 0, 0, 0, SCALE, SCALE)
end
--]]

---[[
function love.update(dt)
    --[[
    -- Remove 1 second for dt to simulate slow motion since I'm sleeping for 1 second.
    while dt > 1 do
        dt = dt - 1
    end
    --]]
    CLOCK = CLOCK + dt

    for _, tilemap in ipairs(TILEMAPS) do
        tilemap:update(dt)
    end

    for _, object in ipairs(OBJECTS) do
        object:update(dt)
    end

    for _, player in ipairs(PLAYERS) do
        player:update(dt)
    end

    -- Listen for escape key to quit
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end

    --[[
    -- Sleep for 1 second
    love.timer.sleep(1 + 1/60)
    --]]
end
--]]
