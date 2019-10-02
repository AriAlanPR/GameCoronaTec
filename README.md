# Corona-Tec Getting started
Before we jump into designing and programming our next game, we need to think about the features and other aspects. This usually begins with a design document for any major project.

## For star explorer game: Design Document
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

* **NOTE:** - *It's important to understand that these values do not indicate an exact number of pixels, but rather a relative number of content "units" for the app. The content area will be scaled to fit any device's screen, with subtle differences dictated by the scale definition (see the next point).*




### References 
[Corona Labs official documentation](https://docs.coronalabs.com/guide/programming/)