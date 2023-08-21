local curitem = 1
local profile_location = "Save/LocalProfiles/".. GAMESTATE:GetEditLocalProfileID() .."/OutFoxPrefs.ini"
local maximum_array_size = math.floor( SCREEN_WIDTH / 64 )-( SCREEN_WIDTH > 1280 and 3 or 2 ) 
local img_cache = LoadModule("Profile.GetAvatarImageArray.lua")()
local imgsave = LoadModule("Config.Load.lua")("AvatarImage", profile_location )
local yarrayamm = (#img_cache / maximum_array_size)
local spacingyscale = scale( SCREEN_WIDTH, 960, 1280, 6, 5 )
local spacingxscale = scale( SCREEN_WIDTH, 960, 1280, 71.6, 69.3 )
local t = Def.ActorFrame{
    ChangeItemsMessageCommand=function(s,param)
        local c = param.item
        local Sel = s:GetChild("Selector")
        local CImg = s:GetChild("InfoFrame"):GetChild("CurImage")
        local CTex = s:GetChild("InfoFrame"):GetChild("CurText")
        Sel:stoptweening():decelerate(0.1):xy(
            50+math.mod( c-1, maximum_array_size )*spacingxscale, 
            SCREEN_CENTER_Y-120+(
                math.mod( c > maximum_array_size*6 and maximum_array_size*5 or c-1, maximum_array_size*6)
                -
                math.mod( c > maximum_array_size*6 and maximum_array_size*5 or c-1, maximum_array_size)
            )*spacingyscale
        )
        CImg:Load( img_cache[c][2] ):setsize(96,96)
        CTex:settext( string.gsub( img_cache[c][1], ".png", "" ) )
    end,
}
----

local ImgGrid = Def.ActorFrame{
    ScrollGridMessageCommand=function(s,param)
        s:stoptweening():decelerate(0.2):y( -80*(param.tileoffset-5) )
    end,
}
if #img_cache > 0 then
    for i,v in pairs( img_cache ) do
        -- Look if we have an existing image with the listing.
        if imgsave and tostring(imgsave) == v[2] then curitem = i end
        ImgGrid[#ImgGrid+1] = Def.ActorFrame{
            OnCommand=function(s)
                s:xy( 50+math.mod( i-1, maximum_array_size )*spacingxscale, SCREEN_CENTER_Y-120+( math.mod(i-1, maximum_array_size*yarrayamm)-math.mod(i-1, maximum_array_size) )*spacingyscale )
            end,
            Def.Sprite{
                Texture=v[2],
                OnCommand=function(s)s:setsize(64,64):diffusealpha(0):addy(20):sleep(0.004*i):decelerate(0.1):addy(-20):diffusealpha(1) end,
                OffCommand=function(s) s:stoptweening():sleep( 0.004*i):accelerate(0.1):addy(20):diffusealpha(0) end,
            },
        }
    end
    t[#t+1] = ImgGrid
end

t[#t+1] = Def.Quad{
    Name="Selector",
    Condition=#img_cache > 0,
    OnCommand=function(s)
        s:zoomto(64,64):diffuseshift()
        :effectcolor1( color("#FFFFFF99") ):effectcolor2( color("#FFFFFF00") )
        s:xy(
            50+math.mod( curitem-1, maximum_array_size )*spacingxscale, 
            SCREEN_CENTER_Y-120+( math.mod(curitem-1, maximum_array_size*yarrayamm)-math.mod(curitem-1, maximum_array_size) )*spacingyscale
        ):diffusealpha(0):sleep(0.24):linear(0.1):diffusealpha(1)
    end,
    OffCommand=function(s) s:linear(0.2):diffusealpha(0) end,
}

t[#t+1] = Def.ActorFrame{
    Name="InfoFrame",
    OnCommand=function(s)
        s:diffusealpha(0):addy(-20):decelerate(0.2):addy(20):diffusealpha(1)
    end,
    OffCommand=function(s)
        s:accelerate(0.2):addy(-20):diffusealpha(0)
    end,

    Def.Quad{
        Condition=#img_cache > 0,
        OnCommand=function(s)
            s:xy( SCREEN_CENTER_X, SCREEN_CENTER_Y-224 ):zoomto( SCREEN_WIDTH-40, 120 )
            :diffuse( ColorDarkTone(Color.Blue) )
        end,
    },
    
    Def.Sprite{
        Condition=#img_cache > 0,
        Name="CurImage",
        InitCommand=function(s) s:Load( img_cache[curitem][2] )end,
        OnCommand=function(s)
            s:xy( 38, 136 ):halign(0):setsize(96,96)
        end,
    },

    Def.BitmapText{
        Condition=#img_cache > 0,
        Name="CurText",
        Font="Common Normal",
        InitCommand=function(s) s:settext( string.gsub( img_cache[curitem][1], ".(^)", "" ) ) end,
        OnCommand=function(s) s:xy( 50+96, 136 ):halign(0) end,
    }
}

t[#t+1] = Def.BitmapText{
    Condition=#img_cache < 1,
    Name="CurText",
    Font="Common Normal",
    Text="There are no avatars loaded on your Appearance folder.\nGo to Appearance/Avatars and drop some images in.",
    OnCommand=function(s) s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y) end,
}

local ChangeInput = function(offset)
    curitem = curitem + offset
    if curitem < 1 then curitem = 1 end
    if curitem > #img_cache then curitem = #img_cache end
    MESSAGEMAN:Broadcast("ChangeItems",{item=curitem})
    MESSAGEMAN:Broadcast("ScrollGrid",{tileoffset=curitem > maximum_array_size*6 and math.floor( (curitem-1)/maximum_array_size) or 5 })
end

local Inputs = {
    ["MenuLeft"] = function() ChangeInput(-1) end,
    ["MenuDown"] = function() ChangeInput(maximum_array_size) end,
    ["MenuUp"] = function() ChangeInput(-maximum_array_size) end,
    ["MenuRight"] = function() ChangeInput(1) end,
    ["Start"] = function()
        if #img_cache > 0 then
            LoadModule("Config.Save.lua")( "AvatarImage", img_cache[curitem][2], profile_location )
        end
        SCREENMAN:PlayStartSound()
        SCREENMAN:GetTopScreen():StartTransitioningScreen( "SM_GoToNextScreen", 0 )
    end,
    ["Back"] = function()
        SCREENMAN:GetTopScreen():StartTransitioningScreen( "SM_GoToPrevScreen", 0 )
    end,
}

local Controller = function(event)
    if event.type == "InputEventType_FirstPress" then
        if Inputs[event.GameButton] then
            Inputs[event.GameButton]()
        end
    end
end

t.OnCommand=function(s)
    SCREENMAN:GetTopScreen():AddInputCallback( Controller )
end

return t