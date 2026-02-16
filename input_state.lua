Object = Object or require("/libs/classic")

InputState = Object:extend()

function InputState:new(buttonIsDownFunction)
    self.buttonIsDown = buttonIsDownFunction

    self.is_pressed = false
    self.was_pressed = false

    self.pressed_this_frame = false
    self.released_this_frame = false

    self.press_duration = 0
    self.release_duration = 0
end

function InputState:update(dt)
    self.was_pressed = self.is_pressed
    self.is_pressed = self.buttonIsDown()

    self.pressed_this_frame = self.is_pressed and not self.was_pressed
    self.released_this_frame = not self.is_pressed and self.was_pressed

    if self.is_pressed then
        self.press_duration = self.press_duration + dt
        self.release_duration = 0
    else
        self.release_duration = self.release_duration + dt
        self.press_duration = 0
    end
end
