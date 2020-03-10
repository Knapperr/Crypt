Object = require "lib.classic"

bump = require "lib.bump"
sti = require "lib.sti"
lurker = require "lib.lurker"

require "game"
require "entity"
require "float_block"
require "image"
require "dynamic_entity"
require "player"
require "tree"
require "spike"
require "slow_block"
require "powerup"

anim8 = require 'lib.anim8'

-- NOTE(CK): game
-- Cant use game = require because that makes game a (boolean) lurker wants to load a table
--  and game = {} makes it a table
game = {}

startUpdate = 0
endUpdate = 0

function love.load()
    -- configure
    --love.profiler = require("lib/profile")
    --love.profiler.hookall("Lua")
    --love.profiler.start()
    --]]
    -- Set up player input
    local joysticks = love.joystick.getJoysticks()

    if joysticks ~= nil then
        joystick = joysticks[1]
    end

    love.graphics.setBackgroundColor( 25/255, 25/255, 25/255, 50/100)
    love.graphics.setDefaultFilter("nearest", "nearest")
    game = Game()

end


love.frame = 0
function love.update(dt)
    -- NOTE(CK): Log time
    startUpdate = love.timer.getTime()

    game:update(dt)
    -- NOTE(CK): Lurker
    lurker.scan()

    -- love.frame = love.frame + 1
    -- if love.frame % 100 == 0 then
    --    love.report = love.profiler.report('time', 20)
    --    love.profiler.reset()
    -- end
    -- ]]

    endUpdate = love.timer.getTime()
end

function love.draw()
    game:draw()
    love.graphics.print("start update: " .. tostring(startUpdate), 32, 128)
    love.graphics.print("end update: " .. tostring(endUpdate), 32, 160)

    -- Report profiler
   --love.graphics.print(love.report or "Please wait...")
    --]]

end

-- DEBUG!
function love.keypressed(key)
    if key == "p" then
        debug.debug()
    end
end
