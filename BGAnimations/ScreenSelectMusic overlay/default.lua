local function getCurStage()
	return string.format("%02d", GAMESTATE:GetCurrentStageIndex() + 1)
end

local t = Def.ActorFrame {

	OnCommand=function(self)
		local player = GAMESTATE:GetMasterPlayerNumber()
		GAMESTATE:UpdateDiscordProfile(GAMESTATE:GetPlayerDisplayName(player))

		if GAMESTATE:IsCourseMode() then
			GAMESTATE:UpdateDiscordScreenInfo("Selecting Course","",1)
		else
			if GAMESTATE:IsEventMode() then
				GAMESTATE:UpdateDiscordScreenInfo("Selecting Song (Event)","",1)
			else
				local StageIndex = GAMESTATE:GetCurrentStageIndex()
				GAMESTATE:UpdateDiscordScreenInfo("Selecting Song (Stage ".. StageIndex+1 .. ")","",1)
			end
		end
	end,

	PlayerJoinedMessageCommand=function(self)
		SOUND:DimMusic(0,65536)
		SCREENMAN:GetTopScreen():SetNextScreenName("ScreenSelectProfile");
		SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen");
	end;

	LoadActor(THEME:GetPathG("","Readies")),
	LoadActor("ScorePanel"),
	LoadActor("ChartInfo"),
	LoadActor("DifficultyBar"),
	LoadActor("SongPreview"),
	LoadActor(THEME:GetPathG("","CornerArrows")),
	LoadActor(THEME:GetPathG("","ModDisplay"))

}

t[#t+1] = LoadActor( THEME:GetPathS("Common","start") )..{
	PlayerJoinedMessageCommand=function(self)
		self:play()
	end;
};

t[#t+1] = LoadActor(THEME:GetPathS("","OpenCommandWindow"))..{
	CodeMessageCommand=function(self, params)
		if params.Name == "OpenOpList" then
			opListPn = params.PlayerNumber
			SCREENMAN:GetTopScreen():OpenOptionsList(opListPn)
			self:play()
		end
	end
}

t[#t+1] = LoadActor(THEME:GetPathS("","CloseCommandWindow"))..{
	OptionsListClosedMessageCommand=function(self)
		self:play()
	end
}

t[#t+1] = LoadActor(THEME:GetPathS("","OpListScroll"))..{
	OptionsListRightMessageCommand=function(self)self:queuecommand("Refresh")end,
	OptionsListLeftMessageCommand=function(self)self:queuecommand("Refresh")end,
	OptionsListQuickChangeMessageCommand=function(self)self:queuecommand("Refresh")end,
	RefreshCommand=function(self)
		self:play()
	end
}

t[#t+1] = LoadActor(THEME:GetPathS("","OpListChoose"))..{
	OptionsListStartMessageCommand=function(self)self:queuecommand("Refresh")end,
	OptionsListResetMessageCommand=function(self)self:queuecommand("Refresh")end,
	OptionsListPopMessageCommand=function(self)self:queuecommand("Refresh")end,
	OptionsListPushMessageCommand=function(self)self:queuecommand("Refresh")end,
	RefreshCommand=function(self)
		self:play()
	end
}

-- Command Window
-- Text inside window offset is inside metrics.ini
-- OptionsListP1OnCommand and OptionsListP2OnCommand
for pn in ivalues(PlayerNumber) do
	t[#t+1] = LoadActor(THEME:GetPathG("","OpList")) ..{
		InitCommand=function(self,params)
			self:draworder(135):zoom(0.5)
			:y(SCREEN_CENTER_Y)
			self:x( pn == PLAYER_1 and -135 or SCREEN_RIGHT+135 )
		end,
		OptionsListOpenedMessageCommand=function(self,params)
			if params.Player == pn then
				self:playcommand("Slide",{Offset=135})
			end
		end,
		OptionsListClosedMessageCommand=function(self,params)
			if params.Player == pn then
				self:playcommand("Slide",{Offset=-135})
			end
		end,
		SlideCommand=function(self,param)
			local offsetmove = param.Offset
			self:decelerate(0.25):x( pn == PLAYER_1 and offsetmove or SCREEN_RIGHT-offsetmove )
		end,
	}
end

t[#t+1] = LoadActor("GroupSelect")

-- Text and Stage Count
t[#t+1] = Def.BitmapText{
	Font="Montserrat Semibold 40px",
	Text="SELECT",
	InitCommand=function(self)
		self:x(SCREEN_CENTER_X - (GetScreenAspectRatio() >= 1.5 and (GetScreenAspectRatio() * 108) + 58 or 190) )
		:zoom(0.4)
		:shadowcolor(0,0,0,0.25)
		:shadowlength(0.75)
		:diffuse(0,0,0,1)
		:y(-135)
	end,
	OnCommand=function(self)
		self:decelerate(1):y(20)
	end
}

t[#t+1] = Def.BitmapText{
	Font="Montserrat normal 40px",
	Text="MUSIC",
	InitCommand=function(self)
		self:x(SCREEN_CENTER_X - (GetScreenAspectRatio() >= 1.5 and (GetScreenAspectRatio() * 108) or 132) )
		:zoom(0.4)
		:shadowcolor(0,0,0,0.25)
		:shadowlength(0.75)
		:diffuse(0,0,0,1)
		:y(-135)
	end,
	OnCommand=function(self)
		self:decelerate(1):y(20)
	end
}

t[#t+1] = Def.BitmapText{
	Font="Montserrat normal 40px",
	InitCommand=function(self)
		self:x(SCREEN_CENTER_X - (GetScreenAspectRatio() >= 1.5 and (GetScreenAspectRatio() * 108) - 28 or 132) )
		:zoom(0.35)
		:shadowcolor(0,0,0,0.25)
		:shadowlength(0.75)
		:halign(1)
		:diffuse(0,0,0,1)
		:y(-125)
		:settext("STAGE "..getCurStage())
	end,
	OnCommand=function(self)
		self:decelerate(1):y(35)
	end
}

local TouchElements = LoadModule("Config.Load.lua")("UseTouchElements","Save/Infinitesimal.ini")
if TouchElements then
	t[#t+1] = LoadActor("TouchElements")
end

local ProfileBubble = LoadModule("Config.Load.lua")("UseProfileBubble","Save/Infinitesimal.ini")
if ProfileBubble and (getCurStage() == "01") then
	for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
		t[#t+1] = LoadActor("ProfileBubble", pn)
	end
end

return t
