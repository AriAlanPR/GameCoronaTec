
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
-- Initialize variables
-- Work with JSON notation
local json = require( "json" )
 
local scoresTable = {}
 
--  Generates an absolute path to a JSON file (scores.json) which we'll use to save the ten highest scores
local filePath = system.pathForFile( "scores.json", system.DocumentsDirectory )

local function loadScores()
 
    local file = io.open( filePath, "r" )
 
    if file then
        local contents = file:read( "*a" )
        io.close( file )
        scoresTable = json.decode( contents )
    end
 
    if ( scoresTable == nil or #scoresTable == 0 ) then
        scoresTable = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
    end
end

-- Extra: If you want to make things more interesting, start the game with 
-- ten default scores that the "computer" scored and challenge the player to beat them! For example:
-- scoresTable = { 10000, 7500, 5200, 4700, 3500, 3200, 1200, 1100, 800, 500 }

local function saveScores()
 
    for i = #scoresTable, 11, -1 do
        table.remove( scoresTable, i )
    end
 
    local file = io.open( filePath, "w" )
 
    if file then
        file:write( json.encode( scoresTable ) )
        io.close( file )
    end
end

-- sort the table's values from highest to lowest
local function compare( a, b )
    return a > b
    -- if required to sort in an incremental way then the condition we'd need to use is a < b
end

local function gotoMenu()
    composer.gotoScene( "menu", { time=800, effect="crossFade" } )
end
 

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
    -- Load the previous scores
    loadScores()
     
    -- Insert the saved score from the last game into the table, then reset it
    table.insert( scoresTable, composer.getVariable( "finalScore" ) )
    composer.setVariable( "finalScore", 0 )
     
    table.sort( scoresTable, compare )

    -- Save the scores
    saveScores()

    local background = display.newImageRect( sceneGroup, "assets/images/background.png", 800, 1400 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    
    local mountain = display.newImageRect( sceneGroup, "assets/images/mountain.png", display.contentWidth, 400 )
    mountain.x = display.contentCenterX
    mountain.y = display.contentHeight

    local highScoresHeader = display.newText( sceneGroup, "High Scores", display.contentCenterX, 100, native.systemFont, 60 )
    highScoresHeader:setFillColor({
        type="gradient",
        color1={ 0.82, 0.86, 1}, color2={ 86/255, 96/255, 115/255}, direction="down"
    })

    --display the scores using a simple for loop from 1 to 10.
    for i = 1, 10 do
        if ( scoresTable[i] ) then
            local yPos = 150 + ( i * 56 )
 
            local rankNum = display.newText( sceneGroup, i .. ")", display.contentCenterX-50, yPos, native.systemFont, 36 )
            rankNum:setFillColor({
                type="gradient",
                color1={ 0.82, 0.86, 1}, color2={ 86/255, 96/255, 115/255}, direction="down"
            })
            rankNum.anchorX = 1
 
            local thisScore = display.newText( sceneGroup, scoresTable[i], display.contentCenterX-30, yPos, native.systemFont, 36 )
            thisScore.anchorX = 0
        end
    end

    local menuButton = display.newText( sceneGroup, "Menu", display.contentCenterX, 810, native.systemFont, 44 )
    menuButton:setFillColor({
        type="gradient",
        color1={ 0.82, 0.86, 1}, color2={ 86/255, 96/255, 115/255}, direction="down"
    })
    menuButton:addEventListener( "tap", gotoMenu )
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
        -- let's remove the highscores.lua scene on dismiss
        composer.removeScene( "highscores" )
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
