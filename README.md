# Corona-Tec Getting started
Before we jump into designing and programming our next game, we need to think about the features and other aspects. This usually begins with a design document for any major project.

## Introduction to Lua
Corona SDK works with Lua programming language.
In Lua comments are written with `--` before the comment.

 You can comment out a full block of code by surrounding it with `--[[` and `--]]`

```
-- Single line commented out
 
--[[ Entire block commented out
print( 10 )
print( 15 )
--]]
```

Also **Lua** basic types that should be concerned for our purposes are:
* **nil** — equivalent to *null* in other programming languages, means absence of type and value.
* **boolean** — the type of the values false and true. Both nil and false make a condition false; any other value makes it true.
* **number** — represents real (double-precision floating-point) numbers.
* **string** — represents arrays of characters. Lua is 8-bit clean: strings can contain any 8-bit character, including embedded zeros.
* **function** — Methods that return a value.
* **table** — the sole data structuring mechanism in Lua, Tables are objects. They implement associative arrays, meaning that arrays can be indexed not only with numbers, but with any value except nil, also they can be heterogeneous, meaning that they can contain diferent elements with different data types.

A **numerical constant** can be written with an optional decimal part and an optional decimal exponent. Lua also accepts integer hexadecimal constants, by prefixing them with `0x`. 

```
3    3.0    3.1416    314.16e-2    0.31416E1    0xff    0x56
```

### Lua variables. 
There are three kinds of variables in Lua: **global**, **local**, and **table fields (properties)**. Any non-initialized variable is `nil` by default.

**Note:** *Lua variables use type inference, which means no type data definition is needed to be declare since the language automatically tries to deduce its type. In other words, variables do not have types, only values do.*

**Global** variables do not need declarations. You simply assign a value to one to create it. They live as long as your application is running. You can delete a global variable by assigning nil to it. At this point, the global variable behaves as if it were never initialized.

```
print( s )  --> nil 
 
s = "One million dollars"
 
print( s )  --> One million dollars
```

**Local** variables are declared with the reserved word `local` before the variable name. Unlike global variables, local variables are visible only in the block where they are declared. The scope of the local variable begins after the declaration and ends at the end of the block.

```
a = 10
local i = 1
 
while ( i <= 10 ) do
    local a = i*i  -- Different variable "a", local to this "while" block
    print( a )     --> 1, 4, 9, 16, 25, ...
    i = i + 1
end
  
print( a )         --> 10 (the global "a")
```

**Table fields** are just the elements of the table themselves. You index into the array to assign the values to a field.

```
t = { foo="hello" }  -- Create table with a single property "foo"
print( t.foo )       --> "hello"
 
t.foo = "bye"        -- Assign a new value to property "foo"
print( t.foo )       --> "bye"
 
t.bar = 10           -- Create a new property named "bar"
print( t.bar )       --> 10
print( t["bar"] )    --> 10
```

**Note:** *Tables can´t contain nil values, in particular, because functions are first-class values, table fields can contain functions. Thus tables can also carry methods.*

**Note:** *Lua provides automatic conversion between string and number values at run time. Any arithmetic operation applied to a string tries to convert this string to a number, following the usual conversion rules. Conversely, whenever a number is used where a string is expected, the number is converted to a string, in a reasonable format. For complete control over how numbers are converted to strings, use the string.format function from the string library.*


Tables example
```
t = {}           -- Create a table
 
k = "x"
t[k] = 3.14      -- New table entry with key = "x" and value = 3.14
 
print( t[k] )    --> 3.14
print( t["x"] )  --> 3.14
print( t.x )     --> 3.14
 
t[2] = "foo"     -- New table entry with key = 2 and value = "foo"
 
print( t[2] )    --> "foo"
```

### Functions
Plain functions are just as expected: you provide arguments as input (within the parentheses), the function performs some tasks, and the results can be returned.

Lua functions can be declared in many different ways: 

`local` `function` *FunctionName*(*parameters_needed...*)
<br>
&emsp;*content...*
<br>
`end`


`local` *FunctionName* = `function` (*parameters_needed...*)
<br>
&emsp;*content...*
<br>
`end`

`function` *FunctionName* (*parameters_needed...*)
<br>
&emsp;*content...*
<br>
`end`

*FunctionName* = `function` (*parameters_needed...*)
<br>
&emsp;*content...*
<br>
`end`

### Objects

