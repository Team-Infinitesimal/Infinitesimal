local PreviewX = SCREEN_CENTER_X
local PreviewY = SCREEN_CENTER_Y-70
local PreviewWidth = 340
local PreviewHeight = 191.25

local ShowPreviewVideos = LoadModule("Config.Load.lua")("ShowPreviewVideos","Save/Infinitesimal.ini")

local t = Def.ActorFrame {

	-- Frame
    Def.Sprite {
		Texture=THEME:GetPathG("","PreviewFrame"),
        InitCommand=function(self)
            self:horizalign(center)
            :xy(PreviewX,PreviewY)
            :zoom(0.75)
        end
    },

    Def.Sprite {
		Texture=THEME:GetPathG("","noise"),
		InitCommand=function(self)
            self:xy(PreviewX,PreviewY)
            :zoomto(PreviewWidth,PreviewHeight)
            :texcoordvelocity(24,16)
        end
	},

	Def.Sprite {
		Texture=THEME:GetPathG("","pixelLogo"),
		InitCommand=function(self)
            self:xy(PreviewX,PreviewY)
            :zoomto(PreviewWidth*0.8,PreviewHeight*0.8)
        end
	},

	-- Video display
    Def.Sprite {
        InitCommand=function(self)
            self:xy(PreviewX,PreviewY)
        end,

        CurrentSongChangedMessageCommand=function(self)
            self:stoptweening():diffusealpha(0):sleep(0.4)
            if GAMESTATE:GetCurrentSong() then
        				if GAMESTATE:GetCurrentSong():GetPreviewVidPath() ~= nil and ShowPreviewVideos then
              			self:queuecommand("LoadAnimated")
                else
                    self:queuecommand("LoadBG")
              	end
			      end
        end,

        LoadBGCommand=function(self)
			self:Load(nil)
            local path = GAMESTATE:GetCurrentSong():GetBackgroundPath()
            if path then
				if FILEMAN:DoesFileExist(path) then
					self:Load(path)
				else
					self:Load(THEME:GetPathG("Common","fallback background"))
				end
            else
                self:Load(THEME:GetPathG("Common","fallback background"))
            end
            self:zoomto(PreviewWidth,PreviewHeight):decelerate(0.2):diffusealpha(1)
        end,

        LoadAnimatedCommand=function(self)
        	self:Load(nil) -- an attempt to clear out previous preview to conserve on memory usage
            local path = GAMESTATE:GetCurrentSong():GetPreviewVidPath()
            if path then
				if FILEMAN:DoesFileExist(path) then
					self:Load(path):zoomto(PreviewWidth,PreviewHeight)
					:decelerate(0.2):diffusealpha(1)
				else
					self:queuecommand("LoadBG")
				end
			else
				self:queuecommand("LoadBG")
            end
        end
    },

    -- Top info panel
    Def.Quad {
        InitCommand=function(self)
            self:xy(PreviewX,PreviewY-86)
			:zoomx(PreviewWidth)
			:zoomy(20)
            :diffuse(0,0,0,0.75)
        end
    },

    -- Title
    Def.BitmapText {
		Font="Montserrat semibold 40px",
        InitCommand=function(self)
            self:horizalign(left)
            :xy(PreviewX-(PreviewWidth/2)+4,PreviewY-86.5)
            :zoom(0.35):maxwidth(800)
        end,

        CurrentSongChangedMessageCommand=function(self)
            self:stoptweening():diffusealpha(0)
            local song = GAMESTATE:GetCurrentSong()
            if song then
                self:settext(song:GetDisplayMainTitle()):diffusealpha(1)
            end
        end
    },

    -- Length
    Def.BitmapText {
		Font="Montserrat semibold 40px",
        InitCommand=function(self)
            self:horizalign(right)
            :xy(PreviewX+(PreviewWidth/2)-4,PreviewY-86.5)
            :zoom(0.35):maxwidth(550)
        end,

        CurrentSongChangedMessageCommand=function(self)
            local song = GAMESTATE:GetCurrentSong()
            self:stoptweening():diffusealpha(0)
            if song then
                local lengthseconds = SecondsToMMSS(GAMESTATE:GetCurrentSong():MusicLengthSeconds())
                self:settext(lengthseconds):diffusealpha(1)
            end
        end
    },

    -- Bottom info panel
    Def.Quad {
        InitCommand=function(self)
            self:xy(PreviewX,PreviewY+86)
			:zoomx(PreviewWidth)
			:zoomy(20)
            :diffuse(0,0,0,0.75)
        end
    },

	-- Artist
    Def.BitmapText {
		Font="Montserrat semibold 40px",
        InitCommand=function(self)
            self:horizalign(left)
            :xy(PreviewX-(PreviewWidth/2)+4,PreviewY+85.5)
            :zoom(0.35):maxwidth(650)
        end,

        CurrentSongChangedMessageCommand=function(self)
            self:stoptweening():diffusealpha(0)
            local song = GAMESTATE:GetCurrentSong()
            if song then
                self:settext(song:GetDisplayArtist()):diffusealpha(1)
            end
        end
    },

	-- BPM
	Def.BitmapText {
		Font="Montserrat semibold 40px",
        InitCommand=function(self)
            self:horizalign(right)
            :xy(PreviewX+(PreviewWidth/2)-4,PreviewY+85.5)
            :zoom(0.35):maxwidth(550)
        end,

        CurrentSongChangedMessageCommand=function(self)
            local song = GAMESTATE:GetCurrentSong()
            self:stoptweening():diffusealpha(0)
            if song then
                local speedvalue
				local rawbpm = song:GetDisplayBpms()
				local lobpm = math.ceil(rawbpm[1])
				local hibpm = math.ceil(rawbpm[2])
				if lobpm == hibpm then
					speedvalue = hibpm
				else
					speedvalue = lobpm.."-"..hibpm
				end

				if song:IsDisplayBpmRandom() or speedvalue == 0 then
                    speedvalue = "???"
                end
                self:settext(speedvalue.." BPM"):diffusealpha(1)
            end
        end
    },

	Def.Sprite {
		InitCommand=function(self)
			self:diffusealpha(0):xy(SCREEN_CENTER_X+125,SCREEN_CENTER_Y-125)
		end,
		CurrentSongChangedMessageCommand=function(self)
			self:stoptweening():diffusealpha(0):sleep(0.4)
			if GAMESTATE:GetCurrentSong() then
				if GAMESTATE:GetCurrentSong():GetCDTitlePath() then
					self:Load(GAMESTATE:GetCurrentSong():GetCDTitlePath())
					:scaletofit(0,0,50,50)
					:xy(SCREEN_CENTER_X+125,SCREEN_CENTER_Y-125)
					:decelerate(0.2)
					:diffusealpha(1)
				end
			end
		end
	}
}

return t
