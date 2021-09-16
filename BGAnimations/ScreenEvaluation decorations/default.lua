local promode = PREFSMAN:GetPreference("AllowW1") == 'AllowW1_Everywhere';
local CurPrefTiming = LoadModule("Config.Load.lua")("SmartTimings","Save/Infinitesimal.ini")

local t = Def.ActorFrame {

	Def.Sprite {
		Texture=THEME:GetPathG("", promode and "EvalElements/ProCenterColumn" or "EvalElements/CenterColumn"),
		InitCommand=function(self)
			self:diffusealpha(0)
			:zoomy(0)
			:zoomx(0.83)
			:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y)
		end,
		OnCommand=function(self)
			self:sleep(1)
			:diffusealpha(1)
			:decelerate(0.3)
			:zoomy(0.83)
		end
	},

	LoadActor(THEME:GetPathG("","ScreenHudFrame")),

	--- ------------------------------------------------
	--- Text/Song Info
	--- ------------------------------------------------

	Def.Sprite {
		Texture=THEME:GetPathG("","EvalElements/EvalSongTitle"),
		InitCommand=function(self)
			self:diffusealpha(0)
			:zoom(0.65, 0)
			:xy(SCREEN_CENTER_X, SCREEN_TOP+(promode and 85 or 90))
		end,
		OnCommand=function(self)
			self:sleep(1)
			:decelerate(0.3)
			:diffusealpha(1)
			:zoomy(0.65)
		end
	},

	LoadFont("Montserrat semibold 20px")..{
		InitCommand=function(self)
			local song = GAMESTATE:GetCurrentSong()

			self:diffusealpha(0)
			:sleep(1.75)
			:horizalign(center)
			:settext(song:GetDisplayMainTitle())
			:maxwidth(400)
			:xy(SCREEN_CENTER_X, (promode and 75 or 80)):zoom(0.7)

			if song:GetDisplaySubTitle() ~= "" then
				self:addy(-2)
			end

			self:decelerate(0.25):diffuse(0,0,0,1)
		end
	},

	LoadFont("Montserrat normal 20px")..{
		InitCommand=function(self)
			local song = GAMESTATE:GetCurrentSong()

			self:diffusealpha(0)
			:sleep(1.75)
			:horizalign(center)
			:maxwidth(400)
			:x(SCREEN_CENTER_X):y(promode and 82 or 87):zoom(0.35)

			if song:GetDisplaySubTitle() then
				self:settext(song:GetDisplaySubTitle())
				:decelerate(0.25):diffuse(0,0,0,1)
			else
				self:settext("")
			end
		end
	},

	LoadFont("Montserrat normal 20px")..{
		InitCommand=function(self)
			local song = GAMESTATE:GetCurrentSong()

			self:diffusealpha(0)
			:sleep(1.75)
			:horizalign(center)
			:settext(song:GetDisplayArtist())
			:maxwidth(700)
			:xy(SCREEN_CENTER_X, (promode and 88 or 93)):zoom(0.6)

			if song:GetDisplaySubTitle() ~= "" then
				self:addy(2)
			end

			self:decelerate(0.25):diffuse(0,0,0,1)
		end
	}
}

--- ------------------------------------------------
--- Judgement counts, score, step artist, etc
--- ------------------------------------------------

for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
    t[#t+1] = LoadActor("PlayerNumbers", pn)..{
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X,138)
        end
    }
end

--local column = GAMESTATE:GetCurrentStyle():GetColumnInfo( GAMESTATE:GetMasterPlayerNumber(), 2 )
for _,v in pairs(NOTESKIN:GetNoteSkinNames()) do
	-- GetCurrentStyle returns nil whenever the screen is first initialized. If you want support for
	-- other gamemodes than Pump with different arrows, uncomment the line above and replace "UpLeft" with column["Name"]
	t[#t+1] = NOTESKIN:LoadActorForNoteSkin( "UpLeft" , "Tap Note", v )..{
		Name="NS"..string.lower(v), InitCommand=function(s) s:visible(false) end,
		OnCommand=function(s) s:diffusealpha(0):sleep(0.2):linear(0.2):diffusealpha(1) end
	}
end

t[#t+1] = LoadActor(THEME:GetPathG("","ModDisplay"))

--- --------------------------
--- Top Left Text
--- --------------------------

-- Text
t[#t+1] = LoadFont("Montserrat Semibold 40px")..{
	InitCommand=function(self)
		if GetScreenAspectRatio() >= 1.5 then
			self:x(SCREEN_CENTER_X-250)
		else
			self:x(SCREEN_CENTER_X-220)
		end

		self:zoom(0.4)
		:shadowcolor(0,0,0,0.25)
		:shadowlength(0.75)
		:diffuse(0,0,0,1)
		:y(SCREEN_TOP-150)
		:settext("DANCE")
	end,
	OnCommand=function(self)
		self:decelerate(1)
		:y(SCREEN_TOP+26)
	end
}

t[#t+1] = LoadFont("Montserrat normal 40px")..{
	InitCommand=function(self)
		if GetScreenAspectRatio() >= 1.5 then
			self:x(SCREEN_CENTER_X-190)
		else
			self:x(SCREEN_CENTER_X-160)
		end

		self:zoom(0.4)
		:shadowcolor(0,0,0,0.25)
		:shadowlength(0.75)
		:diffuse(0,0,0,1)
		:y(SCREEN_TOP-150)
		:settext("GRADE")
	end,
	OnCommand=function(self)
		self:decelerate(1)
		:y(SCREEN_TOP+26)
	end
}

--- --------------
--- Touch Elements
--- --------------

local TouchElements = LoadModule("Config.Load.lua")("UseTouchElements","Save/Infinitesimal.ini")
if TouchElements then
	t[#t+1] = LoadActor("TouchElements")
end

return t


