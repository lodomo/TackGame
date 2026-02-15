-- Love2D Hello World with low-res rendering
-- Renders at 1/5th of 1080p (384x216) and stretches to fullscreen

function love.load()
    -- Set up the window to fullscreen
    love.window.setMode(0, 0, { fullscreen = true })

    -- Get actual screen dimensions
    local screenWidth, screenHeight = love.graphics.getDimensions()

    -- Calculate 1/5th of 1080p
    local renderWidth = 1920 / 5  -- 384
    local renderHeight = 1080 / 5 -- 216

    -- Create a canvas at the low resolution
    canvas = love.graphics.newCanvas(renderWidth, renderHeight)
    canvas:setFilter("nearest", "nearest") -- Set filter for the canvas

    -- Calculate scale factors to stretch to fullscreen
    scaleX = screenWidth / renderWidth
    scaleY = screenHeight / renderHeight

    -- Load the background image
    background = love.graphics.newImage("sprites/backgrounds/background.png")
    background:setFilter("nearest", "nearest") -- Set filter for the background image

    -- Set filter mode to nearest neighbor for crisp pixel scaling
    love.graphics.setDefaultFilter("nearest", "nearest")
end

function love.draw()
    -- Draw everything to the low-res canvas
    love.graphics.setCanvas(canvas)
    love.graphics.clear()

    -- Draw the background stretched across the entire canvas
    love.graphics.draw(background, 0, 0, 0,
        canvas:getWidth() / background:getWidth(),
        canvas:getHeight() / background:getHeight())

    -- Reset canvas to screen
    love.graphics.setCanvas()

    -- Draw the canvas stretched to fullscreen
    love.graphics.draw(canvas, 0, 0, 0, scaleX, scaleY)
end

function love.keypressed(key)
    -- Press Escape to quit
    if key == "escape" then
        love.event.quit()
    end
end
