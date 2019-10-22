-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
-- local variable called composer
local composer = require( "composer" )
 
-- Hide status bar
display.setStatusBar( display.HiddenStatusBar )
 
-- Seed the random number generator
math.randomseed( os.time() )
 
-- Go to the menu screen
composer.gotoScene( "menu" )

-- Reserve channel 1 for background music
audio.reserveChannels( 1 )

-- Reduce the overall volume of the channel
audio.setVolume( 0.5, { channel=1 } )