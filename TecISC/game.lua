
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
function dump(o)
    for k,v in pairs(o) do
        print( k,v )
    end
 end
-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
-- Load required libraries
local physics = require( "physics" )
local character = require("helpers.character1")
local effectsSkills = require("helpers.effects_skills") 

physics.start()
physics.setGravity( 0, 0 )

-- Configure image sheets
local characterArray = character:getSheet()
local characterOptions = characterArray --['frames'][character:getFrameIndex("character-0")]
local ESArray = effectsSkills:getSheet()
local ESOptions = ESArray --['frames'][effectsSkills:getFrameIndex("dg_effects32-0")]

local charSheet = graphics.newImageSheet( "assets/images/character1.png", characterOptions )
local effectSheet = graphics.newImageSheet( "assets/images/effects_skills.png", ESOptions )

-- Initialize variables 
local lives = 3
local score = 0
local died = false
 
local asteroidsTable = {}
 
local maincharacter
local gameLoopTimer
local livesText
local scoreText

-- Set up display groups
local backGroup  -- Display group for the background image
local mainGroup  -- Display group for the maincharacter, asteroids, lasers, etc.
local uiGroup    -- Display group for UI objects like the score

-- NOTE: In our original version, we created the background, maincharacter, lives text, 
-- and score text immediately following initialization of the display groups. 
-- Now, because we're only creating local references for the display groups, 
-- we must defer these actions until later, inside the scene:create() function.

-- when the scene first loads, the sound files will be loaded into the 
-- variable handles explosionSound and fireSound
local explosionSound
local fireSound
local damageSound
local restoreSound
local musicTrack

--Update text of game
local function updateText()
    livesText.text = "Lives: " .. lives
    scoreText.text = "Score: " .. score
end

--Make a function to create a new asteroid
local function createAsteroid() 
    -- Initialize asteroid sequence animation
    asteroidSequence = {
        name="woosh",
        frames={31,64,95,14,73,129},
        time=500, 
    }
    -- Load asteroid as animated sprite
    local newAsteroid = display.newSprite( mainGroup, effectSheet, asteroidSequence) --display.newImageRect( mainGroup, effectSheet, 14, 78, 78 )
    -- Increase asteroid size 
    newAsteroid:scale( 1.8, 2 )
    -- Add asteroid to table of asteroids
    table.insert( asteroidsTable, newAsteroid )
    -- Add physic body to asteroid for collision
    physics.addBody( newAsteroid, "dynamic", { radius=40, bounce=0.8 } )
    -- Set the sequence to play for the asteroid
    newAsteroid:setSequence( "shot" )
    -- Play asteroid sequence
    newAsteroid:play()
    -- Assign a name to identify the type of collision object
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
    Getting our maincharacter to fire lasers is similar to loading asteroids, but this time we'll use a 
    convenient and powerful method to move them known as a transition.     
--]]

local function fireLaser()
    -- Play fire sound!
    audio.play( fireSound )
    -- Play character animation
    maincharacter:setSequence( "shot" )
    maincharacter:play()
    
    local newLaser = display.newImageRect( mainGroup, effectSheet, 118, 100, 120 )
    physics.addBody( newLaser, "dynamic", { isSensor=true } )
    -- isBullet property makes the object subject to continuous collision detection rather than periodic collision detection at world time steps.
    newLaser.isBullet = true
    newLaser.myName = "laser"

    newLaser.x = maincharacter.x
    newLaser.y = maincharacter.y
    -- Because this function creates new lasers after the maincharacter has already been loaded, 
    -- and both objects are part of the mainGroup display group, lasers will appear visually 
    -- above (in front of) the maincharacter in terms of layering. Clearly this looks silly, so let's push it behind the maincharacter
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


-- Moving the maincharacter

--[[
    In this game, in addition to firing lasers,
    the player will be able to touch and drag
    the maincharacter along the bottom of the screen.
    To handle this type of movement,
    we need a function to handle touch/drag events.
    Let's create this function in the usual manner:
]]

-- Touch Events
-- Touch events, distinct from tap events, have four distinct phases 

local function dragMainCharacter( event )
    -- In touch/tap events, event.target is the object which was touched/tapped, 
    --so setting this local variable as a reference to the maincharacter object will save us some typing
    local maincharacter = event.target
    -- Let's locally set the phase (event.phase) of the touch event
    local phase = event.phase

    -- If it has just begun (initial touch on the maincharacter), 
    -- the "began" phase is dispatched to our function
    if ( phase == "began" ) then
        -- Set touch focus on the maincharacter
        display.currentStage:setFocus( maincharacter )
        -- Store initial offset position
        maincharacter.touchOffsetX = event.x - maincharacter.x
        -- If moving across y coordinate is wanted
        --maincharacter.touchOffsetY = event.y - maincharacter.y
    elseif (  phase == "moved" ) then
        -- Move the maincharacter to the new touch position
        maincharacter.x = event.x - maincharacter.touchOffsetX     
        -- Same case if needed for y
        --maincharacter.y = event.y maincharacter.touchOffsetY
    elseif ( phase == "ended" or  phase == "cancelled" ) then
        -- Release touch focus on the maincharacter
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

