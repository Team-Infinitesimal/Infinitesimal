local baseZoom = 0.25
local spacing = 29;
local delay = 2

local baseX = SCREEN_CENTER_X - (spacing*5.5)
local baseY = SCREEN_CENTER_Y + 40;

local t = Def.ActorFrame {

	LoadActor("CornerArrows");

	LoadActor("ChartInfo");
	
}

for pn in ivalues(PlayerNumber) do

	t[#t+1] = Def.ActorFrame {
	
		LoadActor(THEME:GetPathG("","GradientUI"))..{
			InitCommand=function(self)
				self:zoomx(baseZoom+0.5075)
				:zoomy(baseZoom)
				:x(baseX+spacing*5.5)
				:y(baseY-40)
				:animate(false)
			end;
			
			PlayerJoinedMessageCommand=function(self)
				self:visible(GAMESTATE:IsHumanPlayer(pn))
				:stoptweening()
				:decelerate(0.3)
				:y(baseY+80);
			end;
			
			CurrentStepsP1ChangedMessageCommand=function(self)self:playcommand("Refresh")end;
			CurrentStepsP2ChangedMessageCommand=function(self)self:playcommand("Refresh")end;
			CurrentSongChangedMessageCommand=function(self)self:playcommand("Refresh")end;
			NextSongMessageCommand=function(self)self:playcommand("Refresh")end;
			PreviousSongMessageCommand=function(self)self:playcommand("Refresh")end;
			
			OnCommand=function(self)
				self:visible(false)
				:stoptweening()
				:decelerate(0.3)
				:y(baseY-40);
			end;
			
			SongChosenMessageCommand=function(self)
				self:visible(GAMESTATE:IsSideJoined(pn))
				:stoptweening()
				:decelerate(0.3)
				:y(baseY+80);
			end;
			SongUnchosenMessageCommand=function(self)
				self:visible(false)
				:stoptweening()
				:decelerate(0.3)
				:y(baseY-40);
			end;
			TwoPartConfirmCanceledMessageCommand=function(self)
				self:visible(false)
				:stoptweening()
				:decelerate(0.3)
				:y(baseY-40);
			end;
		};
		
		LoadActor(THEME:GetPathG("","DifficultyDisplay/_icon"))..{
			InitCommand=function(self)
				self:zoom(baseZoom+0.25)
				:x(baseX+spacing*5.5)
				:y(baseY-40)
				:animate(false)
				
				if pn == PLAYER_1 then
					self:addx(spacing*-5.5);
				else
					self:addx(spacing*5.5);
				end;
			end;
			
			PlayerJoinedMessageCommand=function(self)
				self:visible(GAMESTATE:IsHumanPlayer(pn))
				:stoptweening()
				:decelerate(0.3)
				:y(baseY+80);
			end;
			
			CurrentStepsP1ChangedMessageCommand=function(self)self:playcommand("Refresh")end;
			CurrentStepsP2ChangedMessageCommand=function(self)self:playcommand("Refresh")end;
			CurrentSongChangedMessageCommand=function(self)self:playcommand("Refresh")end;
			NextSongMessageCommand=function(self)self:playcommand("Refresh")end;
			PreviousSongMessageCommand=function(self)self:playcommand("Refresh")end;
			
			OnCommand=function(self)
				self:visible(false)
				:stoptweening()
				:decelerate(0.3)
				:y(baseY-40);
			end;
			
			SongChosenMessageCommand=function(self)
				self:visible(GAMESTATE:IsSideJoined(pn))
				:stoptweening()
				:decelerate(0.3)
				:y(baseY+80);
			end;
			SongUnchosenMessageCommand=function(self)
				self:visible(false)
				:stoptweening()
				:decelerate(0.3)
				:y(baseY-40);
			end;
			TwoPartConfirmCanceledMessageCommand=function(self)
				self:visible(false)
				:stoptweening()
				:decelerate(0.3)
				:y(baseY-40);
			end;
			
			RefreshCommand=function(self)
				if stepsArray then
					local index = GetCurrentStepsIndex(pn);
					
					if stepsArray[index] then
						local steps = stepsArray[index];
						self:diffusealpha(1);
						if steps:GetStepsType() == "StepsType_Pump_Single" then
							if (string.find(steps:GetDescription(), "SP")) then
								self:setstate(5);
							else
								self:setstate(2);
							end;
						elseif steps:GetStepsType() == "StepsType_Pump_Double" then
							--Check for StepF2 Double Performance tag
							if string.find(steps:GetDescription(), "DP") then
								if steps:GetMeter() == 99 then
									self:setstate(1);
								else
									self:setstate(0);
								end;
							else
								self:setstate(6);
							end;
						elseif steps:GetStepsType() == "StepsType_Pump_Halfdouble" then
							self:setstate(5);
						elseif steps:GetStepsType() == "StepsType_Pump_Routine" then
							self:setstate(4);
						else
							self:setstate(3);
						end;
					else
						self:setstate(3);
						self:diffusealpha(0.3);
					end;
				else
					self:setstate(3);
					self:diffusealpha(0.3);
				end
			end
		};

		LoadFont("montserrat semibold/_montserrat semibold 40px")..{
			InitCommand=function(self)
				self:zoom(baseZoom+0.25)
				:shadowlength(0.8)
				:shadowcolor(color("0,0,0,1"))
				:x(baseX+spacing*5.5)
				:y(baseY-40)
				
				if pn == PLAYER_1 then
					self:addx(-spacing*5.5);
				else
					self:addx(spacing*5.5);
				end;
			end;
			
			PlayerJoinedMessageCommand=function(self)
				self:visible(GAMESTATE:IsHumanPlayer(pn))
				:stoptweening()
				:decelerate(0.3)
				:y(baseY+80);
			end;
			
			CurrentStepsP1ChangedMessageCommand=function(self)self:playcommand("Refresh")end;
			CurrentStepsP2ChangedMessageCommand=function(self)self:playcommand("Refresh")end;
			CurrentSongChangedMessageCommand=function(self)self:playcommand("Refresh")end;
			NextSongMessageCommand=function(self)self:playcommand("Refresh")end;
			PreviousSongMessageCommand=function(self)self:playcommand("Refresh")end;
			
			SongChosenMessageCommand=function(self)self:playcommand("SlideOn")end;
			SongUnchosenMessageCommand=function(self)self:playcommand("SlideOff")end;
			TwoPartConfirmCanceledMessageCommand=function(self)self:playcommand("SlideOff")end;
			OnCommand=function(self)self:playcommand("SlideOff")end;
			
			SlideOnCommand=function(self)
				self:visible(GAMESTATE:IsSideJoined(pn))
				:stoptweening()
				:decelerate(0.3)
				:y(baseY+80);
			end;
			
			SlideOffCommand=function(self)
				self:visible(false)
				:stoptweening()
				:decelerate(0.3)
				:y(baseY-40);
			end;
			
			RefreshCommand=function(self)
				self:stoptweening();

				if stepsArray then
					local index = GetCurrentStepsIndex(pn);
					
					if stepsArray[index] then
						self:diffusealpha(1);
						local steps = stepsArray[index];
						if steps:GetMeter() >= 99 then
							self:settext("??");
						else
							self:settext(steps:GetMeter());
						end
					else
						self:diffusealpha(0.3);
						self:settext("--");
					end
				else
					self:diffusealpha(0.3);
					self:settext("--");
				end
			end
		};
	}
end;

return t;