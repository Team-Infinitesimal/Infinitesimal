

local function PlayerInfo(pn)
local t = Def.ActorFrame {

	--[[LoadFont("_open sans Bold 24px")..{
	InitCommand=cmd(diffusealpha,1;y,-40;horizalign,center;zoom,0.8;maxwidth,46/0.8;);
	OnCommand=cmd(settext,ProfileName(pn););
	};]]





	LoadFont("venacti/_venacti 26px bold diffuse") .. {
				BeginCommand=cmd(maxwidth,320;draworder,110;horizalign,right;x,SCREEN_CENTER_X-130;y,SCREEN_BOTTOM-10;zoom,0.4;shadowlength,1;uppercase,true;queuecommand,"Set");
				OnCommand=cmd(queuecommand,"Set");
				PlayerJoinedMessageCommand=cmd(queuecommand,"Set");
				PlayerUnjoinedMessageCommand=cmd(queuecommand,"Set");
				SetCommand=function(self)
					local profile = PROFILEMAN:GetProfile(PLAYER_1);
					local name = profile:GetDisplayName();
					
					if GAMESTATE:IsHumanPlayer(PLAYER_1) == true then
						if name=="" then
							self:settext("NO NAME");
						else
							self:settext( name );
						end
					end	
				end;

			};
	
	
	
	LoadFont("venacti/_venacti 26px bold diffuse") .. {
				InitCommand=cmd(maxwidth,320;draworder,110;horizalign,left;x,SCREEN_CENTER_X+130;y,SCREEN_BOTTOM-10;zoom,0.4;shadowlength,1;uppercase,true;queuecommand,"Set");
				OnCommand=cmd(queuecommand,"Set");
				PlayerJoinedMessageCommand=cmd(queuecommand,"Set");
				PlayerUnjoinedMessageCommand=cmd(queuecommand,"Set");
				SetCommand=function(self)
					local profile = PROFILEMAN:GetProfile(PLAYER_2);
					local name = profile:GetDisplayName();
					
					if GAMESTATE:IsHumanPlayer(PLAYER_2) == true then
						if name=="" then
							self:settext("NO NAME");
						else
							self:settext( name );
						end
					end
				end;

};



};
return t
end;




