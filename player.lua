--!file: player.lua
Player = DynamicEntity:extend()

function Player:new(image, x, y, width, height, name)
    Player.super.new(self, x, y, width, height, image, name)
    self.speed = 150
    self.gravity = 530
    self.weight = 50
    self.jumpVelocity = -170
    self.timeToThrow = 0

    -- Animation
    local g = anim8.newGrid(32, 32, image:getWidth(), image:getHeight())
    self.animation = anim8.newAnimation(g('1-5', 1), 0.1)
    self.animationFlipped = anim8.newAnimation(g('1-5', 1), 0.1):flipH()
end

-- Update & Movement
------------------------------------------------------------------------------------------
function Player:update(dt)
   -- super contains applyGravity
   Player.super.update(self, dt)
   self:movement(dt)
   self:controls(dt)
   self:moveColliding(dt)
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

-- Controls
------------------------------------------------------------------------------------------
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
    newTree = Tree(treeImage, self.x + 30, self.y - 10, 32, 64, "tree")
    -- Add this to our entities
    table.insert(entities, newTree)
end

-- Draw Call
------------------------------------------------------------------------------------------
function Player:draw()
    if self.image ~= nil then
        if self.direction == 1 then
            self.animation:draw(self.image, math.floor(self.x) , math.floor(self.y))
        elseif self.direction == -1 then
            self.animationFlipped:draw(self.image, math.floor(self.x) , math.floor(self.y))
        end
    end
end

-- Collisions
----------------------------------------------------------------------------------------
function Player:filter(other)
    if other.name == "slowblock" then
        return 'cross'
    else
        return 'slide'
    end
end

function Player:moveColliding(dt)
    local destX = self.x + self.xVelocity * dt
    local destY =  self.y + self.yVelocity * dt
    local nextX, nextY = 0, 0

    nextX, nextY, cols = world:move(self, destX, destY, self.filter)
    self.x, self.y = nextX, nextY
    self:checkCollisions(dt)
end

function Player:checkCollisions(dt)
    -- Reset if an entity is touching the ground
    self.onGround = false
    for i,col in ipairs (cols) do
        local otherCollisionName = tostring(col.other.name)
        if col.normal.y == -1 or col.normal.y == 1 then
            self.yVelocity = 0
        end
        if col.normal.y == -1  then
            self.onGround = true
        end
        if otherCollisionName == "spike" then
            self.speed = 300
        end
        if otherCollisionName == "slowblock" then
            self.gravity = 200
            self.weight = 50
        end
    end
end