--Restoring the maincharacter
local function restoremaincharacter()
    maincharacter.isBodyActive = false
    audio.play( restoreSound)
    -- Set the maincharacter position to its initial place and to the center of the X coordinate
    maincharacter.x = display.contentCenterX
    maincharacter.y = display.contentHeight + 100
    
    -- Fade in the maincharacter
    transition.to( maincharacter, { alpha=1, time=4000,
    onComplete = function()
            maincharacter.isBodyActive = true
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
    composer.setVariable( "finalScore", score )
    composer.gotoScene( "highscores", { time=800, effect="crossFade" } )
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
 
            -- Play explosion sound!
            audio.play( explosionSound )
            
            for i = #asteroidsTable, 1, -1 do
                if ( asteroidsTable[i] == obj1 or asteroidsTable[i] == obj2 ) then
                    table.remove( asteroidsTable, i )
                    break
                end
            end
 
            -- Increase score
            score = score + 100
            scoreText.text = "Score: " .. score

        elseif ( ( obj1.myName == "maincharacter" and obj2.myName == "asteroid" ) or ( obj1.myName == "asteroid" and obj2.myName == "maincharacter" ) ) then
            if ( not died ) then
                died = true
                
                -- Play explosion sound!
                audio.play(explosionSound )
                audio.play(damageSound )
                
                -- Update lives
                lives = lives - 1
                livesText.text = "Lives: " .. lives

                if ( lives == 0 ) then
                    display.remove( maincharacter )
                    -- Logically, a scene will never be hidden unless you intentionally cause it to hide, 
                    -- and this occurs when you tell Composer to go to a different scene
                    timer.performWithDelay( 2000, endGame )
                else
                    maincharacter.alpha = 0
                    timer.performWithDelay( 1000, restoremaincharacter )
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
 
    mainGroup = display.newGroup()  -- Display group for the maincharacter, asteroids, lasers, etc.
    sceneGroup:insert( mainGroup )  -- Insert into the scene's view group
 
    uiGroup = display.newGroup()    -- Display group for UI objects like the score
    sceneGroup:insert( uiGroup )    -- Insert into the scene's view group
 
    -- Initialize scene's objects
    -- Notice that we are still inserting objects into their proper display groups such as backGroup, 
    -- mainGroup, and uiGroup. This is the correct procedure because all of those groups were inserted
    -- into the scene's view group and they are now children of that parent group.
    -- Load the background
    local background = display.newImageRect( backGroup, "assets/images/background.png", 800, 1400 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    -- To consider: Essentially, you can create a forward reference in the scene-accessible area, 
    -- assign an actual object to that reference inside a scene: function, and then other functions 
    -- will associate the reference with the new object.
    -- Initialize the maincharacter
    charSequence = {
        name="shot",
        start=121,
        count=13,
        time=250,
        loopCount=1, 
    }
    maincharacter = display.newSprite( mainGroup, charSheet, charSequence) --display.newImageRect(mainGroup, charSheet, 1, 128, 128 )
    maincharacter:scale( 2, 2 )
    maincharacter.x = display.contentCenterX
    maincharacter.y = display.contentHeight + 100
    physics.addBody( maincharacter, { radius=30, isSensor=true } )
    maincharacter.myName = "maincharacter"
 
    -- Display lives and score
    livesText = display.newText( uiGroup, "Lives: " .. lives, 200, -70, native.systemFont, 44 )
    scoreText = display.newText( uiGroup, "Score: " .. score, 600, -70, native.systemFont, 44 )

    -- Add "tap" and "touch" event listeners
    maincharacter:addEventListener( "tap", fireLaser )
    maincharacter:addEventListener( "touch", dragMainCharacter )

    -- Load sound files
    explosionSound = audio.loadSound( "assets/audio/sounds/cpr_pichu_hit.wav" )
    fireSound = audio.loadSound( "assets/audio/sounds/Laser1.wav" )
    damageSound = audio.loadSound("assets/audio/sounds/cpr_pikachu_damage.wav")
    restoreSound = audio.loadSound("assets/audio/sounds/cpr_pikachu_appear.wav")
    musicTrack = audio.loadStream( "assets/audio/music/Reinforcement.mp3")
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

        -- Start the music!
        audio.play( musicTrack, { channel=1, loops=-1 } )
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

        -- Stop the music!
        audio.stop( 1 )
        
        -- Dismiss scene from the game memory
        composer.removeScene( "game" )
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
    -- Dispose audio!
    audio.dispose( explosionSound )
    audio.dispose( fireSound )
    audio.dispose( damageSound )
    audio.dispose( restoreSound)
    audio.dispose( musicTrack )
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
