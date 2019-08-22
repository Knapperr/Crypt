-- !file: dynamic_entity.lua

DynamicEntity = Entity:extend()

function DynamicEntity:new(x, y, width, height, image)
    DynamicEntity.super.new(self, x, y, width, height, image)
    self.xVelocity = 0
    self.yVelocity = 0
    self.terminalVelocity = 800 -- so our velocity can't get to the extreme while falling
    self.onGround = false
    self.gravity = 0
    self.weight = 0

    -- Keep track of the last x and y values
    self.last = {}
    self.last.x = self.x
    self.last.y = self.y
end

function DynamicEntity:update(dt)
    self.last.x = self.x
    self.last.y = self.y
    self:applyGravity(dt)
end

function DynamicEntity:applyGravity(dt)
    -- Update the physics
    if self.yVelocity < self.terminalVelocity then
        self.yVelocity = self.yVelocity + (self.gravity + self.weight) * dt
    else
        self.yVelocity = self.terminalVelocity
    end
end