Objects in Lua are represented by tables. Display objects and the global Runtime object are all objects. 
<br>
Like the math library, these objects similarly store object methods (instance methods) as properties. One key difference, however, is syntax. You need to tell Lua that you intend this function to be called as an object method, not just a plain function. 
<br>
To do so, you need to use the colon (:) operator instead of the dot operator. This may be different from other languages.



### Expressions
**Aritmetic operators**
```
+	addition
-	subtraction
*	multiplication
/	division
%	modulo
^	exponentiation
```

**Relational operators**
```
==	equal to
~=	not equal to
<	less than
>	greater than
<=	less than or equal to
>=	greater than or equal to
```

**Logical operators**
The logical operators in Lua are `and`, `or`, and `not`. All logical operators consider both `false` and `nil` as false and anything else as true.

Both `and` and `or` use shortcut evaluation — the second operand is evaluated only if necessary.
```
10 or 20           --> 10
10 or error()      --> 10
nil or "a"         --> "a"
nil and 10         --> nil
false and error()  --> false
false and nil      --> false
false or nil       --> nil
10 and 20          --> 20
```

**Concatenation**
<br>
The string concatenation operator in Lua is denoted by two dots (`..`). If both operands are strings or numbers, then they are converted to strings according to the conversion rules mentioned above.

```
local s = "foo".."10" --> "foo10"
```

**Length Operator**
<br>
The length operator is denoted by the unary operator #. 

The length of a string is its number of bytes — the usual meaning of string length when each character is one byte.

The length of a table `t` is defined to be any integer index `n` such that `t[n]` is not `nil` and `t[n+1]` is `nil`; moreover, if `t[1]` is `nil`, `n` can be zero. 

**Note:** *For a regular array, with non-nil values from **1** to a given `n`, its length is exactly that `n`, the index of its last value. If the array has "holes" (`nil` values between other non-nil values), then `#t` can be any of the indices that directly precedes a `nil` value. Thus, it may consider any such `nil` value as the end of the array.*

**Precedence**
<br>
Operator precedence in Lua follows the list below, from lower to higher priority:
```
|   or
|   and
|   <, >, <=, >=, ~=, ==
|   ..
|   +, -
|   *, /, %
|   not, #, - (unary)
|   ^
v   ()
```

**Syntax comparisons**

* **semicolons** — trailing semicolon at the end of each statement (effectively a line of code) are optional in Lua.

* **braces** — You may be accustomed to using { } to define variable scope. In Lua, you do this by bracketing the code with do and end. Braces in Lua are interpreted as table constructors.

* **if - then - else** — if you come from C, Java, Javascript, etc., a common mistake you'll make in writing if and elseif statements is forgetting to append then to the end of the if/elseif test conditions. Another common mistake is inadvertently using else if (with a space) when Lua expects elseif.

* **arrays** — in Lua, arrays are 1-based. Technically, you can index into an array starting with 0. However, Lua and Corona APIs assume that the first element of a table t is t[1], not t[0].

* **multiple return values** — an unconventional but useful feature in Lua is the ability of a function to return more than one result.

* **multiple assignment** — multiple assignments offer a convenient way to swap values. The statement x,y = y,x will swap x for y and vice versa.

* **ternary operator (? :)** — Lua does not offer the equivalent to the C ternary operator a?b:c. The Lua idiom (a and b) or c offers a close approximation provided b is not false. For example, the Lua equivalent to max = (x>y?x:y) would be max = ( x>y and x or y).

## if-then 

Conditional expressions are made with the syntax

`ìf` *condition* `then`
<br>
&emsp;*content of true condition*
<br>
`else`
<br>
&emsp;*content of false condition*
<br>
`end`

**Note:** *Its possible to use* `elsif` *instead of* `else` *to keep going with more conditions. Also it´s optional to use paretheses when writing the condition.*

## For loop
In Lua for loops are declared with the sintax:


`for` *variable = startvalue, limit, countby* `do`
<br> 
&emsp;*content code*
<br> 
`end`

As you can see, we use this method in our for loop which takes the indicated form — basically, Lua uses a *variable* that holds the start value or index, stops at a *limit* value, and *counts by* a value which is a decrement when that value is negative and vice versa.

## For star explorer game: 
**Design Document**
```
* Game Title:	Star Explorer — a space shooter game.
* Description:	Maneuver your starship through an asteroid field, destroying asteroids as you progress.
* Controls:	Tap on the ship to fire; drag the ship to move left and right.
* Sounds:	Shooting sound and explosion sound when the ship collides with an asteroid.
```

