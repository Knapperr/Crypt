--!file: spike.lua
Powerup = Entity:extend()

function Powerup:new(image, x, y, width, height, name)
    Powerup.super.new(self, x, y, width, height, image, name)
end