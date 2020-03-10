--!file: player.lua
Player = DynamicEntity:extend()

function Player:new(image, x, y, width, height, name)
    Player.super.new(self, x, y, width, height, image, name)
    self.speed = 5
    self.maxSpeed = 180
    self.gravity = 365
    self.weight = 55
    self.jumpVelocity = -165
    self.timeToThrow = 0
    self.dead = false

    -- State
    self.state = 0

    -- Direction
    self.left = -1
    self.right = 1
    self.direction = self.right

    -- Controller direction
    self.stickDirection = 0

    -- reset ox and oy because our image is very long (sprite sheet)
    self.ox = self.image:getWidth() / 14.5
    self.oy = self.image:getHeight() / 2

    -- Animation
    local g = anim8.newGrid(32, 32, image:getWidth(), image:getHeight())
    self.animation = anim8.newAnimation(g('1-5', 1), 0.1)
    self.animationFlipped = anim8.newAnimation(g('1-5', 1), 0.1):flipH()
end

-- Update & Movement
------------------------------------------------------------------------------------------
function Player:update(dt)
    self.stickDirection = joystick:getGamepadAxis("leftx")
    -- super contains applyGravity
    Player.super.update(self, dt)
    self:movement(dt)
    self:controls(dt)
    -- NOTE: Don't need to call movecolliding
    -- super is calling it already using
    -- my overloaded version
    -- self:moveColliding(dt)
end

-- 0 = Not touching a float block
-- 1 = Touching a float block
function Player:changeAttributes(state)
    if state == 0 then
        self.state = 0 -- TODO: REMOVE THIS
        self.gravity = 365
        self.weight = 55
        self.jumpVelocity = -165
        self.yVelocity = 0
        self.onGround = true
    elseif state == 1 then
        self.state = 1 -- TODO: REMOVE THIS
        self.onGround = true
        self.gravity = 375
        self.weight = 40
        self.yVelocity = 9
        self.jumpVelocity = -175
    end
end

function Player:movement(dt)
    -- No animation when not moving
    if self.xVelocity == 0 then
        self.animation:gotoFrame(1)
        self.animationFlipped:gotoFrame(1)
    end

    -- Animation & movement
    if love.keyboard.isDown("a") or joystick:isGamepadDown("dpleft") or self.stickDirection == -1 then
        if self.direction ~= self.left then
            --self:createDust(self.left)
        end

        self.direction = self.left
        self.animationFlipped:update(dt)
        self.xVelocity = self.xVelocity - self.speed
        if self.xVelocity <= -self.maxSpeed then
            self.xVelocity = -self.maxSpeed
        end
    elseif love.keyboard.isDown("d") or joystick:isGamepadDown("dpright") or self.stickDirection == 1  then
        if self.direction ~= self.right then
            --self:createDust(self.right)
        end
        self.direction = self.right
        self.animation:update(dt)

        self.xVelocity = self.xVelocity + self.speed
        if self.xVelocity >= self.maxSpeed then
            self.xVelocity = self.maxSpeed
        end
    else
        self.xVelocity = 0
    end

    if love.keyboard.isDown("w") or joystick:isGamepadDown("a")  then
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
            self.animation:draw(self.image, math.floor(self.x), math.floor(self.y), 0, 1, 1, self.ox, self.oy)
        elseif self.direction == self.left then
            self.animationFlipped:draw(self.image, math.floor(self.x), math.floor(self.y), 0, 1, 1, self.ox, self.oy)
        end

        if showDebug == true then
            love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
        end
    end
end

-- Collisions
----------------------------------------------------------------------------------------
function Player:filter(other)
    if other.name == "powerup" or other.name == "float" or other.name == "slowblock" then
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


        -- NOTE: CANT CHECK THIS... need to think of another way
        -- maybe do an if first saying if its slowblock whatever self.onGround = false
        -- then say elseif
        -- THIS IS WORKING
        -- NOTE: Maybe ditch the states for now..?
        if otherCollisionName == "slowblock" then
            self.onGround = false
        elseif otherCollisionName == "float" then
            self:changeAttributes(1)
        elseif col.normal.y == -1 or col.normal.y == 1 then
            self:changeAttributes(0)
            --self.onGround = true
        end
        -- NOTE: END COMMENT
        --------------------------------------------------
        if otherCollisionName == "spike" then
            -- TODO: Add actual logic
            -- Dead restart game
            self.dead = true
        end
        if otherCollisionName == "powerup" then
            -- TODO: change to speedincrease() function
            self.speed = 250
        end
    end
end