local function customlifemeterS(pn)
	local t = Def.ActorFrame {
		LoadActor("mask") .. {
			BeginCommand=cmd(x,-270-38;MaskSource);
		};	
		LoadActor("LifeMeterBar backgroundS") .. {
			BeginCommand=cmd(diffusealpha,0.75;zoomx,1.01;);
			--OnCommand=cmd(diffusealpha,0.75);
			["LifeMeterChanged"..pname(pn).."MessageCommand"]=function(self,params)
				local dgthreshold = 0.2
				if params.Life > dgthreshold then
					self:visible(true);
				else
					self:visible(false);
				end
			end;
		};
		LoadActor("bar dangerS") .. {
			OnCommand=cmd(diffuseshift;effectperiod,0.3;effectcolor1,color("#FFFFFF");effectcolor2,color("#aeaeae");diffusealpha,0.9;visible,false);
			["LifeMeterChanged"..pname(pn).."MessageCommand"]=function(self,params)
				local dgthreshold = 0.2
				if params.Life < dgthreshold then
					self:visible(true);
				else
					self:visible(false);
				end
			end;
		};
		--pulse_
		LoadActor("pulse") .. {
			BeginCommand=cmd(zoomto,40,40;blend,Blend.Add;diffuseshift;effectcolor1,1,1,1,1;effectcolor2,1,1,1,0;effectclock,"bgm";effecttiming,1,0,0,0;MaskDest);
			["LifeMeterChanged"..pname(pn).."MessageCommand"]=function(self,params)
				local xpos = params.Life*500;
					if xpos <= 4 then
					xpos = 4
					elseif xpos >= 498 then
					xpos = 498 end
						self:x(xpos-250-20);
			end;
		};

		LoadActor("PLS2") .. {
			BeginCommand=cmd(zoomto,40,40;MaskDest;playcommand,"Change";);
			InitCommand=cmd(glowshift;effectperiod,0.6;effectcolor1,1,1,1,0;effectcolor2,1,1,1,1;);
			OnCommand=cmd(bounce;effectmagnitude,-40,0,0;effectclock,"bgm";effecttiming,1,0,0,0;);
			["LifeMeterChanged"..pname(pn).."MessageCommand"]=function(self,params)
				local xpos = params.Life*500;
					if xpos <= 4 then
					xpos = 4
					elseif xpos >= 498 then
					xpos = 498 end
						self:x(xpos-250-20);
			end;
		};

		LoadActor("SOLIDO SINGLE") .. {
			BeginCommand=cmd(player,pn;playcommand,"Change";ztest,true);--20
			["LifeMeterChanged"..pname(pn).."MessageCommand"]=function(self,params)
				local hothreshold = 1.2--1.2
				self:cropright(1.07-params.Life);--1
			end;
		};	
		--brillo
		LoadActor("bar hot s") .. {
			BeginCommand=cmd(draworder,5;x,0;visible,false;customtexturerect,0,0,.5,1;texcoordvelocity,0.7,0;);
			["LifeMeterChanged"..pname(pn).."MessageCommand"]=function(self,params)
				local hothreshold = THEME:GetMetric("LifeMeterBar", "HotValue");
				--self:croprigth(1-lfzoom);
				if params.Life >= hothreshold then
					self:visible(true);
					self:glowblink();
					self:effectperiod(0.05);
					self:effectcolor1(1,1,1,0);
					self:effectcolor2(1,1,1,.8);
				else
					self:stopeffect();
					self:visible(false);	
				 end;
			end;
		};

		 --frame
		LoadActor("life bar single");

		LoadActor("tip hot") .. {
			BeginCommand=cmd(player,pn;draworder,5;);
			["LifeMeterChanged"..pname(pn).."MessageCommand"]=function(self,params)
				local dgthreshold = THEME:GetMetric("LifeMeterBar", "DangerThreshold");
				if params.Life <= dgthreshold then
					self:visible(false);
				else
					self:visible(true);
				end
				local xpos = params.Life*500;
				if xpos <= 4 then
					xpos = 4
				elseif xpos >= 498 then
					xpos = 498 
				end
				self:x(xpos-250);
				
				--self:glow(1,1,1,1);
				--[[
				self:glow(0,0,0,1);
				self:glowshift();
				self:effectperiod(0.2);
				self:effectcolor1(1,1,1,0);
				self:effectcolor2(1,1,1,1);
				]]
			end;
		};
		LoadActor("tip danger") .. {
			BeginCommand=cmd(player,pn;draworder,5;visible,false);
			["LifeMeterChanged"..pname(pn).."MessageCommand"]=function(self,params)
				local dgthreshold = THEME:GetMetric("LifeMeterBar", "DangerThreshold");
				self:glow(0,0,0,1);
				if params.Life <= dgthreshold then
					self:visible(true);
				else
					self:visible(false);
				end
				local xpos = params.Life*500;
					if xpos <= 4 then
					xpos = 4
					elseif xpos >= 498 then
					xpos = 498 end
						self:x(xpos-250);
						self:glowshift();
						self:effectperiod(0.1);
						self:effectcolor1(1,1,1,0);
						self:effectcolor2(1,1,1,1);
			end;
		};
	};
	return t
end;

--###############################################################################################################################################################

