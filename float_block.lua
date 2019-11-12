-- !file: float_block.lua

FloatBlock = Entity:extend()

function FloatBlock:new(image, x, y, width, height, name)
    FloatBlock.super.new(self, x, y, width, height, image, name)
end
