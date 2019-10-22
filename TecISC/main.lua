-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
local sheetInfo = require("helpers.effects_skills-0")
local sheetArray = sheetInfo:getSheet()
local options = sheetArray['frames'][sheetInfo:getFrameIndex("dg_effects32-0")]

options.width = options.sourceWidth/8
options.numFrames = 8

local imageSheet = graphics.newImageSheet( "assets/images/effect_skills-0.png", options )

local sequenceData =
{
    name="walking",
    start=3,
    count=2,
    time=1000,
}

local character = display.newSprite( imageSheet, sequenceData )

character.x = display.contentCenterX
character.y = display.contentCenterY

character:setSequence( "walking" )
character:play()