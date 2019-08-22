--!file: tree.lua
Tree = DynamicEntity:extend()

function Tree:new(image, x, y, width, height)
    Tree.super.new(self, x, y, width, height, image)
    
end
