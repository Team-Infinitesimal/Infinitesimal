local Star = {}
local StarCount = 200
local CenterX = SCREEN_WIDTH / 2
local CenterY = SCREEN_HEIGHT / 2
local NewX, NewY, Scale
local PosZMin = -100
local PosZMax = 800
local Size = 1
local Time = 0
local OldTime = 0

-- Do pixel corrections for higher resolutions, or else
-- our starfield will look very small and nearly invisible
local DisplayHeight = PREFSMAN:GetPreference("DisplayHeight")
if DisplayHeight > 720 then
    Size = DisplayHeight / 720
end

local function UpdateStars(self)
    Time = self:GetSecsIntoEffect()
    if not PREFSMAN:GetPreference("Vsync") and Time - OldTime < 1/60 then
        return
    else
        OldTime = Time
        
        if not SCREENMAN:GetTopScreen():IsPaused() then
            -- Randomize the origin of the stars
            if math.random(2) == 2 then
                if math.random(2) == 2 then
                    CenterX = CenterX + 1
                else CenterX = CenterX - 1 end
                if math.random(2) == 2 then
                    CenterY = CenterY + 1
                else CenterY = CenterY - 1 end
            end
            
            -- Skip 1 because it is the black background
            for i=2, StarCount do
                -- Move things around
                Star[i][1]["CurZ"] = Star[i][1]["CurZ"] - 5
                Scale = (-PosZMin * 100) / (Star[i][1]["CurZ"] - PosZMin)
                NewX = CenterX + Star[i][1]["PosX"] * Scale / 100
                NewY = CenterY + Star[i][1]["PosY"] * Scale / 100
                
                -- If the star has gone past the screen, flag it as too far ahead
                if NewX < 0 and NewX > SCREEN_WIDTH and NewY < 0 and NewY > SCREEN_WIDTH then
                    Star[i][1]["CurZ"] = -20 
                end
            
                -- If the star is too far ahead, regenerate it
                if Star[i][1]["CurZ"] < -10 then
                    Star[i] = { 
                        {
                            ["PosX"] = math.random(SCREEN_WIDTH * 1.25) - SCREEN_WIDTH * 0.625, 
                            ["PosY"] = math.random(SCREEN_HEIGHT * 1.25) - SCREEN_HEIGHT * 0.625, 
                            ["CurZ"] = 100 + math.random(PosZMax - 100), 
                            ["Type"] = math.random(6), 
                            ["Color"] = color(math.random() .. "," .. math.random() .. "," .. math.random() .. ",1")
                        }
                    }
                    
                    if Star[i][1]["Type"] == 1 then
                        self:GetChild("")[i]:zoom(Size * 2)
                                            :rotationz(45)
                    else
                        self:GetChild("")[i]:zoom(Size)
                                            :rotationz(0)
                    end
                end
                
                -- Update the position and color of the star
                if Star[i][1]["CurZ"] > -10 then
                    self:GetChild("")[i]:xy(NewX, NewY)
                    :diffuse(color(math.random() .. "," .. math.random() .. "," .. math.random() .. ",1"))
                    
                    -- Experimental size increase on approximation
                    --:zoom(((900 - Star[i][1]["CurZ"]) / 400) * Size)
                end
            end
        end
    end
end

local t = Def.ActorFrame {
    InitCommand=function(self)
        self:effectperiod(math.huge)
            :SetUpdateFunction(UpdateStars)
    end,
    
    Def.Quad {
        InitCommand=function(self)
            self:diffuse(Color.Black)
                :FullScreen()
        end
    }
}

-- Skip 1 because it is the black background
for i=2, StarCount do
    Star[i] = { 
        {
            ["PosX"] = math.random(SCREEN_WIDTH * 1.25) - SCREEN_WIDTH * 0.625, 
            ["PosY"] = math.random(SCREEN_HEIGHT * 1.25) - SCREEN_HEIGHT * 0.625, 
            ["CurZ"] = 100 + math.random(PosZMax - 100), 
            ["Type"] = math.random(6), 
            ["Color"] = color(math.random() .. "," .. math.random() .. "," .. math.random() .. ",1")
        }
    }

    t[#t+1] = Def.Quad {
        OnCommand=function(self)
            self:x(CenterX + Star[i][1]["PosX"])
                :y(CenterY + Star[i][1]["PosY"])
                :diffuse(Star[i][1]["Color"])
                :zoom(Size)
                
            if Star[i][1]["Type"] == 1 then
                self:zoom(Size * 2)
                    :rotationz(45)
            end
        end,
    }
end

return t