--!file: entity.lua
Entity = Object:extend()

function Entity:new(x, y, width, height, image, name)
    self.x = x
    self.y = y
    self.ox = image:getWidth()
    self.oy = image:getHeight()
    self.w = width or 32
    self.h = height or 32
    self.image = image
    self.name = name

    -- Add the entity to our sti(tiled) world
    if world ~= nil then
        world:add(self, self.x, self.y, self.w, self.h)
    end
end

function Entity:draw()
    if self.image ~= nil then
        love.graphics.draw(self.image, self.x, self.y)

        if showDebug == true then
            love.graphics.setPointSize(5)
            love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
        end
    end
end