local function customlifemeterD(pn)
	local t = Def.ActorFrame {
		LoadActor("mask") .. {
			BeginCommand=cmd(x,-519-42;zoomx,1.2;MaskSource;);
		};	
		 LoadActor("LifeMeterBar backgroundD") .. {
			BeginCommand=cmd(diffusealpha,0.75;player,pn;);
			--OnCommand=cmd(diffusealpha,0.75;);
			["LifeMeterChanged"..pname(pn).."MessageCommand"]=function(self,params)
				local life = params.Life
				local dgthreshold = 0.2
				if life > dgthreshold then
					self:visible(true);
				else
					self:visible(false);
				end
			end;
		};
		LoadActor("bar dangerD") .. {
			OnCommand=cmd(diffuseshift;effectperiod,0.3;effectcolor1,color("#FFFFFF");effectcolor2,color("#aeaeae");diffusealpha,0.9;visible,false);
			["LifeMeterChanged"..pname(pn).."MessageCommand"]=function(self,params)
				local life = params.Life
				local dgthreshold = 0.2
				if life <= dgthreshold then
					self:visible(true);
				else
					self:visible(false);
				end;
			end;
		};	--pulse_
		--[[LoadActor("BLUEPLS") .. {
		BeginCommand=cmd(zoomto,80,40;MaskDest;playcommand,"Change";);
			InitCommand=cmd(glowshift;effectperiod,0.6;effectcolor1,1,1,1,0.3;effectcolor2,1,1,1,0.9;);
			OnCommand=cmd(effectclock,"bgm";effecttiming,1,0,0,0;);
			["LifeMeterChanged"..pname(pn).."MessageCommand"]=function(self,params)
				local life = params.Life;
				local xpos = life*1000;
					if xpos <= 4 then
					xpos = 4
					elseif xpos >= 998 then
					xpos = 998 end
						self:x(xpos-500-40);
			end;
		};]]
		LoadActor("pulse") .. {
			BeginCommand=cmd(zoomto,40,40;blend,Blend.Add;diffuseshift;effectcolor1,1,1,1,1;effectcolor2,1,1,1,0;effectclock,"bgm";effecttiming,1,0,0,0;MaskDest);
			["LifeMeterChanged"..pname(pn).."MessageCommand"]=function(self,params)
				local xpos = params.Life*1000;
					if xpos <= 4 then
					xpos = 4
					elseif xpos >= 998 then
					xpos = 998 end
						self:x(xpos-500-20);
			end;
		};
		
		LoadActor("XDD2") .. {
		BeginCommand=cmd(zoomto,80,40;MaskDest;playcommand,"Change";);
			InitCommand=cmd(glowshift;effectperiod,0.6;effectcolor1,1,1,1,0.3;effectcolor2,1,1,1,0.9;);
			OnCommand=cmd(bounce;effectmagnitude,-40,0,0;effectclock,"bgm";effecttiming,1,0,0,0;);
			["LifeMeterChanged"..pname(pn).."MessageCommand"]=function(self,params)
				local life = params.Life;
				local xpos = life*1000;
					if xpos <= 4 then
					xpos = 4
					elseif xpos >= 998 then
					xpos = 998 end
						self:x(xpos-500-40);
			end;
		};





		LoadActor("SOLIDO DOUBLE") .. {
			BeginCommand=cmd(player,pn;playcommand,"Change";x,-8;ztest,true);--20
			["LifeMeterChanged"..pname(pn).."MessageCommand"]=function(self,params)
				local lfzoom = params.Life;
				local hothreshold = 1.2--1.2
				self:cropright(1.04-lfzoom);--1
			end;
		};
		--brillo
		LoadActor("bar hot s") .. {
			--customtexturerect( float fLeft, float fTop, float fRight, float fBottom )
			BeginCommand=cmd(draworder,5;x,0;visible,false;customtexturerect,0,0,.5,1;zoomx,2;texcoordvelocity,0.7,0;);
			["LifeMeterChanged"..pname(pn).."MessageCommand"]=function(self,params)
				local hothreshold = THEME:GetMetric("LifeMeterBar", "HotValue");
				--self:croprigth(1-lfzoom);
				if params.Life >= hothreshold then
					self:visible(true);
					self:glowblink();
					self:effectperiod(0.05);
					self:effectcolor1(1,1,1,0);
					self:effectcolor2(1,1,1,.8);
				else
					self:stopeffect();
					self:visible(false);	
				 end;
			end;
		};
		--frame
		LoadActor("life bar double");

		LoadActor("tip hot") .. {
			BeginCommand=cmd(player,pn;draworder,5;playcommand,"Xposition";);
			["LifeMeterChanged"..pname(pn).."MessageCommand"]=function(self,params)
				local life = params.Life;
				local dgthreshold = THEME:GetMetric("LifeMeterBar", "DangerThreshold");
				self:glow(0,0,0,1);
				if life <= dgthreshold then
					self:visible(false);
				else
					self:visible(true);
				end
				local xpos = life*1000;
					if xpos <= 4 then
					xpos = 4
					elseif xpos >= 994 then
					xpos = 994 end
						self:x(xpos-500);
						self:glowshift();
						self:effectperiod(0.2);
						self:effectcolor1(1,1,1,0);
						self:effectcolor2(1,1,1,1);
			end;
		};
		LoadActor("tip danger") .. {
			BeginCommand=cmd(player,pn;draworder,5;visible,false);
			["LifeMeterChanged"..pname(pn).."MessageCommand"]=function(self,params)
				local life = params.Life
				local dgthreshold = THEME:GetMetric("LifeMeterBar", "DangerThreshold");
				self:glow(0,0,0,1);
				if life <= dgthreshold then
					self:visible(true);
				else
					self:visible(false);
				end
				local xpos = life*1000;
					if xpos <= 4 then
					xpos = 4
					elseif xpos >= 994 then
					xpos = 994 end
						self:x(xpos-500);
						self:glowshift();
						self:effectperiod(0.1);
						self:effectcolor1(1,1,1,0);
						self:effectcolor2(1,1,1,1);
			end;
		};
	};
	return t
