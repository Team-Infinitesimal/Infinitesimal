local FrameW = 640
local FrameH = 360

local PreviewDelay = THEME:GetMetric("ScreenSelectMusic", "SampleMusicDelay")
local DisplayNotefield = false

-- Video/background display
local t = Def.ActorFrame {
    OnCommand=function(self)
        self:zoom(0.8)
    end,

    Def.Sprite {
        Texture=((_G["Secret"] == true) and THEME:GetPathG("", "MusicWheel/SecretPreviewFrame") or THEME:GetPathG("", "MusicWheel/PreviewFrame"))
    },

    Def.Sprite {
		Texture=THEME:GetPathG("", "Noise"),
		InitCommand=function(self)
            self:zoomto(FrameW, FrameH)
            :texcoordvelocity(24,16)
        end
	},

    Def.Sprite {
        InitCommand=function(self) self:Load(nil):queuecommand("Refresh") end,
        CurrentSongChangedMessageCommand=function(self) self:Load(nil):queuecommand("Refresh") end,

        RefreshCommand=function(self)
            self:stoptweening():diffusealpha(0):sleep(PreviewDelay)
            Song = GAMESTATE:GetCurrentSong()
            if Song then
        				if GAMESTATE:GetCurrentSong():GetPreviewVidPath() == nil or
        				LoadModule("Config.Load.lua")("ImagePreviewOnly", "Save/OutFoxPrefs.ini") then
      				      self:queuecommand("LoadBG")
                else
                    self:queuecommand("LoadAnimated")
      			    end
			      end
        end,

        LoadBGCommand=function(self)
            local Path = Song:GetBackgroundPath()
            if Path and FILEMAN:DoesFileExist(Path) then
				        self:Load(Path):zoomto(FrameW, FrameH)
				        :linear(PreviewDelay):diffusealpha(1)
            else
                self:Load(Song:GetBannerPath()):zoomto(FrameW, FrameH)
                :linear(PreviewDelay):diffusealpha(1)
            end
        end,

        LoadAnimatedCommand=function(self)
            local Path = Song:GetPreviewVidPath()
            if Path and FILEMAN:DoesFileExist(Path) then
				self:Load(Path):zoomto(FrameW, FrameH)
				:linear(PreviewDelay):diffusealpha(1)
			else
				self:queuecommand("LoadBG")
            end
        end
    }
}

-- Chart preview WIP, use at your own risk!
if LoadModule("Config.Load.lua")("ChartPreview", "Save/OutFoxPrefs.ini") then
    t[#t+1] = Def.ActorFrame {
        InitCommand=function(self)
            self:y(75):zoom(0.75)
        end,
        OnCommand=function(self)
            if GAMESTATE:GetCurrentSong() then
                self:AddChildFromPath(THEME:GetPathB("", "NotefieldPreview"))
            end
        end,
        Def.Quad {
            InitCommand=function(self)
                self:y(-100):zoomto(854, 480):diffuse(Color.Black):diffusealpha(0.5):visible(false)
            end,
            SongChosenMessageCommand=function(self) self:visible(true) end,
            SongUnchosenMessageCommand=function(self) self:visible(false) end,
        }
    }
end

-- Portion dedicated to song stats
t[#t+1] = Def.ActorFrame {
    InitCommand=function(self) self:playcommand("Refresh") end,
    CurrentSongChangedMessageCommand=function(self) self:playcommand("Refresh") end,

    RefreshCommand=function(self)
        if GAMESTATE:GetCurrentSong() then
            local Song = GAMESTATE:GetCurrentSong()

            local TitleText = Song:GetDisplayFullTitle()
            if TitleText == "" then TitleText = "Unknown" end

            local AuthorText = Song:GetDisplayArtist()
            if AuthorText == "" then AuthorText = "Unknown" end

            local BPMRaw = Song:GetDisplayBpms()
            local BPMLow = math.ceil(BPMRaw[1])
            local BPMHigh = math.ceil(BPMRaw[2])
            local BPMDisplay = (BPMLow == BPMHigh and BPMHigh or BPMLow .. "-" .. BPMHigh)

            if Song:IsDisplayBpmRandom() or BPMDisplay == 0 then BPMDisplay = "???" end

            self:GetChild("Title"):settext(TitleText)
            self:GetChild("Artist"):settext(AuthorText)
            self:GetChild("Length"):settext(SecondsToMMSS(Song:MusicLengthSeconds()))
            self:GetChild("BPM"):settext(BPMDisplay .. " BPM")
        else
            self:GetChild("Title"):settext("")
            self:GetChild("Artist"):settext("")
            self:GetChild("Length"):settext("")
            self:GetChild("BPM"):settext("")
        end
    end,

    Def.Quad {
        InitCommand=function(self)
            self:zoomto(FrameW, 32):y(-FrameH / 2):valign(0)
            :diffuse(Color.Black):diffusealpha(0.5)
        end
    },

    Def.BitmapText {
        Font="Montserrat semibold 40px",
        Name="Title",
        InitCommand=function(self)
            self:zoom(0.7):halign(0):valign(0)
            :maxwidth(FrameW * 0.8 / self:GetZoom())
            :x(-FrameW / 2 + 6)
            :y(-FrameH / 2 + 6)
        end
    },

    Def.BitmapText {
        Font="Montserrat semibold 40px",
        Name="Length",
        InitCommand=function(self)
            self:zoom(0.7):halign(1):valign(0)
            :maxwidth(FrameW * 0.2 / self:GetZoom())
            :x(FrameW / 2 - 6)
            :y(-FrameH / 2 + 6)
        end
    },

    Def.Quad {
        InitCommand=function(self)
            self:zoomto(FrameW, 32):y(FrameH / 2):valign(1)
            :diffuse(Color.Black):diffusealpha(0.5)
        end
    },

    Def.BitmapText {
        Font="Montserrat semibold 40px",
        Name="Artist",
        InitCommand=function(self)
            self:zoom(0.7):halign(0):valign(1)
            :maxwidth(FrameW * 0.7 / self:GetZoom())
            :x(-FrameW / 2 + 6)
            :y(FrameH / 2 - 6)
        end
    },

    Def.BitmapText {
        Font="Montserrat semibold 40px",
        Name="BPM",
        InitCommand=function(self)
            self:zoom(0.7):halign(1):valign(1)
            :maxwidth(FrameW * 0.3 / self:GetZoom())
            :x(FrameW / 2 - 6)
            :y(FrameH / 2 - 6)
        end
    }
}

return t
