--!file: camera.lua
Camera = Object.extend()

function Camera:new(targetX, targetY)
    self.x = targetX
    self.y = targetY
end

function Camera:update(dt)

end