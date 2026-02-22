Object = Object or require("/libs/classic")
require("scripts/collider")

Tack = Object:extend()

function Tack:new(spawn)
    self.height = 48
    self.width = 48

    self.x = spawn.x
    self.y = spawn.y
    self.color = { 189 / 255, 81 / 255, 90 / 255 }

    self.collider = BoxCollider(self, 15, 8, 18, 32)

    self.velocity = {
        x = 0,
        y = 0
    }

    self.states = {
        idle = {
            sprites = self:load_animation("sprites/tack/idle"),
            update = self.update_idle,
            draw = self.draw_idle,
        },
        jumping = {
            sprites = self:load_animation("sprites/tack/jumping"),
            update = self.update_jumping,
            draw = self.draw_jumping,
        },
        falling = {
            sprites = self:load_animation("sprites/tack/falling"),
            update = self.update_falling,
            draw = self.draw_falling,
        },
        pinning = {
            sprites = self:load_animation("sprites/tack/pinning"),
            update = self.update_pinning,
            draw = self.draw_pinning,
        },
        pinned = {
            sprites = self:load_animation("sprites/tack/pinned"),
            update = self.update_pinned,
            draw = self.draw_pinned,
        },
        unpin = {
            sprites = self:load_animation("sprites/tack/unpin"),
            update = self.update_unpin,
            draw = self.draw_unpin,
        },
        charging = {
            sprites = self:load_animation("sprites/tack/charging"),
            update = self.update_charging,
            draw = self.draw_charging,
        },
    }

    self.rays = {
        down = {
            x = function() return self.collider.x() + self.collider.width / 2 end,
            y = function() return self.collider.y() + self.collider.height end
        },
        up = {
            x = function() return self.collider.x() + self.collider.width / 2 end,
            y = function() return self.collider.y() end},
        left = {
            x = function() return self.collider.x() end,
            y = function() return self.collider.y() + self.collider.height / 2 end},
        right = {
            x = function() return self.collider.x() + self.collider.width end,
            y = function() return self.collider.y() + self.collider.height / 2 end},
    }

    self.state = self.states.idle
    self.max_jump_velocity = 400
    self.jump_charge_time = 0.5
    self.jump_charge = 0
    self.grounded = false

    self.animation_speed = 10 -- Frames per second
    self.current_frame = 1

    self.max_fall_speed = 25

    -- Add self to the global PLAYERS table
    table.insert(PLAYERS, self)
end

function Tack:getX()
    return self.x
end

function Tack:getY()
    return self.y
end

function Tack:getAxis()
    -- The only controls are up and down.
    -- This lets "down" "s" and joystick act as a single input
    -- and "up" "w" and joystick act as a single input.
    if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
        return 1
    end

    if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
        return -1
    end

    return JOYSTICKS[1] and JOYSTICKS[1]:getAxis(2) or 0
end

function Tack:getHorizonalAxis()
    if not DEBUG or not DEBUG.illegal_movement then
        return 0
    end

    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        return 1
    end

    if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        return -1
    end

    return JOYSTICKS[1] and JOYSTICKS[1]:getAxis(1) or 0
end

function Tack:load_animation(path)
    local animation = {}
    -- Debug first by printing the name of all the files in path
    local files = love.filesystem.getDirectoryItems(path)
    for _, file in ipairs(files) do
        local image = love.graphics.newImage(path .. "/" .. file)
        table.insert(animation, image)
    end
    return animation
end

function Tack:draw()
    self.state.draw(self)
    self.collider:draw()
end

function Tack:update(dt)
    -- Apply gravity to the velocity. Then let the state decide if it wants to nullify gravity.
    self.velocity.y = math.min(self.velocity.y + (GRAVITY * dt), self.max_fall_speed)
    self.state.update(dt)

    if self:getAxis() < -0.1 then
        self.velocity.y = -300 * dt
    end

    if self:getHorizonalAxis() > 0.1 then
        self.velocity.x = 100 * dt
    elseif self:getHorizonalAxis() < -0.1 then
        self.velocity.x = -100 * dt
    else
        self.velocity.x = self.velocity.x / 2 * dt
    end

    local collisions = self.collider:checkCollisions(self.velocity)

    if collisions.tiles then
        if collisions.tiles.up then
            print("Collided up")
        elseif collisions.tiles.down then
            print("Collided down")
        end
    end

    if self.velocity.y > 0 then
        self.state = self.states["falling"]
    end

    self.x = self.x + self.velocity.x
    self.y = self.y + self.velocity.y
    --[[
    if self:getAxis() > 0.1 and self.grounded then
        self.jump_charge = self.jump_charge + (self.max_jump_velocity / self.jump_charge_time) * dt
        self.jump_charge = math.min(self.jump_charge, self.max_jump_velocity)
    end

    if self:getAxis() >= -0.1 and self:getAxis() <= 0.1 and self.jump_charge > 0 then
        self.velocity.y = -self.jump_charge
        self.jump_charge = 0
    end

    if self:getAxis() < -0.1 then
        self.velocity.y = 0
    end

    -- Apply gravity
    self.velocity.y = self.velocity.y + GRAVITY * dt
    self.grounded = false

    self.x = self.x + self.velocity.x * dt
    self.y = self.y + self.velocity.y * dt
    --]]
end

function Tack:update_idle(dt)
end

function Tack:draw_idle()
    local frame = math.floor(CLOCK * self.animation_speed) % #self.state.sprites + 1
    self.current_frame = frame
    love.graphics.draw(self.state.sprites[frame], self.x, self.y)
end

function Tack:update_jumping(dt)
    self.current_animation = self.states.jumping.sprites
end

function Tack:draw_jumping()
    -- No special drawing logic for jumping state
end

function Tack:update_falling(dt)
    -- No special update logic for falling state
end

function Tack:draw_falling()
    -- No special drawing logic for falling state
    self:draw_idle() -- Same logic
end

function Tack:update_pinning(dt)
    -- No special update logic for pinning state
end

function Tack:draw_pinning()
    -- No special drawing logic for pinning state
end

function Tack:update_pinned(dt)
    -- No special update logic for pinned state
end

function Tack:draw_pinned()
    -- No special drawing logic for pinned state
end

function Tack:update_unpin(dt)
    -- No special update logic for unpin state
end

function Tack:draw_unpin()
    -- No special drawing logic for unpin state
end

function Tack:update_charging(dt)
    -- No special update logic for charging state
end

function Tack:draw_charging()
    -- No special drawing logic for charging state
end
