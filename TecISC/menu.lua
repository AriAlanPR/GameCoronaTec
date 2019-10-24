-- Menu Scene
-- utilize the Composer library in this Lua file.
local composer = require( "composer" )
 
-- create a new variable named scene that holds a Composer scene object.
local scene = composer.newScene()

-- set a protected accessibility variable for sound
local readysound

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
    local background = display.newImageRect( sceneGroup, "assets/images/background.png", 800, 1600 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    local title = display.newImageRect( sceneGroup, "assets/images/title.png", display.contentWidth - 100, 150 )
    title.x = display.contentCenterX
    title.y = 100

    local mountain = display.newImageRect( sceneGroup, "assets/images/mountain.png", display.contentWidth, 400 )
    mountain.x = display.contentCenterX
    mountain.y = display.contentHeight

    -- For simplicity at this point, we'll use text objects instead of graphical buttons
    local titleeButton = display.newText( sceneGroup, "Get Some Help", display.contentCenterX, 100, native.systemFont, 60)
    titleeButton:setFillColor({
        type="gradient",
        color1={ 0.82, 0.86, 1}, color2={ 86/255, 96/255, 115/255}, direction="down"
    }) 

    local playButton = display.newText( sceneGroup, "Play", display.contentCenterX, 700, native.systemFont, 50 )
    playButton:setFillColor({
        type="gradient",
        color1={ 0.82, 0.86, 1}, color2={ 86/255, 96/255, 115/255}, direction="down"
    })
 
    local highScoresButton = display.newText( sceneGroup, "High Scores", display.contentCenterX, 860, native.systemFont, 44 )
    highScoresButton:setFillColor({
        type="gradient",
        color1={ 0.82, 0.86, 1}, color2={ 86/255, 96/255, 115/255}, direction="down"
    })

    playButton:addEventListener( "tap", gotoGame )
    highScoresButton:addEventListener( "tap", gotoHighScores )

    -- Initialize "Ready?!!!" sound
    readysound = audio.loadSound( "assets/audio/sounds/cpr_narrator_ready.wav" )
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
        -- Play "ready?!!!" sound
        audio.play( readysound)
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
    -- Clear "Ready?!!!" sound
    audio.dispose( readysound)
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
