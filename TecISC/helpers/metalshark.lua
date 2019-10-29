--
-- created with TexturePacker - https://www.codeandweb.com/texturepacker
--
-- $TexturePacker:SmartUpdate:ffc844e75e582f8a437b8a68b392afa7:58b7faccd4d37f549586f132a4777a3e:4abfdabb86f42c9b9ae905e5aa27c7de$
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
            -- frame1
            x=0,
            y=0,
            width=958,
            height=586,

        },
        {
            -- frame2
            x=958,
            y=0,
            width=958,
            height=586,

        },
        {
            -- frame3
            x=0,
            y=586,
            width=958,
            height=586,

        },
        {
            -- frame4
            x=958,
            y=586,
            width=958,
            height=586,

        },
        {
            -- frame5
            x=0,
            y=1172,
            width=958,
            height=586,

        },
        {
            -- frame6
            x=958,
            y=1172,
            width=958,
            height=586,

        },
    },

    sheetContentWidth = 1916,
    sheetContentHeight = 1758
}

SheetInfo.frameIndex =
{

    ["frame1"] = 1,
    ["frame2"] = 2,
    ["frame3"] = 3,
    ["frame4"] = 4,
    ["frame5"] = 5,
    ["frame6"] = 6,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