## Build Settings
The build.settings file provides real devices (phones, tablets, etc.) with details they need regarding your app. This includes the supported orientations for the app, names of icon files, plugins to include, special information required by devices, and more.

Our StarExplorer app will only be available to play in portrait mode, so we set this on the following two lines:

```
default = "portrait", — This line tells Corona that the game should begin in portrait orientation (when the user first loads the app).
```

```
supported = { "portrait", }, — This line tells Corona that the only supported orientation is also portrait. That means that even if the user turns (orients) the physical device around in their hands, your app will remain locked in portrait orientation.
```

## Configuration Options
The config.lua file contains all of the Corona-specific app configuration settings. This is where we specify what content resolution the app will run at, the content scale mode, how Corona should handle high-resolution devices, etc.

```
width and height — These values specify the content area size for the app. In Corona, your base content area can be whatever you wish, but often it's based around a common screen width/height aspect ratio like 3:4, set here by 768 and 1024.
```

* **Note:** *It's important to understand that these values do not indicate an exact number of pixels, but rather a relative number of content "units" for the app. The content area will be scaled to fit any device's screen, with subtle differences dictated by the scale definition (see the next point).*

```
scale — This important setting tells Corona how to handle the content area for screens which do not match the aspect ratio defined by the width and height settings, for example 3:4 in this case. The two most common options are "letterbox" and "zoomEven".
```

* "letterbox" *scales the content area to fill the screen while preserving the same aspect ratio. The entire content area will reside on the screen, but this might result in "black bars" on devices with aspect ratios that differ from your content aspect ratio. Note, however, that you can still utilize this "blank" area and fill it with visual elements by positioning them or extending them outside the content area bounds. Essentially, "letterbox" is an ideal scale mode if you want to ensure that everything in your content area appears within the screen bounds on all devices.*

* "zoomEven" *scales the content area to fill the screen while preserving the same aspect ratio. Some content may "bleed" off the screen edges on devices with aspect ratios that differ from your content aspect ratio. Basically, "zoomEven" is a good option to ensure that the entire screen is filled by the content area on all devices (and content clipping near the outer edges is acceptable).*


## Physics Setup
```
local physics = require("physics")
```
 By default, the physics engine simulates standard Earth gravity which causes objects to fall toward the bottom of the screen. To change this, we use the physics.setGravity() command which can simulate gravity in both the horizontal (x) or vertical (y) directions. 
 Since this game takes place in outer space, we are going to assume that gravity does not apply. Thus, we set both values to 0.

## Random Seed
Our game will randomly spawn asteroids outside of the screen edges, so we'll be implementing random number generation further along in this project. First, though, we need to set the "seed" for the pseudo-random number generator. 

On some operating systems, this generator begins with the same initial value which causes random numbers to repeat in a predictable pattern. The following addition to our code ensures that the generator always starts with a different seed.
```
math.randomseed(os.time())
```

**Note:** *When you intend to generate random numbers in an app, seed the pseudo-random number generator just once, typically within main.lua. Doing so multiple times is redundant and unnecessary.*

## Some properties

we specify properties whilst coding: 
* `isSensor = bool`. This tells Corona that the object should be a sensor object. 
Essentially, sensor objects detect collisions with other physical objects but they do not produce a physical response. 
* `isBullet = Bool`. Complement to `isSensor` property, this helps us have the object subject to continuous collission detection rather than real world collision detection at certain time steps.
* `radius = number`. Used to add a circular physical body to the object we´re working on.
* `isBodyActive = Bool`. Effectively removes the ship from the physics simulation so that it ceases to interact with other bodies.  

## Cleanup
New lasers will appear at the same location as the ship (visually behind it too) and move upward across the screen. There is just one last thing to implement, and it's very important: cleanup. In any app, it's critical that you remove objects from the game which are no longer needed. If you don't, the app will eventually slow to a crawl, run out of memory, and crash — not a good experience for the player!

In Corona, there are various approaches toward cleanup and it will depend on the situation. For the lasers, we're going to use a very convenient method known as an onComplete callback. Available as an option within `transition.to()` and several other commands, this tells Corona that you want to call a function when something "completes."


It's very important to understand basic Lua memory management and how it relates to Corona display objects. 
<br>
For example, with:

```
if ( thisAsteroid.x < -100 or
    thisAsteroid.x > display.contentWidth + 100 or
    thisAsteroid.y < -100 or
    thisAsteroid.y > display.contentHeight + 100 )
then
    display.remove( thisAsteroid )
    table.remove( asteroidsTable, i )
end
```

