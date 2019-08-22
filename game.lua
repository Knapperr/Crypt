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
    -- global world
    world = bump.newWorld()
    self.map = sti("data/tileset/level1.lua", { "bump" })
    self.map:bump_init(world)

    -- Grab the player from the map
    -- We can use this object loop to grab everything and just init it to the player
    local spikeImage = love.graphics.newImage("data/image/spike.png")
    local playerImage = love.graphics.newImage("data/image/skellyanim.png")
    -- WxH is not based off of image. The image is a sprite sheet
    local playerWidth = 32
    local playerHeight = 32
    player = {}
    for k, object in pairs(self.map.objects) do
        if object.name == "Player" then
            player = Player(playerImage, object.x, object.y, playerWidth, playerHeight, "player")
            table.insert(entities, player)
        elseif object.name == "Spike" then
            table.insert(entities, Spike(spikeImage, object.x, object.y, 32, 32, "spike"))
        end
    end
end

function Game:update(dt)
    -- reset collisions
    self.map:update(dt)
    self:handleCollisions(dt)

    player:update(dt)


    -- Debug controls
    if love.keyboard.isDown("1") then
        self.showDebug = false
    elseif love.keyboard.isDown("2") then
        self.showDebug = true
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
        --player:draw()
    love.graphics.pop()

    -- TODO: Change this to draw all of our entities like
    -- entities[i]:draw() in a loop

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


-- Handle collisions for everything the character can contact
-- NOTE: If we are looping through entities to do this we will need to check
--       specifically for the player with the destX and destY the entities wont use this
function Game:handleCollisions(dt)
    -- TODO: Move this to a function
    -- projected position
    local destX = player.x + player.xVelocity * dt
    local destY = player.y + player.yVelocity * dt

    -- TODO: only using the player right now
    local cols
    local nextX, nextY = 0, 0
    nextX, nextY, cols = world:move(player, destX, destY)
    -- NOTE: this is working - player.x, player.x, cols = world:move(player, player.x, player.y)

    -- update our players position
    player.x, player.y = nextX, nextY

    -- NOTE: We can only do it this way. We can't return when we aren't touching something
    --       this runs every frame so if we are touching the normal.y -1 then we will be true
    --       before this was not working because of the structure of the code (always incrementing gravity)

    -- could move this into a function checkCollisions
    otherCollisionName = ""
    player.onGround = false
    for i,col in ipairs (cols) do
        otherCollisionName = tostring(col.other.name)
        if col.normal.y == -1 or col.normal.y == 1 then
            player.yVelocity = 0
        end
        if col.normal.y == -1  then
            player.onGround = true
        end
        if otherCollisionName == "spike" then
            player.speed = 300
        end
    end
end
