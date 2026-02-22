Object = Object or require("/libs/classic")

Platform = Object:extend()

function Platform:new(x, y, width, height, color)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.color = color or { 0.5, 0.5, 0.5 }

    self.top_solid = true
    self.bottom_solid = false
    self.left_solid = false
    self.right_solid = false

    -- Add self to the global OBJECTS table
    table.insert(OBJECTS, self)
end

function Platform:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    love.graphics.setColor(1, 1, 1) -- Reset color to white
end

function Platform:update(dt)
    -- Platforms are static, so no update logic is needed for now.
end
