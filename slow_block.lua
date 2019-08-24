--!file: slow_block.lua

SlowBlock = Entity:extend()

function SlowBlock:new(image, x, y, width, height, name)
    SlowBlock.super.new(self, x, y, width, height, image, name)
end
 
