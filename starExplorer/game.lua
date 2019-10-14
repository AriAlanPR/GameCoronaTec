
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )
 
-- Seed the random number generator
-- math.randomseed( os.time() )

-- Configure image sheet
local sheetOptions =
{
    frames =
    {
        {   -- 1) asteroid 1
            x = 0,
            y = 0,
            width = 102,
            height = 85
        },
        {   -- 2) asteroid 2
            x = 0,
            y = 85,
            width = 90,
            height = 83
        },
        {   -- 3) asteroid 3
            x = 0,
            y = 168,
            width = 100,
            height = 97
        },
        {   -- 4) ship
            x = 0,
            y = 265,
            width = 98,
            height = 79
        },
        {   -- 5) laser
            x = 98,
            y = 265,
            width = 14,
            height = 40
        },
    },
}

local objectSheet = graphics.newImageSheet( "GettingStarted02/gameObjects.png", sheetOptions )

-- Initialize variables
local lives = 3
local score = 0
local died = false
 
local asteroidsTable = {}
 
local ship
local gameLoopTimer
local livesText
local scoreText

-- Set up display groups
local backGroup  -- Display group for the background image
local mainGroup  -- Display group for the ship, asteroids, lasers, etc.
local uiGroup    -- Display group for UI objects like the score

-- NOTE: In our original version, we created the background, ship, lives text, 
-- and score text immediately following initialization of the display groups. 
-- Now, because we're only creating local references for the display groups, 
-- we must defer these actions until later, inside the scene:create() function.

--Update text of game
local function updateText()
    livesText.text = "Lives: " .. lives
    scoreText.text = "Score: " .. score
end

--Make a function to create a new asteroid
local function createAsteroid() 
    local newAsteroid = display.newImageRect( mainGroup, objectSheet, 1, 102, 85 )
    table.insert( asteroidsTable, newAsteroid )
    physics.addBody( newAsteroid, "dynamic", { radius=40, bounce=0.8 } )
    newAsteroid.myName = "asteroid"

    --Placement
    local whereFrom = math.random( 3 )

    if ( whereFrom == 1 ) then
        -- From the left
        newAsteroid.x = -60
        newAsteroid.y = math.random( 500 )
        -- Movement
        -- Event similar to applyLinearImpulse with the difference that 
        --instead of applying a sudden "push" to the object, it simply sets the object moving in a steady, consistent direction.
        newAsteroid:setLinearVelocity( math.random( 40,120 ), math.random( 20,60 ) ) --Parameters send are the velocity for x and y directions respectively
    elseif ( whereFrom == 2 ) then
        -- From the top
        newAsteroid.x = math.random( display.contentWidth )
        newAsteroid.y = -60
        newAsteroid:setLinearVelocity( math.random( -40,40 ), math.random( 40,120 ) )
    elseif ( whereFrom == 3 ) then
        -- From the right
        newAsteroid.x = display.contentWidth + 60
        newAsteroid.y = math.random( 500 )
        newAsteroid:setLinearVelocity( math.random( -120,-40 ), math.random( 20,60 ) )
    end

    --[[
        Reminder:
        Notice that we call math.random() with two parameters this time, 
        while before we called it with just one. 
        When called with one parameter, 
        the command randomly generates an integer between 1 and the value you indicate.
        When called with two parameters, the command randomly generates an integer between the two specified values,
        for example between 40 and 120 in the first instance above.
    --]]

    -- Rotation
    newAsteroid:applyTorque( math.random( -6,6 ) )
end --function create asteroid

--[[
    Getting our ship to fire lasers is similar to loading asteroids, but this time we'll use a 
    convenient and powerful method to move them known as a transition.     
--]]

