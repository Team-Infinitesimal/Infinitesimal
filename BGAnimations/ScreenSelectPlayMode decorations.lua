local spacing = 300

local t = Def.ActorFrame {

	LoadActor(THEME:GetPathG("","ScreenHudFrame"));

    LoadActor(THEME:GetPathG("","CornerArrows"));

		Def.ActorFrame {

				OnCommand=function(self) self:playcommand("RefreshPos") end;
				MenuLeftP1MessageCommand=function(self) self:playcommand("RefreshPos") end;
				MenuLeftP2MessageCommand=function(self) self:playcommand("RefreshPos") end;
				MenuUpP1MessageCommand=function(self) self:playcommand("RefreshPos") end;
				MenuUpP2MessageCommand=function(self) self:playcommand("RefreshPos") end;
				MenuRightP1MessageCommand=function(self) self:playcommand("RefreshPos") end;
				MenuRightP2MessageCommand=function(self) self:playcommand("RefreshPos") end;
				MenuDownP1MessageCommand=function(self) self:playcommand("RefreshPos") end;
				MenuDownP2MessageCommand=function(self) self:playcommand("RefreshPos") end;

				RefreshPosCommand=function(self)
						local selection = SCREENMAN:GetTopScreen():GetSelectionIndex(GAMESTATE:GetMasterPlayerNumber())
						self:stoptweening()
						:decelerate(0.25)
						:x(-spacing*selection)
				end;

		    Def.Sprite {
						Texture=THEME:GetPathG("","ModeSelect/ArcadeMode"),
		        InitCommand=function(self)
		            self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y)
		            :zoom(0.5)
		            :diffusealpha(0.6)
		        end;
		        OnCommand=function(self)
		            self:playcommand("Refresh")
		        end;
		        MenuSelectionChangedMessageCommand=function(self)
		            self:stoptweening()
		            :playcommand("Refresh")
		        end;
		        RefreshCommand=function(self)
		            if SCREENMAN:GetTopScreen():GetSelectionIndex(GAMESTATE:GetMasterPlayerNumber()) == 0 then
						PREFSMAN:SetPreference("AllowW1",'AllowW1_Never');
		                self:diffusealpha(1)
		                :queuecommand("Zoom")
		            else
		                self:decelerate(0.2)
		                :zoom(0.5)
		                :diffusealpha(0.6)
		            end;
		        end;
		        ZoomCommand=function(self)
		            self:decelerate(0.4286)
		            :zoom(0.55)
		            :accelerate(0.3947)
		            :zoom(0.5)
		            :queuecommand("Zoom")
		        end;
		    };

		    Def.Sprite {
						Texture=THEME:GetPathG("","ModeSelect/ProMode"),
		        InitCommand=function(self)
		            self:xy(SCREEN_CENTER_X+spacing,SCREEN_CENTER_Y)
		            :zoom(0.5)
		            :diffusealpha(0.6)
		        end;
		        OnCommand=function(self)
		            self:playcommand("Refresh")
		        end;
		        MenuSelectionChangedMessageCommand=function(self)
		            self:stoptweening()
		            :playcommand("Refresh")
		        end;
		        RefreshCommand=function(self)
		            if SCREENMAN:GetTopScreen():GetSelectionIndex(GAMESTATE:GetMasterPlayerNumber()) == 1 then
						PREFSMAN:SetPreference("AllowW1",'AllowW1_Everywhere');
		                self:diffusealpha(1)
		                :queuecommand("Zoom")
		            else
		                self:decelerate(0.2)
		                :zoom(0.5)
		                :diffusealpha(0.6)
		            end;
		        end;
		        ZoomCommand=function(self)
		            self:decelerate(0.4286)
		            :zoom(0.55)
		            :accelerate(0.3947)
		            :zoom(0.5)
		            :queuecommand("Zoom")
		        end;
		    };

				Def.Sprite {
						Texture=THEME:GetPathG("","ModeSelect/StaminaMode"),
						InitCommand=function(self)
								self:xy(SCREEN_CENTER_X+(spacing*2),SCREEN_CENTER_Y)
								:zoom(0.5)
								:diffusealpha(0.6)
						end;
						OnCommand=function(self)
								self:playcommand("Refresh")
						end;
						MenuSelectionChangedMessageCommand=function(self)
								self:stoptweening()
								:playcommand("Refresh")
						end;
						RefreshCommand=function(self)
								if SCREENMAN:GetTopScreen():GetSelectionIndex(GAMESTATE:GetMasterPlayerNumber()) == 2 then
						PREFSMAN:SetPreference("AllowW1",'AllowW1_Everywhere');
										self:diffusealpha(1)
										:queuecommand("Zoom")
								else
										self:decelerate(0.2)
										:zoom(0.5)
										:diffusealpha(0.6)
								end;
						end;
						ZoomCommand=function(self)
								self:decelerate(0.4286)
								:zoom(0.55)
								:accelerate(0.3947)
								:zoom(0.5)
								:queuecommand("Zoom")
						end;
				};
		};
};

-- Text
t[#t+1] = LoadFont("Montserrat Semibold 40px")..{
	InitCommand=function(self)
		if GetScreenAspectRatio() >= 1.5 then
			self:x(SCREEN_CENTER_X-250)
		else
			self:x(SCREEN_CENTER_X-195)
		end;
		self:zoom(0.4)
		:shadowcolor(0,0,0,0.25)
		:shadowlength(0.75)
		:diffuse(0,0,0,1)
		:y(SCREEN_TOP-150)
		:settext("SELECT")
	end;
	OnCommand=function(self)
		self:decelerate(1)
		:y(SCREEN_TOP+26)
	end;
};

t[#t+1] = LoadFont("Montserrat normal 40px")..{
	InitCommand=function(self)
		if GetScreenAspectRatio() >= 1.5 then
			self:x(SCREEN_CENTER_X-192)
		else
			self:x(SCREEN_CENTER_X-137)
		end;
		self:zoom(0.4)
		:shadowcolor(0,0,0,0.25)
		:shadowlength(0.75)
		:diffuse(0,0,0,1)
		:y(SCREEN_TOP-150)
		:settext("MODE")
	end;
	OnCommand=function(self)
		self:decelerate(1)
		:y(SCREEN_TOP+26)
	end;
};

return t;
