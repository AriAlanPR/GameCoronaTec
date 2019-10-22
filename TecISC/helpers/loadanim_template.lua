local sheetInfo = require("helpers.character1")
local sheetArray = sheetInfo:getSheet()
local options = sheetArray['frames'][sheetInfo:getFrameIndex("character-0")]

-- options.width = options.sourceWidth
options.numFrames = 8

local imageSheet = graphics.newImageSheet( "assets/images/character1.png", options )

local sequenceData =
{
    name="walking",
    start=1,
    count=7,
    time=1000,
}

local character = display.newSprite( imageSheet, sequenceData )

character.x = display.contentCenterX
character.y = display.contentCenterY

character:scale( 4, 4 )

character:setSequence( "walking" )
character:play()