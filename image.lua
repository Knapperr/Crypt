-- !file: image.lua
Image = Object:extend()

function Image:new(x, y, width, height, image)
    self.x = x
    self.y = y
    self.w = width or 32
    self.h = height or 32
    self.image = image 

    self.destroyTime = 2.5
end

function Image:draw()
    if self.image ~= nil then
        love.graphics.draw(self.image, self.x, self.y)
    end
end

function Image:update(dt)
    self.destroyTime = self.destroyTime - 0.2
    if self.destroyTime <= 0 then
        for i=#images, 1, -1 do 
            table.remove(images, i)
        end
    end
end