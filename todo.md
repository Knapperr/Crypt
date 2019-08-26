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
    Super Monkey Ball 2D. (look up code on the github example for loading the next tiled map)
    -- will need to change the load code for the game class maybe need a level clas

    so the idea is to have it where you have to get to the end of the level in 30-60 seconds.
    there will be speed up power up. a slow down power up taht slows down all of the objects in the level like monkey ball
    change colour palette. (hamster in a ball?) some kind of animal that is moving through the level really fast but don't
    use an animal that is actually fast like a cheetah. (sloth ball) sloths in fast moving balls getting through the level
    need to have a checkerboard that SEGA aesthetic

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
