--!file: game.lua
Game = Object:extend()

function Game:new()
    self:load()
    self.showDebug = true

    -- How many collisions are happening
    self.cols_len = 0
    self.screenHeight = 0
    self.screenWidth = 0
end

function Game:load()
    -- global entities
    entities = {}
    powerups = {}

    -- init bump
    world = bump.newWorld()
    self.map = sti("data/tileset/level1.lua", { "bump" })
    self.map:bump_init(world)

    -- Grab the player from the map
    -- We can use this object loop to grab everything and just init it to the player
    local playerImage = love.graphics.newImage("data/image/skellyanim.png")
    local spikeImage = love.graphics.newImage("data/image/spike.png")
    local slowblockImage = love.graphics.newImage("data/image/slowblock.png")
    local speedPowerupImage = love.graphics.newImage("data/image/powerspeedsmall.png")
    local gravityPowerupImage = love.graphics.newImage("data/image/powergravity.png")
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
        elseif object.name == "SpeedPowerup" then
            table.insert(powerups, Powerup(speedPowerupImage, object.x, object.y, 16, 16, "powerup"))
        elseif object.name == "GravityPowerup" then
            table.insert(powerups, Powerup(gravityPowerupImage, object.x, object.y, 16, 16, "powerup"))
        end
    end
end

-- Update the game
function Game:update(dt)
    -- reset collisions
    self.map:update(dt)


    -- update all entities
    for i=1, #entities do
        local entity = entities[i]
        -- only update and check collisions for dynamic entities
        if entity:is(DynamicEntity) and entity.w <= self.screenWidth and entity.h <= self.screenHeight then
            entity:update(dt)
        end

        -- Have to check for death. Leave the update loop as well
        if entity:is(Player) then
            if entity.dead == true then
                love.load()
                break;
            end
        end
    end

    -- Debug controls
    if love.keyboard.isDown("1") then
        self.showDebug = false
    elseif love.keyboard.isDown("2") then
        self.showDebug = true
    end

    -- Restart game
    if love.keyboard.isDown("r") then
        love.load()
    end
end

function Game:draw()
    -- Scale and draw the world
    love.graphics.push()
        local scale = 2
        self.screenWidth = love.graphics.getWidth() / scale
        self.screenHeight = love.graphics.getHeight() / scale

        -- TODO: Remove this and use an actual camera
        local tx = math.floor(player.x - (self.screenWidth / 2))
        local ty = math.floor(player.y - (self.screenHeight / 2))

        love.graphics.scale(scale)
        love.graphics.translate(-tx, -ty)
        self.map:draw(-tx, -ty, scale, scale)

        -- Draw entities that are on screen
        for i=1, #entities do
            if entities[i].w <= self.screenWidth and entities[i].h <= self.screenHeight then
                entities[i]:draw()
            end
        end

        -- Draw powerups that are on screen
        for i=1, #powerups do
            if powerups[i].w <= self.screenWidth and powerups[i].h <= self.screenHeight then
                powerups[i]:draw()
            end
        end
    love.graphics.pop()

    -- DEBUG PLAYER
    if self.showDebug == true then
        love.graphics.print("Gravity: " .. player.gravity, 32, 32)
        love.graphics.print("yVelocity: " .. player.yVelocity, 32, 64)
        love.graphics.print("xVelocity: " .. player.xVelocity, 32, 96)
        love.graphics.print("onGround: " .. tostring(player.onGround), 32, 128)
        love.graphics.print("Throw time: " .. player.timeToThrow, 32, 160)

        love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 32, 190)
    end
end
