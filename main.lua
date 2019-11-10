Object = require "lib/classic"

bump = require "lib/bump"
sti = require "lib/sti"

require "game"
require "entity"
require "dynamic_entity"
require "player"
require "tree"
require "spike"
require "slow_block"
require "powerup"

anim8 = require 'lib/anim8'

local game

function love.load()
    -- configure
    --love.profiler = require("lib/profile")
    --love.profiler.hookall("Lua")
    --love.profiler.start()
    --]]
    
    love.graphics.setBackgroundColor( 25/255, 25/255, 25/255, 50/100)
    love.graphics.setDefaultFilter("nearest", "nearest")
    game = Game()
end


love.frame = 0
function love.update(dt)
    game:update(dt)


    --love.frame = love.frame + 1
    --if love.frame % 100 == 0 then
    --    love.report = love.profiler.report('time', 20)
    --    love.profiler.reset()
    --end
    --]]
end

function love.draw()
    game:draw()

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
