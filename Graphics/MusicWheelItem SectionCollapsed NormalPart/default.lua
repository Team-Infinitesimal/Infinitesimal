local t = Def.ActorFrame{
	Def.Banner{
    InitCommand=function(self)
      self:scaletoclipped(288,162)
    end;
		SetMessageCommand=function(self,params)
			local group = params.Text;
			if group then
				self:Load(SONGMAN:GetSongGroupBannerPath(group));
			else
				self:Load( THEME:GetPathG("","GroupBannerFallback") );
			end;
		end;
	};
};

return t;