The first command above, display.remove( thisAsteroid ), will remove the asteroid from the screen, visually. However, that command alone will not release the asteroid from Lua memory. Why?

Because we stored an additional reference to the asteroid inside the asteroidsTable table, Lua cannot free up the memory allocated to the asteroid object until that reference is removed. That's why we perform the second command, table.remove( asteroidsTable, i ), directly afterward. This effectively removes that additional reference and, because there are no other persistent references to the object, the Lua garbage collection process can then automatically free its allocated memory.

## Events and listeners

**Tap Listener**
<br>
A "tap" event listener allows the player to respond to a touch over an object.

**Touch events**
<br>
Distinct from tap events, have four distinct phases based on the state of the user's touch:

* `"began"` — indicates that a touch has started on the object (initial touch on the screen).
* `"moved"` — indicates that a touch position has moved on the object.
* `"ended"` — indicates that a touch has ended on the object (touch lifted from the screen).
* `"cancelled"` — indicates that the system cancelled tracking of the touch (not to be confused with "ended").

## Game Loop
Many games include some type of game loop to handle the updating of information, checking/updating the state of game objects, etc. 
<br>
A game loop function is usually short — instead of containing a large amount of code itself, it typically calls other functions to handle specific repetitive functionality.
<br>
For **Star explorer** game will be used to create new asteroids and clean up "dead" asteroids.

### Timer 
Timers can be performed with the following method: `timer.performWithDelay()`.  Timers are useful for a wide array of game functionality.
<br>
The syntax for a timer method is:
```
timer.performWithDelay( time, functiontofire, numberoftimes )
```
First parameter sent is the time before the function fires in miliseconds(1s = 1000ms).
<br>
Then we send a function to fire when the time stablished has passed.
<br>
If the numberoftimes parameter is omitted, timers will simply fire once and stop. If the value sent to this parameter is
**0** or **-1** the timer will keep firing the function indefinitely(unless we tell it to stop).

## Collision Handling
Collisions are reported between pairs of objects, and they can be detected either locally on an object, using an object listener, or globally using a runtime listener. Different games require different methods
* Local collision handling is best utilized in a one-to-many collision scenario, for example one player object which may collide with multiple enemies, power-ups, etc.
* Global collision handling is best utilized in a many-to-many collision scenario, for example multiple hero characters which may collide with multiple enemies.

Similar to touch events, collisions have distinct phases, in this case "began" and "ended".

## Game Flow
A scene is an isolated view or "page" of the app and everything that the player sees is contained in that scene. When an app starts, you're usually presented with a title/intro scene. From there, you may be able to navigate to a settings scene or proceed to a tutorial. Each level in a game might also be a dedicated scene, depending on the design goals.

For star explorer game we will have three core scenes:

* Menu — Title/intro scene containing various options.
* Game — The actual game scene.
* High Scores — A list of high scores.

Corona uses a system called Composer to handle moving from scene to scene. To make development easier, each Composer scene is a separate Lua file — this helps keep your game more organized.

## Composer and Scenes
The `composer.gotoScene(scenename)` tells composer to load a scene using the file's name(no needed to add de .lua extension at the end). 
<br>
For example, in the following code we tell composer to load a scene from 'menu.lua' file: 
```
composer.gotoScene("menu")
```

Each Scene *.lua* file is where you should usually write your functions which pertain to scene behavior, declare variables which the scene must have persistent access to, etc.

### Transition events
The composer.gotoScene() command also allows you to specify a transition effect such as fading in, sliding in from a screen edge, cross-fading from the previous scene, etc. Naturally, there is a time duration associated with the start and finish of scene transitions, and this is where scene phases come into play.

### Scene Events
Composer scenes can utilize four (4) life cycle events, each triggered at different points in the scene's life:

* **create**,	Occurs when the scene is first created but has not yet appeared on screen.
* **show**,	Occurs twice, immediately before and immediately after the scene appears on screen.
* **hide**,	Occurs twice, immediately before and immediately after the scene exits the screen.
* **destroy**,	Occurs if the scene is destroyed.

We can send these functions as listeners to the *scene* event. For example, in the following code:
```
scene:create( event )
```
It indicates that this function will be associated with the Composer create scene event and that a table of data that we reference with event will be passed to the function.

### Scene Phases
An important factor to understand (in contrast to scene:create()) is that Composer calls the scene:show() function twice. Of course it's imperative to know when each of these calls occurs so that we can take the proper actions at the proper time.

Basically, scene:show() calls/phases work like this:

