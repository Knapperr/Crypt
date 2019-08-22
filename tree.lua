--!file: tree.lua
Tree = DynamicEntity:extend()

function Tree:new(image, x, y, width, height, name)
    Tree.super.new(self, x, y, width, height, image, name)

    self.gravity = 630
    self.weight = 60

end
