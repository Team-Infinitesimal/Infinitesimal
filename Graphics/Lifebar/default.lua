local function PlayerInfo(pn)

	local t = Def.ActorFrame {

		LoadFont("montserrat semibold/_montserrat semibold 40px") .. {
			BeginCommand=function(self)
				self:maxwidth(320)
				:draworder(110)
				:horizalign(right)
				:x(SCREEN_CENTER_X-130)
				:y(SCREEN_BOTTOM-10)
				:zoom(0.4)
				:shadowlength(1)
				:uppercase(true)
				:queuecommand("Set")
			end;
			OnCommand=function(self)self:queuecommand("Set")end;
			PlayerJoinedMessageCommand=function(self)self:queuecommand("Set")end;
			PlayerUnjoinedMessageCommand=function(self)self:queuecommand("Set")end;
			SetCommand=function(self)
				local profile = PROFILEMAN:GetProfile(PLAYER_1);
				local name = profile:GetDisplayName();

				if GAMESTATE:IsHumanPlayer(PLAYER_1) == true then
					if name=="" then
						self:settext("No Name");
					else
						self:settext(name);
					end
				end
			end;
		};

		LoadFont("montserrat semibold/_montserrat semibold 40px") .. {
			InitCommand=function(self)
				self:maxwidth(320)
				:draworder(110)
				:horizalign(left)
				:x(SCREEN_CENTER_X+130)
				:y(SCREEN_BOTTOM-10)
				:zoom(0.4)
				:shadowlength(1)
				:uppercase(true)
				:queuecommand("Set")
			end;
			OnCommand=function(self)self:queuecommand("Set")end;
			PlayerJoinedMessageCommand=function(self)self:queuecommand("Set")end;
			PlayerUnjoinedMessageCommand=function(self)self:queuecommand("Set")end;
			SetCommand=function(self)
				local profile = PROFILEMAN:GetProfile(PLAYER_2);
				local name = profile:GetDisplayName();

				if GAMESTATE:IsHumanPlayer(PLAYER_2) == true then
					if name=="" then
						self:settext("No Name");
					else
						self:settext(name);
					end
				end
			end;
		};

	};

	return t;
end;