* The first call occurs when the scene is ready to be shown, essentially after every command within scene:create() has been executed. In this case, event.phase is "will", effectively indicating that the scene "will show" and the transition effect is about to occur.

* The second call occurs immediately after the scene has shown — basically, when the scene transition has completed. In this case, event.phase is "did", meaning the scene "did show" and the transition effect completed.

Scene:hide() calls/phases work like this:

* The first call occurs when the scene is about to be hidden (transition off screen). In this case, event.phase is "will", effectively indicating that the scene "will hide" and the transition effect is about to occur.
* The second call occurs immediately after the scene is fully off screen. In this case, event.phase is "did", meaning the scene "did hide" and the transition effect completed.

### Scene Cleanup
Hopefully players will want to play the game again! By default, Composer caches scenes in memory to save processing power when the scene is revisited. So, even though it's hidden at this point, your game scene remains basically as you left it.

To consider, we got some problems:

* The asteroids from the previous game are still in the scene.
* Your previous score still appears and lives remain at zero.
* The ship isn't showing!

Depending on the game, cleaning up a scene to restart fresh can involve some effort. In some certain games, we would need to "undo" some things we did in scene:create() as well as remove the references to old objects contained in the objectTable. We would also need to reset score, lives, and the some object's visibility within scene:show(). None of this is exceptionally complicated, but wouldn't it be convenient to have an easier way to reset a scene? Fortunately, Composer offers one:
```
composer.removeScene( scenename )
```

Essentially, this command removes and destroys the game.lua scene as if it never existed. By doing so, you lose the caching benefit mentioned above, but for most scenes it's not worth the effort to programmatically reset each aspect individually.

### Composer-Accessible Data
Lua itself provides various ways to pass and access data between modules, but Composer makes it even easier with the following commands:

* composer.setVariable() — Sets a variable declared in one scene to be accessible throughout the entire Composer-structured app.
* composer.getVariable() — Allows you to retrieve the value of any variable previously set via composer.setVariable().

For example: 
```
composer.setVariable( "finalScore", score )
```
composer.setVariable(*variablename*, *value*), creates a Composer-accessible variable named finalScore with an assigned value of the score variable. 
The following method tells Corona to save a new file in a specified directory
```
system.pathForFile(filename, directory)
```

For example, if we call:
```
system.pathForFile( "file.json", system.DocumentsDirectory)
```
Property system.DocumentsDirectory tells Corona to create the *file*.json within the app's internal "documents" directory when saving a new file. 

**Note:** *Any data which needs to be accessed at some point after the app quits/closes should be stored in a persistent state, and the easiest way to store persistent data is to save it to a file on the device. Furthermore, this file must be stored in a persistent location.*

### Loading Data
In the following example for star explorer game we can do an inspect of how to read scores:
```
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
```

* When working with files containing data, the first step is to confirm that the file exists. 
* In the conditional block following, if the file exists, its contents will be dumped into the local variable contents. Once we have its contents, we close the file with io.close( file ). 
* we decode contents and store the values in scoresTable using json.decode() which converts a file of type *.json* into a Lua table which can be used in our app.
* At the end, just in case the scores.json file is empty or doesn't exist, we assign scoresTable ten default values of 0 so that the scene has something to work with.  

### Saving Data
In the function below, we can make a tiny analysis like we did with the reading data for Star Explorer either:
```
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
```

* First, we clear out any unneeded scores from scoresTable. 
* Next, we open the scores.json file. Unlike io.open() call within loadScores(), here we specify "w" as the second parameter. This tells Corona to create (write) a new file or overwrite the file if it already exists. It also tells Corona to open the file with write access.
* Once the file is successfully open, we call file:write() to write the scoresTable data to the file, converted into JSON via the json.encode() command.
* Finally, we close the file with io.close( file ).

### Sort
To sort a table we use the Lua `table.sort()` function.
<br>
For this to work, we must provide it with the table to sort and a reference to a comparison function (compare()) which determines if items need to swap places. 

### Anchors
By default, Corona positions the center of any display object at the x and y coordinate given. However, sometimes you'll need to align a series of objects along their edges — here, the list of scores will look best if each rank number is right-aligned and each score is left-aligned.
To accomplish this, notice that in the following example code(star explorer) we set the anchorX property of each object. This property typically ranges between 0 (left) and 1 (right), with a default of 0.5 (center). 
```
someobject.anchorX = 0
someobject.anchorY = 0
```
Anchors can even be set outside of the 0 to 1 range, although this usage is less common. Setting either anchorX or anchorY to values less than 0 or greater than 1 will place the anchor point conceptually somewhere in space outside of the object's edge boundaries, which can be useful in some instances.

