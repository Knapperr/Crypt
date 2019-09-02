### TODO
------------------------------------------------------------------------------------------
- [ ] Main gameplay idea
- [ ] Add game states with controller http://lua.space/gamedev/handling-input-in-lua
- [x] Can actually clean this up by adding the checkCollisions and nextX, nextY, cols = world:move(entity, destX, destY) inside of eachobject's update. this way i can put the logic for the player collisions inside of the player itself's update rather than check that for each object in the game https://github.com/kikito/bump.lua/tree/demo/entities
- [x] Clean up the collision detection somehow.. collisionhandler class ^ the above cleans it up - just look at Bump docs
- [x] add spike
- [x] IN-PROGRESS: (Started using entities for drawing) Create array of entities in the game class
- [x] create alarm for creating tree
- [x] Add dynamic entity to inherit from entity
- [x] Now that everything is out of main experiment more with the STI library and tilemaps
- [x] Move everything out of main. create a game class that deals with a list of entities and loading the map
- [x] Collision detection from bump
-------------------------------------------------------------------------------------------------
### IDEA:
  Skellboy woke up in the catacombs. He needs to escape as fast as possible before he gets trapped. Run towards the light and take off! Each level starts with skellboy coming out of the tomb each level ends with him floating up to the golden yellow light. These animations just be fast and allow quick progression to the next level like meatboy.

  When he comes out of tomb(animation)(voice acted) and hits ground big letters pop up saying GO GO ! 

  Ending is WIN WIN! (animation)(voice acted)

### NOTES

NOTE: The reason why gravity wasn't working was because we were constantly incrementng it!
realize now this is stupid. Why would you constantly increment the gravity value itself
      we create a dy (destination y) and set it: like so.. or like this later on


     if self.yVelocity < self.terminalVelocity then
          self.yVelocity = self.yVelocity + self.gravity * dt
      else
          self.yVelocity = self.terminalVelocity
      end


NOTE: Remember this -> local layer = map:addCustomLayer("Sprites", 3)
                        -- Update the tiled map
                        layer.update = function(self, dt)
this code here creates this custom layer. I don't need this anymore.
I am not using a layer I am just grabbing from a prexisting layer

NOTE: !!! Assuming I can use this layer.update for animated tiles on the actual tileset
      or like we create a sprite layer and would use like a waterfall. so the waterfall Sprite
      would get the sprite. in that object loop


 NOTE: I don't think we draw like this we use sti to soley grab data and draw the map also the map can have collision data on it
         This should help find how to do the collisions on the map which uses bump (stay away from box2D)
         we use sti to soley grab data and draw the map
        also the map can have collision data on it
      https://github.com/andriadze/Love2D_Platformer_Example/blob/master/game.lua
