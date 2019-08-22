## TODO
    can check
    <code>
    for i=1,#self.entities do
      if self.entities[i]:is(DynamicEntity) then
        self.entities[i]:updatePhysics(dt)
      end
      -- local destX = player.x + player.xVelocity * dt
      -- local destY = player.y + player.yVelocity * dt
      -- The lines above will just need to be entity.x _ entity.xVelocity * dt.
      -- if the entity is dynamic and needs to move
      self.entities[i].x, self.entities[i].y, cols = self.world:move( self.entities[i], self.entities[i].x, self.entities[i].y )
      self:checkCols(self.entities[i], cols)
      end
    </code>

[ ] add spike
[ ] IN-PROGRESS: (Started using entities for drawing) Create array of entities in the game class
[ ] Add game states with controller http://lua.space/gamedev/handling-input-in-lua
[ ] Clean up the collision detection somehow.. collisionhandler class?
[x] create alarm for creating tree
[x] Add dynamic entity to inherit from entity
[x] Now that everything is out of main experiment more with the STI library and tilemaps
[x] Move everything out of main. create a game class that deals with a list of entities and loading the map
[x] Collision detection from bump

---------------------------------------------------------------------------------------------------------------------
***** NOTES *******
NOTE: The reason why gravity wasn't working was because we were constantly incrementng it!
      realize now this is stupid. Why would you constantly increment the gravity value itself
      we create a dy (destination y) and set it: like so.. or like this later on
         *if self.yVelocity < self.terminalVelocity then
              self.yVelocity = self.yVelocity + self.gravity * dt
          else
              self.yVelocity = self.terminalVelocity
          end*
      remember to think about things like this.


NOTE: Remember this -> local layer = map:addCustomLayer("Sprites", 3)
                        -- Update the tiled map
                        layer.update = function(self, dt)
this code here creates this custom layer. I don't need this anymore.
I am not using a layer I am just grabbing from a prexisting layer

NOTE: !!! Assuming I can use this layer.update for animated tiles on the actual tileset
      or like we create a sprite layer and would use like a waterfall. so the waterfall Sprite
      would get the sprite. in that object loop


-- NOTE: I don't think we draw like this we use sti to soley grab data and draw the map also the map can have collision data on it
         This should help find how to do the collisions on the map which uses bump (stay away from box2D)
--       we use sti to soley grab data and draw the map
--       also the map can have collision data on it
      https://github.com/andriadze/Love2D_Platformer_Example/blob/master/game.lua
-- draw player on the map
-- layer.draw = function(self)
--     love.graphics.draw(
--     player.image,
--     math.floor(player.x),
--     math.floor(player.y),
--     0,
--     1,
--     1,
--     10,--self.player.ox,
--     10--self.player.oy
--     )
-- end