end;

--###############################################################################################################################################################



local t = Def.ActorFrame {

	customlifemeterS(PLAYER_1) .. {
		InitCommand=cmd(y,SCREEN_TOP+18;zoomy,0.8*0.66;zoomx,(340/384)*0.85*0.66;playcommand,"On";);
		OnCommand=function(self)
		local style=GAMESTATE:GetCurrentStyle();
			if GAMESTATE:IsHumanPlayer(PLAYER_1) then
				if style:GetStyleType() == "StyleType_OnePlayerTwoSides" then
					self:visible(false);
				elseif style:GetStyleType() == "StyleType_TwoPlayersSharedSides" then
					self:visible(false);
				else
					self:visible(true);
				end
			else
				self:visible(false);
			end
			self:x(THEME:GetMetric(Var "LoadingScreen","PlayerP1OnePlayerOneSideX"));
		end;
	};

	customlifemeterS(PLAYER_2) .. {
		InitCommand=cmd(y,SCREEN_TOP+18;zoomy,0.8*0.66;zoomx,(340/384)*0.85*0.66;rotationy,180;playcommand,"On";);
		OnCommand=function(self)
		local style=GAMESTATE:GetCurrentStyle();
			if GAMESTATE:IsHumanPlayer(PLAYER_2) then
				if style:GetStyleType() == "StyleType_OnePlayerTwoSides" then
					self:visible(false);
				elseif style:GetStyleType() == "StyleType_TwoPlayersSharedSides" then
					self:visible(false);
				else
					self:visible(true);
				end
			else
				self:visible(false);
			end
			self:x(THEME:GetMetric(Var "LoadingScreen","PlayerP2OnePlayerOneSideX"));
		end;
	};

	customlifemeterD(GAMESTATE:GetMasterPlayerNumber()) .. {
		Condition=(GAMESTATE:GetCurrentStyle():GetStyleType() == "StyleType_OnePlayerTwoSides");
		InitCommand=cmd(y,SCREEN_TOP+18;x,SCREEN_CENTER_X;zoomy,0.8*0.66;zoomx,(320/384)*0.85*0.71;); --playcommand,"On";
	};

-------------------------------------P1 SCORE gato
 LoadFont("_arial Bold 20px") .. {
	InitCommand=cmd(horizalign,right;y,SCREEN_TOP+19;zoom,0.62;uppercase,true;shadowlength,1;visible,GAMESTATE:IsHumanPlayer(PLAYER_1);playcommand,"Set");
	ComboChangedMessageCommand=function(self)
		local PSS = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1);
		self:settext(scorecap(PSS:GetScore()));
	end;
	
	SetCommand=function(self)
		local style = GAMESTATE:GetCurrentStyle();
		
		
		if GetUserPref("UserPrefScorePosition") == "On" then 
				if style:GetStyleType() == "StyleType_OnePlayerTwoSides" then
					self:x(SCREEN_RIGHT-83);
				else
					self:x(THEME:GetMetric("ScreenGameplay","PlayerP1OnePlayerOneSideX")+119);
				end
		end
		
		if GetUserPref("UserPrefScorePosition") == "Off" then 
				self:y(SCREEN_BOTTOM+9999);
		end
		
		if style:GetStyleType() == "StyleType_TwoPlayersSharedSides" then
			if GetUserPref("UserPrefScorePosition") == "On" then
				self:x(SCREEN_CENTER_X-25);
				self:visible(GAMESTATE:GetMasterPlayerNumber() == "PlayerNumber_P1")
				self:horizalign(right);
			else
				self:x(SCREEN_CENTER_X);
				self:visible(GAMESTATE:GetMasterPlayerNumber() == "PlayerNumber_P1")
				self:horizalign(center);
			end
		end
		
		
	end
};
	
