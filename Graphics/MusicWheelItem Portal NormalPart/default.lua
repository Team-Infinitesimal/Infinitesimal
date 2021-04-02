local function getFrameForMode()
	if LoadModule("Config.Load.lua")("ProMode",CheckIfUserOrMachineProfile(string.sub(GAMESTATE:GetMasterPlayerNumber(),-1)-1).."/Infinitesimal.ini") == "AllowW1_Everywhere" then
		return THEME:GetPathG("", "SongFrames/ProSongFrame")
	else
		return THEME:GetPathG("", "SongFrames/ArcadeSongFrame")
	end
end

return Def.ActorFrame {
	OnCommand=function(self)self:diffusealpha(1):zoom(1)end,
	PlayerJoinedMessageCommand=function(self)self:playcommand("On")end,

	-- banners
	Def.Banner {
		Name="SongBanner";
		InitCommand=function(self)
			self:diffusealpha(1)
		end,
		SetMessageCommand=function(self,params)
			self:stoptweening()
			if not path then path = THEME:GetPathG("Common","fallback songbanner") end
			self:LoadFromCachedBanner(THEME:GetPathG("","RandomBanner"))
			self:scaletoclipped(294,162)
		end
	},

	Def.Sprite {
		Texture=getFrameForMode(),
		InitCommand=function(self)
			self:zoom(1.35):diffusealpha(1)
		end,

		OptionsListStartMessageCommand=function(self)self:queuecommand("Refresh")end,
		OptionsListResetMessageCommand=function(self)self:queuecommand("Refresh")end,
		OptionsListPopMessageCommand=function(self)self:queuecommand("Refresh")end,
		OptionsListPushMessageCommand=function(self)self:queuecommand("Refresh")end,

		RefreshCommand=function(self)
			self:Load(getFrameForMode())
		end
	}
}
