Object = Object or require "object"
require "scripts/geometry"

BoxCollider = Object:extend()

function BoxCollider:new(parent, x_offset, y_offset, width, height, corner_buffer, ray_spacing)
    self.parent = parent
    self.x = function() return parent:getX() + x_offset end
    self.y = function() return parent:getY() + y_offset end
    self.width = width
    self.height = height
    self.corner_buffer = corner_buffer or 0
    self.ray_spacing = ray_spacing or 2

    self.left = function() return self.x() end
    self.center_x = function() return self.x() + self.width / 2 end
    self.right = function() return self.x() + self.width end

    self.top = function() return self.y() end
    self.center_y = function() return self.y() + self.height / 2 end
    self.bottom = function() return self.y() + self.height end

    self.velocity = function() return {x = self.parent.velocity.x, y = self.parent.velocity.y} end
end

function BoxCollider:draw()
    if DEBUG and DEBUG.draw_colliders then
        -- Set color to red
        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle("line", self.x(), self.y(), self.width, self.height)
        -- Set back to white
        love.graphics.setColor(1, 1, 1)
    end

    if DEBUG and DEBUG.draw_collider_rays then
        -- Set color to blue
        love.graphics.setColor(0, 0, 1)

        for _, ray in pairs(self.rays) do
            ray:draw()
        end

        -- Set back to white
        love.graphics.setColor(1, 1, 1)
    end
end

--[[ Words ]]
function BoxCollider:checkCollisions()
    -- Check for all collisions and report back to the parent object.
    -- For now, we'll just check tile collisions, but in the future we can also check for collisions with other objects.
    local collisions = {}
    local tile = self:checkTileCollision() or nil
    collisions.tiles = tile
    return collisions
end

function BoxCollider:checkTileCollision()
    local collisions = {
        up = nil,
        down = nil,
        left = nil,
        right = nil
    }
    self.rays = {}

    -- Check for collisions across the top and bottom of the collider
    print("FIX COLLISIONS DUMMY, I'M TOO TIRED FOR THIS GRANDPA")


    return collisions
end