local function fireLaser()
 
    local newLaser = display.newImageRect( mainGroup, objectSheet, 5, 14, 40 )
    physics.addBody( newLaser, "dynamic", { isSensor=true } )
    -- isBullet property makes the object subject to continuous collision detection rather than periodic collision detection at world time steps.
    newLaser.isBullet = true
    newLaser.myName = "laser"

    newLaser.x = ship.x
    newLaser.y = ship.y
    -- Because this function creates new lasers after the ship has already been loaded, 
    -- and both objects are part of the mainGroup display group, lasers will appear visually 
    -- above (in front of) the ship in terms of layering. Clearly this looks silly, so let's push it behind the ship
    newLaser:toBack()

    --[[
        As you can see, the first parameter is the object to transition (newLaser). 
        For the second parameter, we include a table which can contain various properties for the transition. 
        Here, we set y=-40 which indicates the laser's vertical destination, slightly off the top edge of the screen. 
        We also set a custom time parameter of 500. For transitions, the time (duration) should always be specified in milliseconds
        meaning 1 sec 0 1000 milisecs
    ]]
    transition.to( newLaser, { y=-40, time=500, 
    onComplete = function() display.remove( newLaser ) end} ) -- Sent Anonymous function
end


-- Moving the Ship

--[[
    In this game, in addition to firing lasers,
    the player will be able to touch and drag
    the ship along the bottom of the screen.
    To handle this type of movement,
    we need a function to handle touch/drag events.
    Let's create this function in the usual manner:
]]

-- Touch Events
-- Touch events, distinct from tap events, have four distinct phases 

local function dragShip( event )
    -- In touch/tap events, event.target is the object which was touched/tapped, 
    --so setting this local variable as a reference to the ship object will save us some typing
    local ship = event.target
    -- Let's locally set the phase (event.phase) of the touch event
    local phase = event.phase

    -- If it has just begun (initial touch on the ship), 
    -- the "began" phase is dispatched to our function
    if ( phase == "began" ) then
        -- Set touch focus on the ship
        display.currentStage:setFocus( ship )
        -- Store initial offset position
        ship.touchOffsetX = event.x - ship.x
        -- If moving across y coordinate is wanted
        --ship.touchOffsetY = event.y - ship.y
    elseif (  phase == "moved" ) then
        -- Move the ship to the new touch position
        ship.x = event.x - ship.touchOffsetX        
        -- Same case if needed for y
        --ship.y = event.y ship.touchOffsetY
    elseif ( phase == "ended" or  phase == "cancelled" ) then
        -- Release touch focus on the ship
        display.currentStage:setFocus( nil )
    end

    return true  -- Prevents touch propagation to underlying objects
end

-- Game Loop
local function gameLoop()
    -- Create new asteroid
    createAsteroid()
 
    -- Remove asteroids which have drifted off screen
    for i = #asteroidsTable, 1, -1 do 
        local thisAsteroid = asteroidsTable[i]
 
        if ( thisAsteroid.x < -100 or
             thisAsteroid.x > display.contentWidth + 100 or
             thisAsteroid.y < -100 or
             thisAsteroid.y > display.contentHeight + 100 )
        then
            display.remove( thisAsteroid )
            table.remove( asteroidsTable, i )
        end
    end
end

--Restoring the Ship
local function restoreShip()
 
    ship.isBodyActive = false
    -- Set the ship position to its initial place and to the center of the X coordinate
    ship.x = display.contentCenterX
    ship.y = display.contentHeight - 100
 
    -- Fade in the ship
    transition.to( ship, { alpha=1, time=4000,
        onComplete = function()
            ship.isBodyActive = true
            died = false
        end
    } )
end

local function endGame()
    -- This time we're including an additional, 
    -- optional table containing parameters for a scene `transition effect`. 
    -- Inside this table, we specify an effect duration (time) of 800 milliseconds 
    -- and an effect property of "crossFade". This built-in Composer effect will cause 
    -- the game scene to fade out while, concurrently, the menu scene fades in.
    composer.gotoScene( "menu", { time=800, effect="crossFade" } )
end

