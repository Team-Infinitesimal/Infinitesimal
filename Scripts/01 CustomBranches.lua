-- Fallback fix
Branch.TitleMenu = function()
    -- home mode is the most assumed use of sm-ssc.
    if GAMESTATE:GetCoinMode() == "CoinMode_Home" then
        return "ScreenTitleMenu"
    end
    -- arcade junk:
    if GAMESTATE:GetCoinsNeededToJoin() > GAMESTATE:GetCoins() then
        -- if no credits are inserted, don't show the Join screen. SM4 has
        -- this as the initial screen, but that means we'd be stuck in a
        -- loop with ScreenInit. No good.
        return "ScreenLogo"
    else
        return "ScreenTitleJoin"
    end
end

CustomBranch = {
	StartGame = function()
		if SONGMAN:GetNumSongs() == 0 and SONGMAN:GetNumAdditionalSongs() == 0 then
			return "ScreenHowToInstallSongs"
		end
		if PROFILEMAN:GetNumLocalProfiles() > 0 then
			return "ScreenSelectProfile"
        -- Memory card support
		elseif PROFILEMAN:IsPersistentProfile(GAMESTATE:GetMasterPlayerNumber()) then
            return "ScreenSelectMusic"
        else
			-- Will be basic mode soon
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
