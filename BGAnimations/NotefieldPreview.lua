-- Majority of code borrowed from Mr. ThatKid and Sudospective

local NotefieldRenderBefore = 300 --THEME:GetMetric("Player","DrawDistanceBeforeTargetsPixels")
local NotefieldRenderAfter = 0 --THEME:GetMetric("Player","DrawDistanceAfterTargetsPixels")
local ReceptorPosNormal = THEME:GetMetric("Player","ReceptorArrowsYStandard")
local ReceptorPosReverse = THEME:GetMetric("Player","ReceptorArrowsYReverse")
local ReceptorOffset = ReceptorPosReverse - ReceptorPosNormal
local NotefieldY = (ReceptorPosNormal + ReceptorPosReverse) / 2

local PlayerPos = GAMESTATE:GetNumPlayersEnabled() == 1 and "OnePlayerTwoSides" or "TwoPlayersTwoSides"
local PreviewDelay = THEME:GetMetric("ScreenSelectMusic", "SampleMusicDelay")

local function GetCurrentChartIndex(pn, ChartArray)
	local PlayerSteps = GAMESTATE:GetCurrentSteps(pn)
	-- Not sure how the previous checks fails at times, so here it is once again
	if ChartArray then
		for i=1,#ChartArray do
			if PlayerSteps == ChartArray[i] then
				return i
			end
		end
	end
	-- If it reaches this point, the selected steps doesn't equal anything
	return nil
end

local t = Def.ActorFrame {}

for i, pn in ipairs(GAMESTATE:GetEnabledPlayers()) do
    -- To avoid crashes with player 2
    local pnNoteField = PlayerNumber:Reverse()[pn]
    
    t[#t+1] = Def.ActorFrame {
        Name="Player" .. ToEnumShortString(pn),
        FOV=45,
        InitCommand=function(self)
            self:x(THEME:GetMetric('ScreenGameplay', 'Player' .. ToEnumShortString(pn) .. PlayerPos .. 'X') - SCREEN_CENTER_X)
            :zoom(SCREEN_HEIGHT / 480):visible(false)
        end,
        
        SongChosenMessageCommand=function(self) self:visible(true) end,
        SongUnchosenMessageCommand=function(self) self:visible(false) end,

        Def.NoteField {
            Name = "NotefieldPreview",
            Player = pnNoteField,
            NoteSkin = GAMESTATE:GetPlayerState(pnNoteField):GetPlayerOptions('ModsLevel_Preferred'):NoteSkin(),
            DrawDistanceAfterTargetsPixels = NotefieldRenderAfter,
            DrawDistanceBeforeTargetsPixels = NotefieldRenderBefore,
            YReverseOffsetPixels = ReceptorOffset,
            FieldID=1,
            InitCommand=function(self)
                self:y(NotefieldY):GetPlayerOptions("ModsLevel_Current"):StealthPastReceptors(true, true)
                self:AutoPlay(true)
                
                local PlayerModsArray = GAMESTATE:GetPlayerState(pnNoteField):GetPlayerOptionsString("ModsLevel_Preferred")
                self:GetPlayerOptions("ModsLevel_Current"):FromString(PlayerModsArray)
            end,
            
            CurrentStepsP1ChangedMessageCommand=function(self) self:playcommand("Refresh") end,
            CurrentStepsP2ChangedMessageCommand=function(self) self:playcommand("Refresh") end,
            
            OptionsListStartMessageCommand=function(self)
                local PlayerModsArray = GAMESTATE:GetPlayerState(pnNoteField):GetPlayerOptionsString("ModsLevel_Preferred")
                self:GetPlayerOptions("ModsLevel_Current"):FromString(PlayerModsArray)
            end,
            
            RefreshCommand=function(self)
                self:AutoPlay(false)
                local ChartArray = nil
                
                local Song = GAMESTATE:GetCurrentSong()
                if Song then ChartArray = Song:GetAllSteps() else return end
                
                local ChartIndex = GetCurrentChartIndex(pnNoteField, ChartArray)
                if not ChartIndex then return end
                
                local NoteData = Song:GetNoteData(ChartIndex)
                if not NoteData then return end
                
                self:SetNoteDataFromLua({})
                --SCREENMAN:SystemMessage("Loading ChartIndex!")
                self:SetNoteDataFromLua(NoteData)
                self:AutoPlay(true)
            end
        }
    }
end

return t
