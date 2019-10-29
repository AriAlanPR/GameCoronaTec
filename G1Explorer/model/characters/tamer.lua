--
-- created with TexturePacker - https://www.codeandweb.com/texturepacker
--
-- $TexturePacker:SmartUpdate:23571f956688cbd08e2a07140890028b:9bb279f5a823770387b32f331e540620:1309b53b46d7e452512d728b3d2bd656$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- sprite_0-0
            x=102,
            y=0,
            width=20,
            height=48,

            sourceX = 0,
            sourceY = 2,
            sourceWidth = 20,
            sourceHeight = 50
        },
        {
            -- sprite_0-1
            x=32,
            y=82,
            width=20,
            height=50,

        },
        {
            -- sprite_0-2
            x=52,
            y=82,
            width=20,
            height=50,

        },
        {
            -- sprite_0-3
            x=72,
            y=82,
            width=20,
            height=50,

        },
        {
            -- sprite_0-4
            x=102,
            y=48,
            width=20,
            height=48,

            sourceX = 0,
            sourceY = 2,
            sourceWidth = 20,
            sourceHeight = 50
        },
        {
            -- sprite_1-0
            x=0,
            y=82,
            width=32,
            height=42,

            sourceX = 4,
            sourceY = 0,
            sourceWidth = 36,
            sourceHeight = 42
        },
        {
            -- sprite_2-0
            x=0,
            y=0,
            width=36,
            height=41,

        },
        {
            -- sprite_2-1
            x=36,
            y=0,
            width=36,
            height=41,

        },
        {
            -- sprite_2-2
            x=72,
            y=0,
            width=30,
            height=41,

            sourceX = 6,
            sourceY = 0,
            sourceWidth = 36,
            sourceHeight = 41
        },
        {
            -- sprite_2-3
            x=0,
            y=41,
            width=36,
            height=41,

        },
        {
            -- sprite_2-4
            x=36,
            y=41,
            width=36,
            height=41,

        },
        {
            -- sprite_2-5
            x=72,
            y=41,
            width=30,
            height=41,

            sourceX = 6,
            sourceY = 0,
            sourceWidth = 36,
            sourceHeight = 41
        },
    },

    sheetContentWidth = 122,
    sheetContentHeight = 132
}

SheetInfo.frameIndex =
{

    ["sprite_0-0"] = 1,
    ["sprite_0-1"] = 2,
    ["sprite_0-2"] = 3,
    ["sprite_0-3"] = 4,
    ["sprite_0-4"] = 5,
    ["sprite_1-0"] = 6,
    ["sprite_2-0"] = 7,
    ["sprite_2-1"] = 8,
    ["sprite_2-2"] = 9,
    ["sprite_2-3"] = 10,
    ["sprite_2-4"] = 11,
    ["sprite_2-5"] = 12,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
