--!file: player.lua
Player = DynamicEntity:extend()

function Player:new(image, x, y, width, height)
    Player.super.new(self, x, y, width, height, image)
    self.speed = 110
    self.gravity = 630
    self.weight = 60
    self.jumpVelocity = -230
    self.timeToThrow = 0

    -- Animation
    local g = anim8.newGrid(32, 32, image:getWidth(), image:getHeight())
    self.animation = anim8.newAnimation(g('1-5', 1), 0.1)
    self.animationFlipped = anim8.newAnimation(g('1-5', 1), 0.1):flipH()
end

function Player:update(dt)
   -- super contains applyGravity
   Player.super.update(self, dt)
   self:movement(dt)
   self:controls(dt)
end

function Player:movement(dt)
    -- No animation when not moving
    if self.xVelocity == 0 then
        self.animation:gotoFrame(1)
        self.animationFlipped:gotoFrame(1)
    end

    -- Animation & movement
    if love.keyboard.isDown("a") then
        self.direction = -1
        self.animationFlipped:update(dt)
        self.xVelocity = -self.speed
    elseif love.keyboard.isDown("d") then
        self.direction = 1
        self.animation:update(dt)
        self.xVelocity = self.speed
    else
        self.xVelocity = 0
    end

    if love.keyboard.isDown("w") then
        self:jump()
    end

    -- Increate the x and y values
    self.x = self.x + self.xVelocity * dt
    self.y = self.y + self.yVelocity * dt
end

function Player:jump()
   if self.onGround == true then
       self.onGround = false
       self.yVelocity = self.jumpVelocity
   end
end

function Player:controls(dt)
    -- Timer for throwing
    self.timeToThrow = self.timeToThrow - dt
    if self.timeToThrow <= 0 then
        self.timeToThrow = 0
    end

    if love.keyboard.isDown("space") and self.timeToThrow <= 0 then
        self.timeToThrow = 1.2
        self:createTree()
    end
end

function Player:createTree()
    local treeImage = love.graphics.newImage("data/image/tree.png")
    newTree = Tree(treeImage, self.x + 30, self.y - 10, 32, 64)
    -- Add this to our entities
    table.insert(entities, newTree)
end

function Player:draw()
    if self.image ~= nil then
        if self.direction == 1 then
            self.animation:draw(self.image, math.floor(self.x) , math.floor(self.y))
        elseif self.direction == -1 then
            self.animationFlipped:draw(self.image, math.floor(self.x) , math.floor(self.y))
        end
    end
end
