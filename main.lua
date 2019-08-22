Object = require "lib/classic"

bump = require "lib/bump"
sti = require "lib/sti"

require "game"
require "entity"
require "dynamic_entity"
require "player"
require "tree"
require "spike"

anim8 = require 'lib/anim8'

local game

function love.load()
    -- configure
    love.graphics.setBackgroundColor( 25/255, 25/255, 25/255, 50/100)
    love.graphics.setDefaultFilter("nearest", "nearest")
    game = Game()
end

function love.update(dt)
    game:update(dt)
end

function love.draw()
    game:draw()
end

-- DEBUG!
function love.keypressed(key)
    if key == "p" then
        debug.debug()
    end
end
