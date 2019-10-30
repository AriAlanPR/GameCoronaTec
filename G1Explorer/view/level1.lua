-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "physics" library
local physics = require "physics"
local tamerController = require "controller.tamerController"
--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW, halfH = display.actualContentWidth, display.actualContentHeight, display.contentCenterX, display.contentCenterY
-- define groups
local backgroup, maingroup, uigroup

function scene:create( event )

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	local sceneGroup = self.view
	
	-- all display objects must be inserted into group
	backgroup = display.newGroup() 
	sceneGroup:insert( backgroup )

	maingroup = display.newGroup() 
	sceneGroup:insert( maingroup)
	
	uigroup = display.newGroup() 
	sceneGroup:insert( uigroup )	

	-- We need physics started to add bodies, but we don't want the simulaton
	-- running until the scene is on the screen.
	physics.start()
	-- physics.setGravity( -9, 0 )
	physics.pause()
	
	-- create a grey rectangle as the backdrop
	-- the physical screen will likely be a different shape than our defined content area
	-- since we are going to position the background from it's top, left corner, draw the
	-- background at the real top, left corner.
	local background = display.newRect(backgroup, display.screenOriginX, display.screenOriginY, screenW, screenH )
	background.anchorX = 0 
	background.anchorY = 0
	background:setFillColor( .5 )
	
	-- make a crate (off-screen), position it, and rotate slightly
	local crate = display.newImageRect(maingroup, "crate.png", 90, 90 )
	crate.x, crate.y = halfW, halfH + 110 
	crate.myName = "crate"
	crate.rotation = 5
	
	-- add physics to the crate
	physics.addBody( crate, "dynamic", { density=1.0, friction=0.3, bounce=0.2 } )
	
	-- make a crate (off-screen), position it, and rotate slightly
	local crate2 = display.newImageRect(maingroup, "crate.png", 90, 90 )
	crate2.x, crate2.y = screenW - 100, halfH 
	crate2.myName = "crate"
	crate2.rotation = 8
	
	-- add physics to the crate2
	physics.addBody( crate2, "dynamic", { density=1.0, friction=0.3, bounce=0.2 } )

	-- create a grass object and add physics (with custom shape)
	local grass = display.newImageRect(maingroup, "grass.png", screenW, 99 )
	grass.anchorX = 0
	grass.anchorY = 1
	-- grass.rotation = 90
	--  draw the grass at the very bottom of the screen
	grass.x, grass.y = 0, screenH + (display.screenOriginY * 2)
	
	-- define a shape that's slightly shorter than image bounds (set draw mode to "hybrid" or "debug" to see)
	local grassShape = { -halfW,-34, halfW,-34, halfW,34, -halfW,34 }
	physics.addBody( grass, "static", { friction=0.3, shape=grassShape } )
	
	tamerController:init(maingroup)
	local tamerObj = tamerController:getSprite()
	tamerObj.x = halfW
	tamerObj.y = halfH
	
end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		physics.start()
		Runtime:addEventListener( "collision", tamerController.onCollision )
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
		physics.stop()
	elseif phase == "did" then
		-- Called when the scene is now off screen
		Runtime:removeEventListener( "collision", tamerController.onCollision )
	end	
	
end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
	
	package.loaded[physics] = nil
	physics = nil
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene