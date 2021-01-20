return Def.ActorFrame {
	OnCommand=function(self)self:diffusealpha(1):zoom(1)end;
	PlayerJoinedMessageCommand=function(self)self:playcommand("On")end;

	-- banners
	Def.Banner {
		Name="SongBanner";
		InitCommand=cmd(diffusealpha,1);
		SetMessageCommand=function(self,params)
			self:stoptweening();
			if not path then path = THEME:GetPathG("Common","fallback songbanner") end
			self:LoadFromCachedBanner(THEME:GetPathG("","RandomBanner"));
			self:scaletoclipped(300,168);
		end;
	};
	
	LoadActor(THEME:GetPathG("","SongFrame"))..{
		InitCommand=function(self)
			self:zoom(1.35):diffusealpha(1);
		end;
	};
};
