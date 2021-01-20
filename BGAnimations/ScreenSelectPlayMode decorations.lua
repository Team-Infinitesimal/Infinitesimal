local spacing = 300

local t = Def.ActorFrame {

	LoadActor(THEME:GetPathG("","ScreenHudFrame"));

    LoadActor(THEME:GetPathG("","CornerArrows"));

		Def.ActorFrame {

				OnCommand=function(self) self:playcommand("RefreshPos") end;
				MenuLeftP1MessageCommand=function(self) self:playcommand("RefreshPos") end;
				MenuLeftP2MessageCommand=function(self) self:playcommand("RefreshPos") end;
				MenuRightP1MessageCommand=function(self) self:playcommand("RefreshPos") end;
				MenuRightP2MessageCommand=function(self) self:playcommand("RefreshPos") end;

				RefreshPosCommand=function(self)
						local selection = SCREENMAN:GetTopScreen():GetSelectionIndex(GAMESTATE:GetMasterPlayerNumber())
						self:stoptweening()
						:decelerate(0.25)
						:x(-spacing*selection)
				end;

		    LoadActor(THEME:GetPathG("","ModeSelect/ArcadeMode"))..{
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

		    LoadActor(THEME:GetPathG("","ModeSelect/ProMode"))..{
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

				LoadActor(THEME:GetPathG("","ModeSelect/StaminaMode"))..{
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

return t;
