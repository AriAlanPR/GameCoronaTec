-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "widget" library
local widget = require "widget"

--------------------------------------------

-- forward declarations and other locals
local playBtn

-- 'onRelease' event listener for playBtn
local function onPlayBtnRelease()
	
	-- go to level1.lua scene
	composer.gotoScene( "view.level1", "fade", 500 )
	
	return true	-- indicates successful touch
end

function scene:create( event )
	local sceneGroup = self.view

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	-- display a background image
	local background = display.newImageRect( "assets/images/background.jpg", display.actualContentWidth + 300, display.actualContentHeight + 100)
	background.anchorX = 0
	background.anchorY = 0
	background.x = 0 + display.screenOriginX 
	background.y = 0 + display.screenOriginY	
	
	-- create a widget button (which will loads level1.lua on release)
	playBtn = widget.newButton{
		label = "Play Now",
		font = "PTSerif-Caption",
		fontSize = 45,
		labelColor = { default={ 1.0 }, over={ 0.5 } },
		-- defaultFile = "button.png",
		-- overFile = "button-over.png",
		width = 300, height = 100,
		onRelease = onPlayBtnRelease,	-- event listener function
		emboss = false,
        -- Properties for a rounded rectangle button
        shape = "roundedRect",
		cornerRadius = 15,
        fillColor = { default={4/255,61/255,118/255,1}, over={5/255,38/255,71/255,0.4} },
        strokeColor = { default={25/255,51/255,76/255,1}, over={19/255,107/255,174/255,1} },
        strokeWidth = 4
	}
	playBtn.x = display.contentCenterX
	playBtn.y = display.contentHeight - 125
	
	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( playBtn )
end

function scene:show( event )
	local sceneGroup = self.view

	for i, fontName in ipairs( native.getFontNames() ) do
 
		local j, k = string.find( string.lower(fontName), string.lower("pt") )
	 
		if ( j ~= nil ) then
			print( "Font Name = " .. tostring( fontName ) )
		end
	end
	
	local titleBase = display.newRoundedRect( sceneGroup, display.contentCenterX, 198, 500, 75, 12 )
	titleBase.strokeWidth = 3
	titleBase:setFillColor( 1,1,1,1 )
	titleBase:setStrokeColor( 4/255,61/255,118/255,1 )
	local titleButton = display.newText( sceneGroup, "Mocha + Chai", display.contentCenterX, 198, "PTSerif-Caption", 55 )
    titleButton:setFillColor( 4/255,61/255,118/255,1 )

	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
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
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	
	if playBtn then
		playBtn:removeSelf()	-- widgets must be manually removed
		playBtn = nil
	end
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
