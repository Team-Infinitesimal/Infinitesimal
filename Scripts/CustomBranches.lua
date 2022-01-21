CustomBranch = {
	StartGame = function()
		if SONGMAN:GetNumSongs() == 0 and SONGMAN:GetNumAdditionalSongs() == 0 then
			return "ScreenHowToInstallSongs"
		end
		if PROFILEMAN:GetNumLocalProfiles() > 0 then
			return "ScreenSelectProfile"
		else
			return "ScreenSelectMusic"
		end
	end,
	AfterProfileSave = function()
		if GAMESTATE:IsEventMode() then
			return SelectMusicOrCourse()
		elseif STATSMAN:GetCurStageStats():AllFailed() or
			GAMESTATE:GetSmallestNumStagesLeftForAnyHumanPlayer() == 0 then
			return GameOverOrContinue()
		else
			return SelectMusicOrCourse()
		end
	end,
}
