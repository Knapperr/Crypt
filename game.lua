--!file: game.lua
Game = Object:extend()

function Game:new()
    self:load()
    self.showDebug = true

    self.cols_len = 0 -- How many collisions are happening
end

function Game:load()
    -- init bump

    self.world = bump.newWorld()
    self.map = sti("data/tileset/level1.lua", { "bump" })
    self.map:bump_init(self.world)

    -- Grab the player from the map
    -- We can use this object loop to grab everything and just init it to the player
    local playerImage = love.graphics.newImage("data/image/skellyanim.png")
    -- WxH is not based off of image. The image is a sprite sheet
    local playerWidth = 32
    local playerHeight = 32
    player = {}
    for k, object in pairs(self.map.objects) do
        if object.name == "Player" then
            player = Player(playerImage, object.x, object.y, playerWidth, playerHeight, self.world)
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
        player:draw()
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

    -- DEBUG!!!
    otherCollisionName = ""
    -- TODO: only using the player right now
    local cols
    local nextX, nextY = 0, 0
    nextX, nextY, cols = self.world:move(player, destX, destY)
    -- NOTE: this is working - player.x, player.x, cols = self.world:move(player, player.x, player.y)

    -- update our players position
    player.x, player.y = nextX, nextY

    -- NOTE: We can only do it this way. We can't return when we aren't touching something
    --       this runs every frame so if we are touching the normal.y -1 then we will be true
    --       before this was not working because of the structure of the code (always incrementing gravity)
    player.onGround = false
    for i,col in ipairs (cols) do
        otherCollisionName = tostring(col.other)

        if col.normal.y == -1 or col.normal.y == 1 then
            player.yVelocity = 0
        end
        if col.normal.y == -1  then
            player.onGround = true
        end
    end
end
