local baseZoom = 0.3
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
	
	--[[LoadActor("bg diff_12")..{
		InitCommand=cmd(addy,baseY-35;zoomy,0.71;zoomx,0.665;);
	};]]
}



for i=1,12 do

	--The original code was an absolute fucking nightmare
	t[#t+1] = Def.ActorFrame{
		LoadActor("_icon")..{
			InitCommand=function(self)
				self:zoom(baseZoom-0.05)
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
				--[[
				The PIU default colors are
				Single = Orange
				Double = Green
				Single Performance = Purple
				Double Performance = Blue
				Co-Op / Routine = Yellow
				Halfdouble = Cyan (It's green in PIU, but it doesn't tell you if it's halfdouble)
				]]
				
				if stepsArray then
					local j;
					--TODO: Fix it so it can account for over 24 charts.
					if GetCurrentStepsIndex(PLAYER_1) > 12 or GetCurrentStepsIndex(PLAYER_2) > 12 then
						j = i+12;
					else
						j = i;
					end;
					if stepsArray[j] then

						local steps = stepsArray[j];
						self:diffusealpha(1);
						if steps:GetStepsType() == "StepsType_Pump_Single" then
							self:setstate(2);
						elseif steps:GetStepsType() == "StepsType_Pump_Double" then
							--Check for StepF2 Double Performance tag
							if string.find(steps:GetDescription(), "DP") then
								self:setstate(0);
							else
								self:setstate(6);
							end;
						elseif steps:GetStepsType() == "StepsType_Pump_Halfdouble" then
							self:setstate(4);
						elseif steps:GetStepsType() == "StepsType_Pump_Routine" then
							self:setstate(1);
						else
							self:setstate(3);
						end;
					else
						self:diffusealpha(0);
					end;
				end
			end
		};

		LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
			InitCommand=function(self)
				self:zoomx(baseZoom+0.1)
				:zoomy(baseZoom+0.075)
				:shadowlength(0.8)
				:shadowcolor(color("0,0,0,1"))
				:x(baseX-0.33+spacing*(i-1))
				:y(baseY-0.33)
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
					--TODO: Fix it so it can account for over 24 charts.
					if GetCurrentStepsIndex(PLAYER_1) > 12 or GetCurrentStepsIndex(PLAYER_2) > 12 then
						j = i+12;
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
				end
			end


		};
	};


end

--Needs to have both in case of late join
for pn in ivalues(PlayerNumber) do
	t[#t+1] = LoadActor("UnifiedCursor", pn)..{
		InitCommand=function(self)
			self:zoom(baseZoom-0.05)
			:x(baseX)
			:y(baseY)
			:rotationx(180)
			:spin()
			:playcommand("Set")
		end;
		PlayerJoinedMessageCommand=function(self)
			self:visible(GAMESTATE:IsHumanPlayer(pn))
		end;
		['CurrentSteps'..ToEnumShortString(pn)..'ChangedMessageCommand']=function(self)self:playcommand("Set")end;
		CurrentSongChangedMessageCommand=function(self)self:playcommand("Set")end;
		NextSongMessageCommand=function(self)self:playcommand("Set")end;
		PreviousSongMessageCommand=function(self)self:playcommand("Set")end;
		
		--TODO: Hide cursors until they're selecting a song when the a screen is made for difficulty selection
		OnCommand=function(self)
			self:visible(GAMESTATE:IsHumanPlayer(pn))
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

		--I know this looks moronic, but I don't think there's any other way to do it...
		SetCommand=function(self)
			if stepsArray then
				local index = GetCurrentStepsIndex(pn);
				if index > 12 then
					index = index%12;
				end;
				self:x(baseX+spacing*(index-1));
			end;
		end;
	}
end;

return t;
