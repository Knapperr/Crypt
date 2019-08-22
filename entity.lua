--!file: entity.lua
Entity = Object:extend()

function Entity:new(x, y, width, height, image)
    self.x = x
    self.y = y
    self.direction = 1
    -- Image & Dimensions
    self.image = image
    self.w = width or 32
    self.h = height or 32

    -- Add the entity to our sti(tiled) world
    if world ~= nil then
        world:add(self, self.x, self.y, self.w, self.h)
    end
end

function Entity:draw()
    if self.image ~= nil then
        love.graphics.draw(self.image, self.x, self.y)
    end
end