-----------------------------------P2 SCORE perro
LoadFont("_arial Bold 20px") .. {
	InitCommand=cmd(horizalign,left;y,SCREEN_TOP+19;zoom,0.62;uppercase,true;shadowlength,1;visible,GAMESTATE:IsHumanPlayer(PLAYER_2);playcommand,"Set");	
	ComboChangedMessageCommand=function(self)
		
		local PSS = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_2);
		self:settext(scorecap(PSS:GetScore()));
	end;
	
	SetCommand=function(self)
		local style = GAMESTATE:GetCurrentStyle();
		
		
		if GetUserPref("UserPrefScorePosition") == "On" then 
				if style:GetStyleType() == "StyleType_OnePlayerTwoSides" then
					self:x(SCREEN_LEFT+83);
				else
					self:x(THEME:GetMetric("ScreenGameplay","PlayerP2OnePlayerOneSideX")-119);
				end
		end
		
		
		if GetUserPref("UserPrefScorePosition") == "Off" then 
				self:y(SCREEN_BOTTOM+9999);
		end
		
		
		if style:GetStyleType() == "StyleType_TwoPlayersSharedSides" then
			if GetUserPref("UserPrefScorePosition") == "On" then
				self:x(SCREEN_CENTER_X-25);
				self:visible(GAMESTATE:GetMasterPlayerNumber() == "PlayerNumber_P2")
				self:horizalign(right);
			else
				self:x(SCREEN_CENTER_X);
				self:visible(GAMESTATE:GetMasterPlayerNumber() == "PlayerNumber_P2")
				self:horizalign(center);
			end
		end
					
	end
};

	PlayerInfo(PLAYER_1)..{
		InitCommand=cmd(y,SCREEN_TOP+495;zoomy,0.8;draworder,9999;zoomx,0.95;playcommand,"On";);
		OnCommand=function(self)
		local style=GAMESTATE:GetCurrentStyle();
			if GAMESTATE:IsHumanPlayer(PLAYER_1) then
				if style:GetStyleType() == "StyleType_OnePlayerTwoSides" then
					self:visible(true);
					self:x(SCREEN_CENTER_X-220);
				elseif style:GetStyleType() == "StyleType_TwoPlayersSharedSides" then
					if GAMESTATE:GetMasterPlayerNumber() == "PlayerNumber_P1" then
						self:visible(true);
						self:x(SCREEN_CENTER_X-220);
					else
						self:visible(false);
					end
				else
					self:visible(true);
				--[[	self:x(SCREEN_CENTER_X*0.53125);]]--
				if SCREEN_CENTER_X == 320 then
					self:x(THEME:GetMetric(Var "LoadingScreen","PlayerP1OnePlayerOneSideX")-15);
				else
					self:x(THEME:GetMetric(Var "LoadingScreen","PlayerP1OnePlayerOneSideX"));
				end
				end
			else
				self:visible(false);
			end
		end;
	};
	PlayerInfo(PLAYER_2)..{
		InitCommand=cmd(y,SCREEN_TOP+495;zoomy,0.8;draworder,9999;zoomx,0.95;playcommand,"On";);
		OnCommand=function(self)
		local style=GAMESTATE:GetCurrentStyle();
			if GAMESTATE:IsHumanPlayer(PLAYER_2) then
				if style:GetStyleType() == "StyleType_OnePlayerTwoSides" then
					self:visible(true);
					self:x(SCREEN_CENTER_X+220);
				elseif style:GetStyleType() == "StyleType_TwoPlayersSharedSides" then
					if GAMESTATE:GetMasterPlayerNumber() == "PlayerNumber_P2" then
						self:visible(true);
						self:x(SCREEN_CENTER_X+220);
					else
						self:visible(false);
					end
				else
					self:visible(true);
					--[[self:x(SCREEN_CENTER_X*1.46875);]]--
				if SCREEN_CENTER_X == 320 then
					self:x(THEME:GetMetric(Var "LoadingScreen","PlayerP2OnePlayerOneSideX")+15);
				else
					self:x(THEME:GetMetric(Var "LoadingScreen","PlayerP2OnePlayerOneSideX"));
				end

				end
			else
				self:visible(false);
			end
		end;
	};


	
	--LoadActor("song meter");

};




return t;



