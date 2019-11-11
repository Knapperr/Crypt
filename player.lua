--!file: player.lua
Player = DynamicEntity:extend()

function Player:new(image, x, y, width, height, name)
    Player.super.new(self, x, y, width, height, image, name)
    self.speed = 40
    self.maxSpeed = 180
    self.gravity = 360
    self.weight = 50
    self.jumpVelocity = -175
    self.timeToThrow = 0
    self.dead = false

    -- Direction
    self.left = -1
    self.right = 1
    self.direction = self.right

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
  -- NOTE: Don't need to call movecolliding
  -- super is calling it already using
  -- my overloaded version
  -- self:moveColliding(dt)
end

function Player:movement(dt)
    -- No animation when not moving
    if self.xVelocity == 0 then
        self.animation:gotoFrame(1)
        self.animationFlipped:gotoFrame(1)
    end

    -- Animation & movement
    if love.keyboard.isDown("a") then
        if self.direction ~= self.left then 
            self:createDust(self.left)
        end

        self.direction = self.left
        self.animationFlipped:update(dt)
        self.xVelocity = self.xVelocity - self.speed
        if self.xVelocity <= -self.maxSpeed then
            self.xVelocity = -self.maxSpeed
        end
        --self.xVelocity = -self.speed
    elseif love.keyboard.isDown("d") then
        if self.direction ~= self.right then
            self:createDust(self.right)
        end
        self.direction = self.right
        self.animation:update(dt)
        
        self.xVelocity = self.xVelocity + self.speed
        if self.xVelocity >= self.maxSpeed then
            self.xVelocity = self.maxSpeed
        end
        --self.xVelocity = self.speed
    else
        self.xVelocity = 0
    end

    if love.keyboard.isDown("w") then
        self:jump()
    end

    -- Increase the x and y values
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
    newTree = Tree(treeImage, self.x + 60, self.y - 10, 32, 64, "tree")
    -- Add this to our entities
    table.insert(entities, newTree)
end

function Player:createDust(direction)
    local position = 0
    if direction == self.left then
        position = 10
    elseif direction == self.right then
        position = -10
    end 

    local dustImage = love.graphics.newImage("data/image/dust.png")
    dust = Image(self.x - position, self.y + 10, 10, 10, dustImage)
    table.insert(images, dust)
end

-- Draw Call
------------------------------------------------------------------------------------------
function Player:draw()
    if self.image ~= nil then
        if self.direction == self.right then
            self.animation:draw(self.image, math.floor(self.x) , math.floor(self.y))
        elseif self.direction == self.left then
            self.animationFlipped:draw(self.image, math.floor(self.x) , math.floor(self.y))
        end
    end
end

-- Collisions
----------------------------------------------------------------------------------------
function Player:filter(other)
    if other.name == "powerup" then
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
            -- TODO: Add actual logic
            -- Dead restart game
            self.dead = true
        end
        if otherCollisionName == "slowblock" then
            self.gravity = 200
            self.weight = 50
        end
        if otherCollisionName == "powerup" then
            -- TODO: change to speedincrease() function
            self.speed = 250
        end
    end
end

