CustomBranch = {
	StartGame = function()
		-- Check to see if there are 0 songs installed. Also make sure to check
		-- that the additional song count is also 0, because there is
		-- a possibility someone will use their existing StepMania simfile
		-- collection with sm-ssc via AdditionalFolders/AdditionalSongFolders.
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
