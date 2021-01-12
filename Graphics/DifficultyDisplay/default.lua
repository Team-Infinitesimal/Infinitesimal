--[[
	This code has been borrowed from the PIU Delta theme,
	credits goes to Luizsan, Rhythm Lunatic and everyone
	else who has contributed to that theme. This code has
	replaced all the cmd calls and removed basic mode.
]]

local baseZoom = 0.25
local spacing = 29;
local delay = 2

local baseX = -(spacing*6.5)
local baseY = 0;

local stepsArray, stepsSelected;

function GetCurrentStepsIndex(pn)
	local playerSteps = GAMESTATE:GetCurrentSteps(pn);
	for i=1,#stepsArray do
		if playerSteps == stepsArray[i] then
			return i;
		end;
	end;
	-- If it reaches this point, the selected steps doesn't equal anything.
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

for i=1,14 do

	local j;
	
	-- The original code was an absolute fucking nightmare
	t[#t+1] = Def.ActorFrame {
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
					if GetCurrentStepsIndex(PLAYER_1) > 14 or GetCurrentStepsIndex(PLAYER_2) > 14 then
						if GetCurrentStepsIndex(PLAYER_1) > GetCurrentStepsIndex(PLAYER_2) then
							j = i+(GetCurrentStepsIndex(PLAYER_1)-14);
						else
							j = i+(GetCurrentStepsIndex(PLAYER_2)-14);
						end;
					else
						j = i;
					end;
					
					if stepsArray[j] then
						local steps = stepsArray[j];
						self:diffusealpha(1);
						if steps:GetStepsType() == "StepsType_Pump_Single" then
							if (string.find(steps:GetDescription(), "SP")) then
								self:setstate(3);
							else
								self:setstate(2);
							end;
						elseif steps:GetStepsType() == "StepsType_Pump_Double" then
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
							self:setstate(7);
						end;
					else
						self:setstate(7);
						self:diffusealpha(0.3);
					end;
				else
					self:setstate(7);
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
					if GetCurrentStepsIndex(PLAYER_1) > 14 or GetCurrentStepsIndex(PLAYER_2) > 14 then
						if GetCurrentStepsIndex(PLAYER_1) > GetCurrentStepsIndex(PLAYER_2) then
							j = i+(GetCurrentStepsIndex(PLAYER_1)-14);
						else
							j = i+(GetCurrentStepsIndex(PLAYER_2)-14);
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
	
	-- This is genuinely bad and I'm sorry
	for pn in ivalues(PlayerNumber) do
	
		t[#t+1] = LoadActor("UnifiedCursor", pn)..{
			InitCommand=function(self)
				self:zoom(baseZoom)
				:x(baseX+spacing*(i-1))
				:y(baseY)
				:diffusealpha(0);
			end;
			
			CurrentStepsP1ChangedMessageCommand=function(self)self:playcommand("Set")end;
			CurrentStepsP2ChangedMessageCommand=function(self)self:playcommand("Set")end;
			--PlayerJoinedMessageCommand=function(self)self:playcommand("HideCursor")end;
			SongUnchosenMessageCommand=function(self)self:playcommand("HideCursor")end;
			
			SongChosenMessageCommand=function(self)
				stepsSelected = true;
				self:playcommand("Set");
			end;
			
			HideCursorCommand=function(self)
				stepsSelected = false;
				self:diffusealpha(0);
			end;
	
			SetCommand=function(self)
				if stepsArray and stepsSelected and GAMESTATE:IsHumanPlayer(pn) then
					if GetCurrentStepsIndex(PLAYER_1) > 14 or GetCurrentStepsIndex(PLAYER_2) > 14 then
						if GetCurrentStepsIndex(PLAYER_1) > GetCurrentStepsIndex(PLAYER_2) then
							j = i+(GetCurrentStepsIndex(PLAYER_1)-14);
						else
							j = i+(GetCurrentStepsIndex(PLAYER_2)-14);
						end;
					else
						j = i;
					end;
					
					if GAMESTATE:GetCurrentSteps(pn) == stepsArray[j] then
						self:diffusealpha(1);
					else
						self:diffusealpha(0);
					end;
				end;
			end;
		}
		
	end;
end

return t;
