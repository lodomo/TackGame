Object = Object or require("/libs/classic")

Tile = Object:extend()

function Tile:new(filename, type)
    self.filename = filename
    self.image = love.graphics.newImage("sprites/tiles/" .. filename .. ".png")
    self.type = type
end

TileMap = Object:extend()

function TileMap:new(origin, tile_size, map_data_image_path, color_tile_map)
    self.origin = origin or {x = 0, y = 0}
    self.tile_size = tile_size
    local map_data = love.image.newImageData(map_data_image_path)
    self.map = {}
    self.color_tile_map = color_tile_map

    for x = 0, map_data:getWidth() - 1 do
        self.map[x] = {}
        for y = 0, map_data:getHeight() - 1 do
            local r, g, b, a = map_data:getPixel(x, y)
            r = math.floor(r * 255 + 0.5)
            g = math.floor(g * 255 + 0.5)
            b = math.floor(b * 255 + 0.5)
            a = math.floor(a * 255 + 0.5)
            local asInt = r * (2^24) + g * (2^16) + b * (2^8) + a
            self.map[x][y] = asInt
        end
    end

    -- Add self to the global OBJECTS table
    table.insert(TILEMAPS, self)
end

function TileMap:draw()
    -- For now, draw the tile map as a grid of colored rectangles
    for x, column in pairs(self.map) do
        for y, tile in pairs(column) do

            local position = {
                x = self.origin.x + x * self.tile_size,
                y = self.origin.y + y * self.tile_size
            }

            local tile_image = self.color_tile_map[tile] and self.color_tile_map[tile].image or nil
            if tile_image then
                love.graphics.draw(tile_image, position.x, position.y)
            end
        end
    end
end

function TileMap:update(dt)
    -- Tile maps are static, so no update logic is needed for now.
end


function TileMap:getTileAtPixel(x, y)
    local tileX = math.floor((x - self.origin.x) / self.tile_size)
    local tileY = math.floor((y - self.origin.y) / self.tile_size)

    if not self.map[tileX] or not self.map[tileX][tileY] then
        return nil
    end

    return self.color_tile_map[self.map[tileX][tileY]] and self.color_tile_map[self.map[tileX][tileY]].type or nil
end
