-- Load required libraries
local physics = require( "physics" )
local tamer = require("model.characters.tamer")

local tamerController = {}

-- Configure image sheets
local tamerArray = tamer:getSheet()
local tamerOptions = tamerArray
local tamerSheet = graphics.newImageSheet( "assets/images/tamer.png", tamerOptions )

local tamerSequence = {
    {name="stand", start=1, count=5, time=600},
    {name="run", start=6, count=1, time=600 },
    {name="jump", start=7, count=6, time=600, loopCount=1 }
}

function tamerController:init(targetGroup)
-- print("Tamer group: ", targetGroup)
tamerController.sprite = display.newSprite( targetGroup, tamerSheet, tamerSequence)
tamerController.sprite:scale( 2, 2 )
tamerController.sprite.myName = "tamer"
tamerController.body = physics.addBody( tamerController.sprite, "dynamic", { density=1.5, friction=0.3, shape={-10,-25 ,10,-25 ,10,30 ,-10,30}, isBullet=true } )

-- Play character animation
tamerController.sprite:setSequence( "jump" )
tamerController.sprite:play()
end

function tamerController:getSprite()
    return self.sprite;
end

function tamerController:getBody()
    return self.body;
end
 
tamerController.onCollision = function ( event )
    if ( event.phase == "began" ) then
        local o1 = event.object1
        local o2 = event.object2
        
        if((o1.myName == "tamer" and o2.myName == "crate") or (o1.myName == "crate" and o2.myName == "tamer")) then 
            -- Play character stand
            tamerController.sprite:setSequence( "stand" )
            tamerController.sprite:play()
        end
    end
end

return tamerController