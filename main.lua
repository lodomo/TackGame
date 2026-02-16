-- Tack Game 2026
-- Copyright (c) 2026 by Lodomo.dev

require("tack")
require("input_state")

-- B is button 3

---[[
function love.load()
    -- Keeps pixel art crisp
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- Base game runs at 216x384 (Portrait 1/5th of 1080p)
    -- Graphics may be drawn outside of this area, but the UI will be designed to fit
    RESOLUTION = {
        width = 216,
        height = 384
    }

    SCALE = 3

    -- Create a window at 3x the base resolution 
    love.window.setMode(
        RESOLUTION.width * SCALE,
        RESOLUTION.height * SCALE,
        { fullscreen = false }
    )

    BACKGROUND = love.graphics.newImage("sprites/backgrounds/background.png")

    LOW_RES_CANVAS = love.graphics.newCanvas(RESOLUTION.width, RESOLUTION.height)

    JOYSTICKS = love.joystick.getJoysticks()
    print("Joysticks found: " .. #JOYSTICKS)

    TACK = Tack()
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

    TACK:draw()

    -- Reset canvas to screen
    love.graphics.setCanvas()

    -- Draw the low-res canvas stretched to fullscreen
    love.graphics.draw(LOW_RES_CANVAS, 0, 0, 0, SCALE, SCALE)

end
--]]

---[[
function love.update(dt)
    TACK:update(dt)
    -- Listen for escape key to quit
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end
end
--]]
