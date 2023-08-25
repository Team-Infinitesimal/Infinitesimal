-- Majority of code borrowed from Mr. ThatKid and Sudospective

local NotefieldRenderBefore = THEME:GetMetric("Player","DrawDistanceBeforeTargetsPixels") -- 300
local NotefieldRenderAfter = THEME:GetMetric("Player","DrawDistanceAfterTargetsPixels") -- 0
local ReceptorPosNormal = THEME:GetMetric("Player","ReceptorArrowsYStandard")
local ReceptorPosReverse = THEME:GetMetric("Player","ReceptorArrowsYReverse")
local ReceptorOffset = ReceptorPosReverse - ReceptorPosNormal
local NotefieldY = (ReceptorPosNormal + ReceptorPosReverse) / 2

local PlayerPos = GAMESTATE:GetNumPlayersEnabled() == 1 and "OnePlayerTwoSides" or "TwoPlayersTwoSides"
local PreviewDelay = THEME:GetMetric("ScreenSelectMusic", "SampleMusicDelay")
local AFTWidth = GAMESTATE:GetNumPlayersEnabled() == 1 and 640 or 320

local STCache = {}

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
    STCache[pn] = nil

    t[#t+1] = Def.ActorFrame {
        Name="Player" .. ToEnumShortString(pn),
        FOV=45,
        InitCommand=function(self)
            self:x((THEME:GetMetric('ScreenGameplay', 'Player' .. ToEnumShortString(pn) .. PlayerPos .. 'X') - SCREEN_CENTER_X) / 1.5):visible(false)
        end,

        SongChosenMessageCommand=function(self) self:visible(true) end,
        SongUnchosenMessageCommand=function(self) self:visible(false) end,
        
        Def.ActorFrameTexture {
            InitCommand=function(self)
                self:SetTextureName("AFT" .. ToEnumShortString(pn))
                self:SetWidth(AFTWidth):SetHeight(480)
                self:EnableAlphaBuffer(true)
                self:Create()
            end,
            
            --[[ Debug
            Def.Quad {
                InitCommand=function(self)
                    self:FullScreen():diffuse(Color.Blue):diffusealpha(0.9)
                end,
            }, ]]

            Def.NoteField {
                Name = "NotefieldPreview",
                Player = pnNoteField,
                --hardcoding skin for now because player choice only updates on screen refresh and most other noteskins look glitchy on previews.
                NoteSkin = 'delta',
                DrawDistanceAfterTargetsPixels = NotefieldRenderAfter,
                DrawDistanceBeforeTargetsPixels = NotefieldRenderBefore,
                YReverseOffsetPixels = ReceptorOffset,
                FieldID=1,
                OnCommand=function(self)
                    self:xy(AFTWidth / 2, 240):addy(NotefieldY)
                    :GetPlayerOptions("ModsLevel_Current")
                    :StealthPastReceptors(true, true)

                    self:AutoPlay(true)
                    self:ModsFromString("C500, Overhead" ) -- this makes it just a simple chart preview instead of a mod preview, but at least it works.
                    --LoadModule("Player.SetSpeed.lua")(pn)
                    --local PlayerModsArray = GAMESTATE:GetPlayerState(pnNoteField):GetPlayerOptionsString("ModsLevel_Preferred")
                    --self:GetPlayerOptions("ModsLevel_Current"):FromString(PlayerModsArray)


                end,

                CurrentStepsP1ChangedMessageCommand=function(self) self:queuecommand("Refresh") end,
                CurrentStepsP2ChangedMessageCommand=function(self) self:queuecommand("Refresh") end,
                OptionsListStartMessageCommand=function(self) self:playcommand("Refresh") end,

                RefreshCommand=function(self)
                    self:AutoPlay(false)
                    local ChartArray = nil

                    local Song = GAMESTATE:GetCurrentSong()
                    if Song then ChartArray = Song:GetAllSteps() else return end

                    local Steps = GAMESTATE:GetCurrentSteps(pn)
                    local StepsType = Steps:GetStepsType()
                    --SCREENMAN:SystemMessage(StepsType)
                    self:ModsFromString("C500, Overhead" ) -- this makes it just a simple chart preview instead of a mod preview, but at least it works.
                    --LoadModule("Player.SetSpeed.lua")(pn)
                    --local PlayerModsArray = GAMESTATE:GetPlayerState(pnNoteField):GetPlayerOptionsString("ModsLevel_Preferred")
                    --self:GetPlayerOptions("ModsLevel_Current"):FromString(PlayerModsArray)

                    if not STCache[pn] or STCache[pn] ~= StepsType then
                        self:ChangeReload(Steps)
                        STCache[pn] = StepsType
                    end

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
        },
        
        Def.Sprite {
            Texture="AFT" .. ToEnumShortString(pn),
            InitCommand=function(self)
                self:zoomto(AFTWidth, 480)
            end
        }
    }
end

return t
