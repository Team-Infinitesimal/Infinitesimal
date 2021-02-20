local c;
local player = Var "Player";
local promode = PREFSMAN:GetPreference("AllowW1") == 'AllowW1_Everywhere' and true or false;

local JudgeCmds = {
	TapNoteScore_CheckpointHit = promode and THEME:GetMetric( "Judgment", "JudgmentW1Command" ) or THEME:GetMetric( "Judgment", "JudgmentW2Command" );
	TapNoteScore_W1 = THEME:GetMetric( "Judgment", "JudgmentW1Command" );
	TapNoteScore_W2 = THEME:GetMetric( "Judgment", "JudgmentW2Command" );
	TapNoteScore_W3 = THEME:GetMetric( "Judgment", "JudgmentW3Command" );
	TapNoteScore_W4 = THEME:GetMetric( "Judgment", "JudgmentW4Command" );
	TapNoteScore_W5 = THEME:GetMetric( "Judgment", "JudgmentW5Command" );
	TapNoteScore_Miss = THEME:GetMetric( "Judgment", "JudgmentMissCommand" );
	TapNoteScore_CheckpointMiss = THEME:GetMetric( "Judgment", "JudgmentMissCommand" );
};

local TNSFrames = {
	TapNoteScore_CheckpointHit = promode and 0 or 1;
	TapNoteScore_W1 = 0;
	TapNoteScore_W2 = 1;
	TapNoteScore_W3 = 2;
	TapNoteScore_W4 = 3;
	TapNoteScore_W5 = 4;
	TapNoteScore_Miss = 5;
	TapNoteScore_CheckpointMiss = 5;
};

local t = Def.ActorFrame {

	LoadActor("Scoring");

	LoadActor(THEME:GetPathG("Judgment","Normal")) .. {
		Name="Judgment";
		InitCommand=function(self)
			self:pause()
			:visible(false)
		end,
		OnCommand=THEME:GetMetric("Judgment","JudgmentOnCommand");
		ResetCommand=function(self)
			self:finishtweening()
			:stopeffect()
			:visible(false)
		end,
	};

	InitCommand = function(self)
		c = self:GetChildren();
	end;

	JudgmentMessageCommand=function(self, param)
		if param.Player ~= player then return end;

		local iNumStates = c.Judgment:GetNumStates();
		local iFrame = TNSFrames[param.TapNoteScore];

		local iTapNoteOffset = param.TapNoteOffset;

		if not iFrame then return end
		if iNumStates == 12 then
			iFrame = iFrame * 2;
			if not param.Early then
				iFrame = iFrame + 1;
			end
		end

		self:playcommand("Reset");

		c.Judgment:visible( true );
		c.Judgment:setstate( iFrame );
		JudgeCmds[param.TapNoteScore](c.Judgment);
	end;
};

return t;