### Preloading and streaming audio
There are two ways to load audio in your Corona app. Which one you use typically depends on how the audio file will be utilized.
The first method is to use the audio.loadSound() command. This loads and pre-processes the entire audio file, after which it can be played on demand.
For example:
```
local explosionSound = audio.loadSound( "explosion.wav" )
```
Once loaded, the sound can be played as many times as needed using the `audio.play()` command along with the audio *handle* you created via `audio.loadSound()`.

 **Important Note:** *You do **not** play an audio file by directly specifying the file name. Instead, specify the handle variable assigned to `audio.loadSound()`.*

For example, if our game has four objects explode simultaneously and each requires the explosion.wav sound to be played, we could issue these commands:
```
audio.play( explosionSound )
audio.play( explosionSound )
audio.play( explosionSound )
audio.play( explosionSound )
```

In other words, there is no need to preload the same audio file multiple times with *audio.loadSound()*

 by default, each instance will be assigned to a distinct audio channel. Then, once each instance has finished playing, the audio system will release/clear its channel so that another sound can be played upon it.

 ### Streaming
The second method to load audio into your app is audio.loadStream(). 

This will gradually load and process small chunks of the audio file as needed. This command is best used in situations where possible latency will not have a critical impact upon the usability of the app. 

**Note:** *Streaming does not use as much memory, so it's usually the best choice for large audio files such as background music.*

An example of use when using this method is:
```
local backgroundMusic = audio.loadStream( "musicTrack1.wav" )
```

**Important Note:** *Unlike audio.loadSound(), audio files loaded with audio.loadStream() can only be played on one channel at a time. If you need the same audio file to stream on multiple channels, you'll need to load two distinct audio handles, for instance:*
```
local backgroundMusic1 = audio.loadStream( "musicTrack1.wav" )
local backgroundMusic2 = audio.loadStream( "musicTrack1.wav" )
```

**Channel management.**
 Basically, for our sound effects, we simply let the audio library pick a free channel on which to play any new sound instance. For music however, it's often useful to reserve a specific channel and play all of the background music on that channel — after all, it's unlikely that you'll want to have multiple music files playing at the same time, overlapping and audibly conflicting with each other. By reserving one dedicated channel for music, we can use it for all of the background music throughout the game.

We can do this with the following code:
```
audio.reserveChannels( channelnumber )
```
We send a number through the channelnumber parameter to the audio.reserveChannels, for example: **1**

It's possible to manipulate the overall volume of the channel
```
audio.setVolume( 0.5, { channel=1 } )
```

The foolowing code has a function `audio.play()` that simply starts playing the music. It's similar to how we play the sound effects except that it includes a Lua table as the second argument containing options for the command. Specifically, channel=1 instructs the audio library to explicitly play the music on *channel 1* and *loops=-1* tells the audio system to repeat (loop) the file indefinitely.
```
audio.play( musicTrack, { channel=1, loops=-1 } )
```

Unlike sound effects which are typically short and get cleared from their channel upon completion, streaming music should usually be stopped at an appropriate time when you're about to leave the scene. This can be easily handled in the "did" phase condition of the `scene:hide()` function. 
We can achieve it by executing the following command:
```
audio.stop( channelnumber )
```
As in reserve channel, we use a number through the channelnumber parameter to the audio.stop, for example: **1**

### Disposing Audio
This is where the `scene:destroy()` function comes in handy, since it gets triggered as a result of calling `composer.removeScene()` or when Composer itself destroys the scene.

When we need to do this, we simply call `audio.dispose()` function like in the following example:
```
audio.dispose( musicTrack )
```

**Important Note:** *we supply an audio handle to the audio.dispose() command, for example musicTrack. You should not attempt to dispose audio by simply indicating an audio file name.*

### Icons

Each of the app stores — the Apple App Store™, Google Play™, Amazon Appstore™, etc. — have different icon requirements and each requests various sizes and design considerations for different devices. There are several online services that will automatically create the entire set of required icons in the correct sizes, although you may wish to design them all yourself. Remember, these will be relatively small in size when they visually represent your app on an actual device, so fine details might be lost.

### References 
* [Corona Labs official Getting Started documentation](https://docs.coronalabs.com/guide/programming/)
* [Corona Labs Introduction to Lua documentation](https://docs.coronalabs.com/guide/start/introLua/index.html)