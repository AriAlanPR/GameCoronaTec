-- Menu Scene
-- utilize the Composer library in this Lua file.
local composer = require( "composer" )
 
-- create a new variable named scene that holds a Composer scene object.
local scene = composer.newScene() 

-- Accessible Code
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local function gotoGame()
    composer.gotoScene( "game", { time=800, effect="crossFade" } )
end
 
local function gotoHighScores()
    composer.gotoScene( "highscores", { time=800, effect="crossFade" } )
end

-- Scene Events
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
-- Essentially, :create( event ) indicates that this function will be associated with the 
--Composer create scene event and that a table of data that we reference with event will be passed to the function.
function scene:create( event )
    -- Load the scene inside the main view
    -- This line creates a local reference to the scene's view group, automatically created by Composer, 
    -- which should contain all of the display objects used in the scene. 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    local background = display.newImageRect( sceneGroup, "GettingStarted02/background.png", 800, 1400 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    local title = display.newImageRect( sceneGroup, "GettingStarted02/title.png", 500, 80 )
    title.x = display.contentCenterX
    title.y = 200

    -- For simplicity at this point, we'll use text objects instead of graphical buttons
    local titleeButton = display.newText( sceneGroup, "Star Explorer", display.contentCenterX, 198, native.systemFont, 44 )
    titleeButton:setFillColor( 0.82, 0.86, 1 )

    local playButton = display.newText( sceneGroup, "Play", display.contentCenterX, 700, native.systemFont, 44 )
    playButton:setFillColor( 0.82, 0.86, 1 )
 
    local highScoresButton = display.newText( sceneGroup, "High Scores", display.contentCenterX, 810, native.systemFont, 44 )
    highScoresButton:setFillColor( 0.75, 0.78, 1 )

    playButton:addEventListener( "tap", gotoGame )
    highScoresButton:addEventListener( "tap", gotoHighScores )
end


-- show()
function scene:show( event )
    
	local sceneGroup = self.view
    local phase = event.phase
    
    
	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
        
	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
