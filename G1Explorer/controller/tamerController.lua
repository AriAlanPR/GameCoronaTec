-- Load required libraries
local physics = require( "physics" )
local tamer = require("model.tamer")

local tamerController = {}

-- Configure image sheets
local tamerArray = tamer:getSheet()
local tamerOptions = tamerArray
local tamerSheet = graphics.newImageSheet( "assets/images/character1.png", tamerOptions )

local charSequence = {
    {name="stand", start=123, count=11, time=600, loopCount },
    {name="run", start=70, count=8, time=600 },
    {name="jump", start=88, count=8, time=600, loopCount=1 }
}

tamerController.sprite = display.newSprite( mainGroup, charSheet, charSequence)

function tamerController:getSprite()
    return self.sprite;
end

return tamerController