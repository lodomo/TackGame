Object = Object or require "/libs/classic"

Point = Object:extend()

function Point:new(x, y)
    self.x = x
    self.y = y
end

Ray = Point:extend()

function Ray:new(x, y, velocity)
    Point.new(self, x, y)
    self.x1 = x + velocity.x
    self.y1 = y + velocity.y
end

function Ray:draw()
    love.graphics.line(self.x, self.y, self.x1, self.y1)
end
