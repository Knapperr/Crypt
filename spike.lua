--!file: spike.lua
Spike = Entity:extend()

function Spike:new(image, x, y, width, height, name)
    Spike.super.new(self, x, y, width, height, image, name)
end
