--!file: game.lua
Game = Object:extend()

function Game:new()
    self:load()
    self.showDebug = true

    -- How many collisions are happening
    self.cols_len = 0
end

function Game:load()
    -- global entities
    entities = {}

    -- init bump
    world = bump.newWorld()
    self.map = sti("data/tileset/level1.lua", { "bump" })
    self.map:bump_init(world)

    -- Grab the player from the map
    -- We can use this object loop to grab everything and just init it to the player
    local playerImage = love.graphics.newImage("data/image/skellyanim.png")
    local spikeImage = love.graphics.newImage("data/image/spike.png")
    local slowblockImage = love.graphics.newImage("data/image/slowblock.png")
    -- WxH is not based off of image. The image is a sprite sheet
    local playerWidth = 32
    local playerHeight = 32
    player = {}
    for k, object in pairs(self.map.objects) do
        if object.name == "Spike" then
            table.insert(entities, Spike(spikeImage, object.x, object.y, 32, 32, "spike"))
        elseif object.name == "SlowBlock" then
            table.insert(entities, SlowBlock(slowblockImage, object.x, object.y, 32, 32, "slowblock"))
        elseif object.name == "Player" then
            player = Player(playerImage, object.x, object.y, playerWidth, playerHeight, "player")
            table.insert(entities, player)
        end
    end
end

-- Update the game
function Game:update(dt)
    -- reset collisions
    self.map:update(dt)

    -- filter for player
    local playerFilter = function(item, other)
        if other.name == "slowblock" then
            return 'cross'
        else
            return 'slide'
        end
    end

    -- update all entities
    for i=1, #entities do
        local entity = entities[i]
        -- only update and check collisions for dynamic entities
        if entity:is(DynamicEntity) then
            entity:update(dt)

            local destX = entity.x + entity.xVelocity * dt
            local destY =  entity.y + entity.yVelocity * dt
            local nextX, nextY = 0, 0

            -- Only filter the player
            if entity.name == "player" then
                nextX, nextY, cols = world:move(entity, destX, destY, playerFilter)
            else
                nextX, nextY, cols = world:move(entity, destX, destY)
            end

            entity.x, entity.y = nextX, nextY
            self:checkCollisions(entity, cols)
        end
    end

    -- Debug controls
    if love.keyboard.isDown("1") then
        self.showDebug = false
    elseif love.keyboard.isDown("2") then
        self.showDebug = true
    end
end

-- Handle all collisions for the entity
function Game:checkCollisions(entity, cols)
    -- THIS GOES IN FUNCTION
    otherCollisionName = ""

    -- Reset if an entity is touching the ground
    entity.onGround = false
    for i,col in ipairs (cols) do
        otherCollisionName = tostring(col.other.name)
        if col.normal.y == -1 or col.normal.y == 1 then
            entity.yVelocity = 0
        end
        if col.normal.y == -1  then
            entity.onGround = true
        end
        if otherCollisionName == "spike" then
            entity.speed = 300
        end
        if otherCollisionName == "slowblock" then
            entity.gravity = 200
            entity.weight = 50
        end
    end
end

function Game:draw()
    -- Scale and draw the world

    love.graphics.push()
        local scale = 2
        local screenWidth = love.graphics.getWidth() / scale
        local screenHeight = love.graphics.getHeight() / scale

        love.graphics.scale(scale)
        -- TODO: Remove this and use an actual camera
        local tx = math.floor(player.x - (screenWidth / 2))
        local ty = math.floor(player.y - (screenHeight / 2))

        love.graphics.translate(-tx, -ty)
        self.map:draw(-tx, -ty, scale, scale)
        --self.map:draw(1, 1, scale, scale) -- this scales the map

        -- Draw entities
        for i=1, #entities do
            entities[i]:draw()
        end
        --NOTE: player:draw()
    love.graphics.pop()

    -- DEBUG PLAYER
    if self.showDebug == true then
        love.graphics.print("Gravity: " .. player.gravity, 32, 32)
        love.graphics.print("yVelocity: " .. player.yVelocity, 32, 64)
        love.graphics.print("xVelocity: " .. player.xVelocity, 32, 96)
        love.graphics.print("onGround: " .. tostring(player.onGround), 32, 128)
        love.graphics.print("Collision with: " .. otherCollisionName, 32, 160)
        love.graphics.print("Throw time: " .. player.timeToThrow, 32, 192)
    end

end