local function onCollision( event )
    -- Verify if event phase of collision just began
    if ( event.phase == "began" ) then
        -- Get the collission objects
        local obj1 = event.object1
        local obj2 = event.object2
        -- Verify if collision is laser towards asteroid or vice versa
        if ( ( obj1.myName == "laser" and obj2.myName == "asteroid" ) or ( obj1.myName == "asteroid" and obj2.myName == "laser" ) ) then
            -- Do the thing
            -- Remove both the laser and asteroid
            display.remove( obj1 )
            display.remove( obj2 )
 
            for i = #asteroidsTable, 1, -1 do
                if ( asteroidsTable[i] == obj1 or asteroidsTable[i] == obj2 ) then
                    table.remove( asteroidsTable, i )
                    break
                end
            end
 
            -- Increase score
            score = score + 100
            scoreText.text = "Score: " .. score

        elseif ( ( obj1.myName == "ship" and obj2.myName == "asteroid" ) or ( obj1.myName == "asteroid" and obj2.myName == "ship" ) ) then
            if ( not died ) then
                died = true
                
                -- Update lives
                lives = lives - 1
                livesText.text = "Lives: " .. lives

                if ( lives == 0 ) then
                    display.remove( ship )
                    -- Logically, a scene will never be hidden unless you intentionally cause it to hide, 
                    -- and this occurs when you tell Composer to go to a different scene
                    timer.performWithDelay( 2000, endGame )
                else
                    ship.alpha = 0
                    timer.performWithDelay( 1000, restoreShip )
                end            
            end            
        end
    end
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    
    physics.pause()  -- Temporarily pause the physics engine
    --[[ 
        What is the purpose of this command at this point in the 
        scene's life cycle? Remember that our game scene isn't truly on 
        screen at this point and, because we don't want the game to start quite yet, 
        we'll immediately pause the physics engine. This allows us to create objects, 
        assign their physical bodies, and position them, but they won't be affected physically 
        until we re-start the physics engine.    
    --]]

    -- Set up display groups
    backGroup = display.newGroup()  -- Display group for the background image
    sceneGroup:insert( backGroup )  -- Insert into the scene's view group
 
    mainGroup = display.newGroup()  -- Display group for the ship, asteroids, lasers, etc.
    sceneGroup:insert( mainGroup )  -- Insert into the scene's view group
 
    uiGroup = display.newGroup()    -- Display group for UI objects like the score
    sceneGroup:insert( uiGroup )    -- Insert into the scene's view group
 
    -- Initialize scene's objects
    -- Notice that we are still inserting objects into their proper display groups such as backGroup, 
    -- mainGroup, and uiGroup. This is the correct procedure because all of those groups were inserted
    -- into the scene's view group and they are now children of that parent group.
    -- Load the background
    local background = display.newImageRect( backGroup, "GettingStarted02/background.png", 800, 1400 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    -- To consider: Essentially, you can create a forward reference in the scene-accessible area, 
    -- assign an actual object to that reference inside a scene: function, and then other functions 
    -- will associate the reference with the new object.
    -- Initialize the ship
    ship = display.newImageRect( mainGroup, objectSheet, 4, 98, 79 )
    ship.x = display.contentCenterX
    ship.y = display.contentHeight - 100
    physics.addBody( ship, { radius=30, isSensor=true } )
    ship.myName = "ship"
 
    -- Display lives and score
    livesText = display.newText( uiGroup, "Lives: " .. lives, 200, 80, native.systemFont, 36 )
    scoreText = display.newText( uiGroup, "Score: " .. score, 400, 80, native.systemFont, 36 )

    -- Add "tap" and "touch" event listeners
    ship:addEventListener( "tap", fireLaser )
    ship:addEventListener( "touch", dragShip )
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        -- Re-start the physics engine with physics.start() (remember that we paused it in scene:create()).
        physics.start()
        -- Do extra things
        Runtime:addEventListener( "collision", onCollision )
        gameLoopTimer = timer.performWithDelay( 500, gameLoop, 0 )
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        -- Stop timer before dismissing scene
        timer.cancel( gameLoopTimer )
	elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
        -- Stop collission after scene is dismissed and pause physics
        Runtime:removeEventListener( "collision", onCollision )
        physics.pause()
        -- Dismiss scene from the game memory
        composer.removeScene( "game" )
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
