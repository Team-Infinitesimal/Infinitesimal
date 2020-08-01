--[[
	This code has been borrowed from the PIU Delta theme,
	credits goes to Luizsan, Rhythm Lunatic and everyone
	else who has contributed to that theme. This code has
	replaced all the cmd calls and removed basic mode.
]]

local baseZoom = 0.25
local spacing = 29;
local delay = 2

local baseX = basicMode and -spacing*1.5 or -(spacing*5.5)
local baseY = 190;

local stepsArray;

function GetCurrentStepsIndex(pn)
	local playerSteps = GAMESTATE:GetCurrentSteps(pn);
	for i=1,#stepsArray do
		if playerSteps == stepsArray[i] then
			return i;
		end;
	end;
	--If it reaches this point, the selected steps doesn't equal anything.
	return -1;
end;

function SetCurrentStepsIndex(pn, index)
	for i=1,#stepsArray do
		if index == stepsArray[i] then
			GAMESTATE:SetCurrentSteps(pn, stepsArray[i]);
		end;
	end;
end;

local t = Def.ActorFrame {
	CurrentSongChangedMessageCommand=function(self)self:playcommand("Refresh")end;
	RefreshCommand=function(self)
			self:stoptweening();
			local song = GAMESTATE:GetCurrentSong();
			if song then
				stepsArray = SongUtil.GetPlayableSteps(song);
			else
				stepsArray = nil;
			end;
	end;
}

