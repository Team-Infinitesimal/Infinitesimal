local Paused = false
-- Global variable because ???
-- Betting old themes use this variable a lot.
course_stopped_by_pause_menu = false
local CurSel = 1

local Choices = {
    {
        Name = "continue_playing",
        Action = function( screen )
            screen:PauseGame(false)
        end
    },
    {
        Name = "restart_song",
        Action = function( screen )
            screen:SetPrevScreenName('ScreenStageInformation'):begin_backing_out()
        end
    },
    {
        Name = "forfeit_song",
        Action = function( screen )
            screen:SetPrevScreenName(SelectMusicOrCourse()):begin_backing_out()
        end
    },
}

if GAMESTATE:IsCourseMode() then
    Choices = {
        {
            Name = "continue_playing",
            Action = function( screen )
                screen:PauseGame(false)
            end
        },
        {
            Name = "skip_song",
            Action = function( screen )
                screen:PostScreenMessage('SM_NotesEnded', 0)
            end
        },
        {
            Name = "forfeit_course",
            Action = function( screen )
                screen:SetPrevScreenName(SelectMusicOrCourse()):begin_backing_out()
            end
        },
        {
            Name = "end_course",
            Action = function( screen )
                course_stopped_by_pause_menu = true
                screen:PostScreenMessage('SM_LeaveGameplay', 0)
            end
        },
    }
end

local Selections = Def.ActorFrame{
    Name="Selections",
    InitCommand=function(self)
        -- As this process is starting, we'll already highlight the first option with the color.
        self:GetChild(1):playcommand("GainFocus")
    end,
    Def.Quad {
                Name="Background",
        InitCommand=function(self)
            self:diffuse(0.1, 0.1, 0.1, 1)
                        :diffusetopedge(0.2, 0.2, 0.2, 1)
                        :zoomto(250, 180)
        end,
    },
        Def.Quad {
                Name="Top",
                InitCommand=function(self)
                        self:valign(1):zoomto(250, 60):y(-90)
                        self:diffuse(color("#ab78f5")):diffusebottomedge(color("#1fbcff"))
                end
        },
        Def.BitmapText {
                Font="Montserrat Extrabold 40px",
                InitCommand=function(self)
                        self:skewx(-0.2):settext("PAUSED")
                        :y(-120)
                end
        }
}

local function ChangeSel(self,offset)
    -- Do not allow cursor to move if we're not in the pause menu.
    if not Paused then return end

    CurSel = CurSel + offset
    if CurSel < 1 then CurSel = 1 end
    if CurSel > #Choices then CurSel = #Choices end

    for i = 1,#Choices do
        self:GetChild("Selections"):GetChild(i):playcommand(i == CurSel and "GainFocus" or "LoseFocus")
    end
end

for i,v in ipairs(Choices) do
    Selections[#Selections+1] = Def.ActorFrame {
        Name=i,
        Def.Quad {
            InitCommand=function(self)
                self:zoomto(190, 30):y(-80+(40*i)):diffuse(Color.Black):diffusealpha(0.25)
                :fadeleft(0.25):faderight(0.25):playcommand("LoseFocus")
            end,
            LoseFocusCommand=function(self) self:diffusealpha(0) end,
            GainFocusCommand=function(self) self:diffusealpha(0.25) end
        },
        Def.BitmapText {
            Font="Montserrat semibold 20px",
            Text=THEME:GetString("PauseMenu", v.Name),
            InitCommand=function(self) self:y(-80+(40*i)):strokecolor(Color.Black):playcommand("LoseFocus") end,
            LoseFocusCommand=function(self) self:diffuse(0.8, 0.8, 0.8, 1) end,
            GainFocusCommand=function(self) self:diffuse(Color.White) end
        }
    }
end

return Def.ActorFrame{
    OnCommand=function(self)
        SCREENMAN:GetTopScreen():AddInputCallback(LoadModule("Lua.InputSystem.lua")(self))
        self:visible(false):xy(SCREEN_CENTER_X, SCREEN_CENTER_Y + 20)
    end,
    ShowPauseWindowCommand=function(self)
        if not Paused then
            SCREENMAN:GetTopScreen():PauseGame(true)
            ChangeSel(self,0)
            self:diffusealpha(0):visible(true)
            self:easeoutquad(0.5):diffusealpha(1):y(SCREEN_CENTER_Y)
        end
        Paused = true
    end,
    NonGameBackCommand=function(self)
        self:playcommand("ShowPauseWindow")
    end,
    SelectCommand=function(self)
        if LoadModule("Config.Load.lua")("UseSelToPause", "Save/OutFoxPrefs.ini") then
            self:playcommand("ShowPauseWindow")
        end
    end,
    StartCommand=function(self)
        if Paused then
            Choices[CurSel].Action( SCREENMAN:GetTopScreen() )
            self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y + 20):visible(false)
        end
        Paused = false
    end,
    MenuLeftCommand=function(self) if Paused then ChangeSel(self,-1) end end,
    MenuRightCommand=function(self) if Paused then ChangeSel(self,1) end end,
    MenuUpCommand=function(self) if Paused then ChangeSel(self,-1) end end,
    MenuDownCommand=function(self) if Paused then ChangeSel(self,1) end end,
    Selections
}