local function LifeMeterSingle(pn)

	local t = Def.ActorFrame {

		LoadActor("Mask") .. {
			BeginCommand=function(self)self:x(-270-38):MaskSource()end;
		};

		LoadActor("Life bar bg single") .. {
			BeginCommand=function(self)self:diffusealpha(0.75):zoomx(1.01)end;
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

		LoadActor("Bar danger single") .. {
			OnCommand=function(self)
				self:diffuseshift()
				:effectperiod(0.3)
				:effectcolor1(color("#FFFFFF"))
				:effectcolor2(color("#aeaeae"))
				:diffusealpha(0.9)
				:visible(false)
			end;
			["LifeMeterChanged"..pname(pn).."MessageCommand"]=function(self,params)
				local dgthreshold = 0.2

				if params.Life < dgthreshold then
					self:visible(true);
				else
					self:visible(false);
				end
			end;
		};

		LoadActor("Pulse") .. {
			BeginCommand=function(self)
				self:zoomto(40,40)
				:blend(Blend.Add)
				:diffuseshift()
				:effectcolor1(1,1,1,1)
				:effectcolor2(1,1,1,0)
				:effectclock("bgm")
				:effecttiming(1,0,0,0)
				:MaskDest()
			end;
			["LifeMeterChanged"..pname(pn).."MessageCommand"]=function(self,params)
				local xpos = params.Life*500;

				if xpos <= 4 then
					xpos = 4
				elseif xpos >= 498 then
					xpos = 498
				end

				self:x(xpos-250-20);
			end;
		};

		LoadActor("Blue gradient 1") .. {
			BeginCommand=function(self)self:zoomto(40,40):MaskDest():playcommand("Change")end;
			InitCommand=function(self)self:glowshift():effectperiod(0.6):effectcolor1(1,1,1,0):effectcolor2(1,1,1,1)end;
			OnCommand=function(self)self:bounce():effectmagnitude(-40,0,0):effectclock("bgm"):effecttiming(1,0,0,0)end;
			["LifeMeterChanged"..pname(pn).."MessageCommand"]=function(self,params)
				local xpos = params.Life*500;

				if xpos <= 4 then
					xpos = 4
				elseif xpos >= 498 then
					xpos = 498
				end

				self:x(xpos-250-20);
			end;
		};

		LoadActor("Blue solid single") .. {
			BeginCommand=function(self)self:player(pn):playcommand("Change"):ztest(true)end;--20
			["LifeMeterChanged"..pname(pn).."MessageCommand"]=function(self,params)
				local hothreshold = 1.2--1.2
				self:cropright(1.07-params.Life);--1
			end;
		};

		LoadActor("Bar hot") .. {
			BeginCommand=function(self)self:draworder(5):x(0):visible(false):customtexturerect(0,0,.5,1):texcoordvelocity(0.7,0)end;
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
		LoadActor("Life bar single");

		LoadActor("Tip hot") .. {
			BeginCommand=function(self)self:player(pn):draworder(5)end;
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

		LoadActor("Tip danger") .. {
			BeginCommand=function(self)self:player(pn):draworder(5):visible(false)end;
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
					xpos = 498
				end

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

local function LifeMeterDouble(pn)

	local t = Def.ActorFrame {

		LoadActor("Mask") .. {
			BeginCommand=function(self)self:x(-519-42):zoomx(1.2):MaskSource()end;
		};

		LoadActor("Life bar bg double") .. {
			BeginCommand=function(self)self:diffusealpha(0.75):player(pn)end;
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

		LoadActor("Bar danger double") .. {
			OnCommand=function(self)
				self:diffuseshift()
				:effectperiod(0.3)
				:effectcolor1(color("#FFFFFF"))
				:effectcolor2(color("#aeaeae"))
				:diffusealpha(0.9)
				:visible(false)
			end;
			["LifeMeterChanged"..pname(pn).."MessageCommand"]=function(self,params)
				local life = params.Life
				local dgthreshold = 0.2

				if life <= dgthreshold then
					self:visible(true);
				else
					self:visible(false);
				end;
			end;
		};

		LoadActor("Pulse") .. {
			BeginCommand=function(self)
				self:zoomto(40,40)
				:blend(Blend.Add)
				:diffuseshift()
				:effectcolor1(1,1,1,1)
				:effectcolor2(1,1,1,0)
				:effectclock("bgm")
				:effecttiming(1,0,0,0)
				:MaskDest()
			end;
			["LifeMeterChanged"..pname(pn).."MessageCommand"]=function(self,params)
				local xpos = params.Life*1000;

				if xpos <= 4 then
					xpos = 4
				elseif xpos >= 998 then
					xpos = 998
				end

				self:x(xpos-500-20);
			end;
		};

		LoadActor("Blue gradient 2") .. {
			BeginCommand=function(self)self:zoomto(80,40):MaskDest():playcommand("Change")end;
			InitCommand=function(self)self:glowshift():effectperiod(0.6):effectcolor1(1,1,1,0.3):effectcolor2(1,1,1,0.9)end;
			OnCommand=function(self)self:bounce():effectmagnitude(-40,0,0):effectclock("bgm"):effecttiming(1,0,0,0)end;
			["LifeMeterChanged"..pname(pn).."MessageCommand"]=function(self,params)
				local life = params.Life;
				local xpos = life*1000;

				if xpos <= 4 then
					xpos = 4
				elseif xpos >= 998 then
					xpos = 998
				end

				self:x(xpos-500-40);
			end;
		};

		LoadActor("Blue solid double") .. {
			BeginCommand=function(self)self:player(pn)playcommand("Change"):x(-8):ztest(true)end;--20
			["LifeMeterChanged"..pname(pn).."MessageCommand"]=function(self,params)
				local lfzoom = params.Life;
				local hothreshold = 1.2--1.2
				self:cropright(1.04-lfzoom);--1
			end;
		};

		LoadActor("Bar hot") .. {
			--customtexturerect( float fLeft, float fTop, float fRight, float fBottom )
			BeginCommand=function(self)self:draworder(5):x(0):visible(false):customtexturerect(0,0,.5,1):zoomx(2):texcoordvelocity(0.7,0)end;
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

		LoadActor("Life bar double");

		LoadActor("Tip hot") .. {
			BeginCommand=function(self)self:player(pn):draworder(5):playcommand("Xposition")end;
			["LifeMeterChanged"..pname(pn).."MessageCommand"]=function(self,params)
				local life = params.Life;
				local dgthreshold = THEME:GetMetric("LifeMeterBar", "DangerThreshold");
				self:glow(0,0,0,1);

				if life <= dgthreshold then
					self:visible(false);
				else
					self:visible(true);
				end;

				local xpos = life*1000;

				if xpos <= 4 then
					xpos = 4
				elseif xpos >= 994 then
					xpos = 994
				end;

				self:x(xpos-500);
				self:glowshift();
				self:effectperiod(0.2);
				self:effectcolor1(1,1,1,0);
				self:effectcolor2(1,1,1,1);
			end;
		};

		LoadActor("Tip danger") .. {
			BeginCommand=function(self)self:player(pn):draworder(5):visible(false)end;
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
					xpos = 994
				end

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

	LifeMeterSingle(PLAYER_1) .. {
		InitCommand=function(self)self:y(SCREEN_TOP+18):zoomy(0.8*0.66):zoomx((340/384)*0.85*0.66):playcommand("On")end;
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

	LifeMeterSingle(PLAYER_2) .. {
		InitCommand=function(self)self:y(SCREEN_TOP+18):zoomy(0.8*0.66):zoomx((340/384)*0.85*0.66):rotationy(180):playcommand("On")end;
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

	LifeMeterDouble(GAMESTATE:GetMasterPlayerNumber()) .. {
		Condition=(GAMESTATE:GetCurrentStyle():GetStyleType() == "StyleType_OnePlayerTwoSides");
		InitCommand=function(self)self:y(SCREEN_TOP+18):x(SCREEN_CENTER_X):zoomy(0.8*0.66):zoomx((320/384)*0.85*0.71)end; --playcommand,"On";
	};

};

return t;
