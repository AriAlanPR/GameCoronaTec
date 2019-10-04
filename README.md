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


Lua functions are declared with the syntax: 

`local` `function` *FunctionName*(*parameters_needed...*)
<br>
&emsp;*content...*
<br>
`end`

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
The string concatenation operator in Lua is denoted by two dots (`..`). If both operands are strings or numbers, then they are converted to strings according to the conversion rules mentioned above.

```
local s = "foo".."10" --> "foo10"
```

**Length Operator**
The length operator is denoted by the unary operator #. 

The length of a string is its number of bytes — the usual meaning of string length when each character is one byte.

The length of a table `t` is defined to be any integer index `n` such that `t[n]` is not `nil` and `t[n+1]` is `nil`; moreover, if `t[1]` is `nil`, `n` can be zero. 

**Note:** *For a regular array, with non-nil values from **1** to a given `n`, its length is exactly that `n`, the index of its last value. If the array has "holes" (`nil` values between other non-nil values), then `#t` can be any of the indices that directly precedes a `nil` value. Thus, it may consider any such `nil` value as the end of the array.*

**Precedence**
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

**Note:** 
*When you intend to generate random numbers in an app, seed the pseudo-random number generator just once, typically within main.lua. Doing so multiple times is redundant and unnecessary.*



### References 
* [Corona Labs official Getting Started documentation](https://docs.coronalabs.com/guide/programming/)
* [Corona Labs Introduction to Lua documentation](https://docs.coronalabs.com/guide/start/introLua/index.html)