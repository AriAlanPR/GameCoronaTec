-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local tapCount = 0

local background = display.newImageRect( "GettingStarted01/background.png", 700, 1130)
background.x = display.contentCenterX
background.y = display.contentCenterY

local tapText = display.newText( tapCount, display.contentCenterX, 20, native.systemFont, 40 )
tapText:setFillColor( 0, 0, 0 )

local platform = display.newImageRect( "GettingStarted01/platform.png", 300, 50 )
platform.x = display.contentCenterX
platform.y = display.contentHeight-25

local balloon = display.newImageRect( "GettingStarted01/balloon.png", 112, 112 )
balloon.x = display.contentCenterX
balloon.y = display.contentCenterY
balloon.alpha = 0.8

local physics = require( "physics" )
physics.start()

physics.addBody( platform, "static" )
physics.addBody( balloon, "dynamic", { radius=50, bounce=0.3 } )

local function pushBalloon()
	balloon:applyLinearImpulse( 0.2, -1.0, balloon.x, balloon.y )
	balloon:applyLinearImpulse( -0.2, 0, balloon.x, balloon.y )
	tapCount = tapCount + 1
	tapText.text = tapCount
end

balloon:addEventListener( "tap", pushBalloon )