for i=1,12 do

	--The original code was an absolute fucking nightmare
	t[#t+1] = Def.ActorFrame{
		LoadActor("_icon")..{
			InitCommand=function(self)
				self:zoom(baseZoom)
				:x(baseX+spacing*(i-1))
				:y(baseY)
				:animate(false)
			end;
			
			CurrentStepsP1ChangedMessageCommand=function(self)self:playcommand("Refresh")end;
			CurrentStepsP2ChangedMessageCommand=function(self)self:playcommand("Refresh")end;
			CurrentSongChangedMessageCommand=function(self)self:playcommand("Refresh")end;
			NextSongMessageCommand=function(self)self:playcommand("Refresh")end;
			PreviousSongMessageCommand=function(self)self:playcommand("Refresh")end;
			
			RefreshCommand=function(self)
				if stepsArray then
					local j = i;
					if GetCurrentStepsIndex(PLAYER_1) > 12 or GetCurrentStepsIndex(PLAYER_2) > 12 then
						if GetCurrentStepsIndex(PLAYER_1) > GetCurrentStepsIndex(PLAYER_2) then
							j = i+(GetCurrentStepsIndex(PLAYER_1)-12);
						else
							j = i+(GetCurrentStepsIndex(PLAYER_2)-12);
						end;
					else
						j = i;
					end;
					
					if stepsArray[j] then
						local steps = stepsArray[j];
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
				self:zoom(baseZoom)
				:shadowlength(0.8)
				:shadowcolor(color("0,0,0,1"))
				:x(baseX+spacing*(i-1))
				:y(baseY)
			end;
			
			CurrentStepsP1ChangedMessageCommand=function(self)self:playcommand("Refresh")end;
			CurrentStepsP2ChangedMessageCommand=function(self)self:playcommand("Refresh")end;
			CurrentSongChangedMessageCommand=function(self)self:playcommand("Refresh")end;
			NextSongMessageCommand=function(self)self:playcommand("Refresh")end;
			PreviousSongMessageCommand=function(self)self:playcommand("Refresh")end;
			
			RefreshCommand=function(self)
				self:stoptweening();

				if stepsArray then
					local j;
					if GetCurrentStepsIndex(PLAYER_1) > 12 or GetCurrentStepsIndex(PLAYER_2) > 12 then
						if GetCurrentStepsIndex(PLAYER_1) > GetCurrentStepsIndex(PLAYER_2) then
							j = i+(GetCurrentStepsIndex(PLAYER_1)-12);
						else
							j = i+(GetCurrentStepsIndex(PLAYER_2)-12);
						end;
					else
						j = i;
					end;
					if stepsArray[j] then
						self:diffusealpha(1);
						local steps = stepsArray[j];
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
	};
end

--Needs to have both in case of late join
for pn in ivalues(PlayerNumber) do

	t[#t+1] = LoadActor("UnifiedCursor", pn)..{
		InitCommand=function(self)
			self:zoom(baseZoom)
			:x(baseX)
			:y(baseY)
			:rotationx(180)
			:spin()
			:playcommand("Set")
		end;
		
		PlayerJoinedMessageCommand=function(self)
			self:visible(GAMESTATE:IsHumanPlayer(pn))
		end;
		
		CurrentStepsP1ChangedMessageCommand=function(self)self:playcommand("Set")end;
		CurrentStepsP2ChangedMessageCommand=function(self)self:playcommand("Set")end;
		CurrentSongChangedMessageCommand=function(self)self:playcommand("Set")end;
		NextSongMessageCommand=function(self)self:playcommand("Set")end;
		PreviousSongMessageCommand=function(self)self:playcommand("Set")end;
		
		OnCommand=function(self)
			self:visible(false)
		end;
		
		SongChosenMessageCommand=function(self)
			self:visible(GAMESTATE:IsSideJoined(pn));
		end;
		SongUnchosenMessageCommand=function(self)
			self:visible(false);
		end;
		TwoPartConfirmCanceledMessageCommand=function(self)
			self:visible(false);
		end;

		--This looks WAY more moronic than before, possibly redo this soon?
		SetCommand=function(self)
			if stepsArray then
				local index = GetCurrentStepsIndex(pn);
				
				if index > 12 then
					index = 12;
				elseif GetCurrentStepsIndex(PLAYER_1) > GetCurrentStepsIndex(PLAYER_2) and 
					GetCurrentStepsIndex(PLAYER_1) > 12 and 
					pn == PLAYER_2 then
						SetCurrentStepsIndex(pn, index + GetCurrentStepsIndex(PLAYER_1));
				elseif GetCurrentStepsIndex(PLAYER_2) > GetCurrentStepsIndex(PLAYER_1) and 
					GetCurrentStepsIndex(PLAYER_2) > 12 and 
					pn == PLAYER_1 then
						SetCurrentStepsIndex(pn, index + GetCurrentStepsIndex(PLAYER_2));
				end;	
				
				self:x(baseX+spacing*(index-1));
			end;
		end;
		
		PlayerJoinedMessageCommand=function(self)
			index = 1;
		end;
	}
	
	-- Large selected difficulty icon, scores and background
	t[#t+1] = Def.ActorFrame{
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
		
		LoadActor("_icon")..{
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
		
		LoadFont("montserrat semibold/_montserrat semibold 40px")..{
			InitCommand=function(self)
				self:zoom(baseZoom)
				:shadowlength(0.8)
				:shadowcolor(color("0,0,0,1"))
				:x(baseX+spacing*5.5)
				:y(baseY-80)
				:maxwidth(350)
				:diffusealpha(1)
				
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
				:y(baseY+60);
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
				:y(baseY-80);
			end;
			
			SongChosenMessageCommand=function(self)
				self:visible(GAMESTATE:IsSideJoined(pn))
				:stoptweening()
				:decelerate(0.3)
				:y(baseY+60);
			end;
			SongUnchosenMessageCommand=function(self)
				self:visible(false)
				:stoptweening()
				:decelerate(0.3)
				:y(baseY-80);
			end;
			TwoPartConfirmCanceledMessageCommand=function(self)
				self:visible(false)
				:stoptweening()
				:decelerate(0.3)
				:y(baseY-80);
			end;
			
			RefreshCommand=function(self)
				local chartType = GetChartType(pn);
				if chartType ~= nil then
					self:settext(chartType);
				else
					self:settext("Unknown");
				end;
			end
		};
	};

end;

return t;
