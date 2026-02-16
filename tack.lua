Object = Object or require("/libs/classic")

Tack = Object:extend()

function Tack:new()
    self.width = 24
    self.height = 32

    self.x = RESOLUTION.width / 2 - self.width / 2
    self.y = RESOLUTION.height - 32 - 50
    self.color = { 189 / 255, 81 / 255, 90 / 255 }

    self.velocity = {
        x = 0,
        y = 0
    }

    self.max_jump_velocity = 500
    self.jump_charge_time = 0.5
    self.jump_charge = 0

    self.floor_y = RESOLUTION.height - self.height - 50

    local function getAxis()
        return JOYSTICKS[1] and JOYSTICKS[1]:getAxis(2) or 0
    end

    self.axis = getAxis
    self.grounded = false
    self.gravity = 500
end

function Tack:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    love.graphics.setColor(1, 1, 1) -- Reset color to white
end

function Tack:printStatus()
    print("Tack status:")
    print("  Position: (" .. self.x .. ", " .. self.y .. ")")
    print("  Velocity: (" .. self.velocity.x .. ", " .. self.velocity.y .. ")")
    print("  Axis: " .. self.axis())
    print("  Grounded: " .. tostring(self.grounded))
    print("  Jump Charge: " .. self.jump_charge)
    print("  Floor Y: " .. self.floor_y)
end

function Tack:update(dt)
    self:printStatus()

    if self.axis() > 0.1 and self.grounded then
        self.jump_charge = self.jump_charge + (self.max_jump_velocity / self.jump_charge_time) * dt
        self.jump_charge = math.min(self.jump_charge, self.max_jump_velocity)
    end

    if self.axis() >= -0.1 and self.axis() <= 0.1 and self.jump_charge > 0 then
        self.velocity.y = -self.jump_charge
        self.jump_charge = 0
    end

    if self.axis() < -0.1 then
        self.velocity.y = 0
    elseif self.y >= self.floor_y and self.velocity.y >= 0 then
        self.y = self.floor_y
        self.velocity.y = 0
        self.grounded = true
    else
        -- Apply gravity
        self.velocity.y = self.velocity.y + self.gravity * dt
        self.grounded = false
    end

    self.x = self.x + self.velocity.x * dt
    self.y = self.y + self.velocity.y * dt
end
