-- Majority of code borrowed from mrthatkid and sudo

local def_ds  = THEME:GetMetric("Player","DrawDistanceBeforeTargetsPixels")
local def_dsb = THEME:GetMetric("Player","DrawDistanceAfterTargetsPixels")
local receptposnorm = THEME:GetMetric("Player","ReceptorArrowsYStandard")
local receptposreve = THEME:GetMetric("Player","ReceptorArrowsYReverse")
local yoffset = receptposreve-receptposnorm
local notefieldmid = (receptposnorm + receptposreve)/2

local notefieldoffset = 500

local plrpos
if GAMESTATE:GetNumPlayersEnabled() == 1 then
	-- plrpos = (PREFSMAN:GetPreference('Center1Player') and 'OnePlayerTwoSides') or 'OnePlayerOneSide'
  plrpos = 'OnePlayerTwoSides'
else
	plrpos = 'TwoPlayersTwoSides'
end

local function metricN(class, metric)
	return tonumber(THEME:GetMetric(class, metric))
end

t = Def.ActorFrame {}

for i, v in ipairs(GAMESTATE:GetEnabledPlayers()) do
    t[#t+1] = Def.ActorFrame {
        Name = 'Player'..ToEnumShortString(v),
        FOV = 45,
        OnCommand = function(self)
    			   self:queuecommand('Setup')
    		end,

        SetupCommand = function(self)
      			local notefield = self:GetChild('NotefieldPreview')
      			-- vanish points...........
      			local function scale(var, lower1, upper1, lower2, upper2)
      				    return ((upper2 - lower2) * (var - lower1)) / (upper1 - lower1) + lower2
      			end
      			local poptions = notefield:GetPlayerOptions('ModsLevel_Current')
      			local skew = poptions:Skew()
      			local vanishx = self.vanishpointx
      			local vanishy = self.vanishpointy
      			local posx = self.x
      			local posy = self.y
      			function self:vanishpointx(n)
        				local offset = scale(skew, 0, 1, self:GetX(), SCREEN_CENTER_X)
        				return vanishx(self, offset + n)
      			end
      			function self:vanishpointy(n)
        				local offset = SCREEN_CENTER_Y
        				return vanishy(self, offset + n)
      			end
      			function self:vanishpoint(x, y)
        				return self:vanishpointx(x):vanishpointy(y)
      			end
      			function self:x(n)
        				self:vanishpointx(n)
        				return posx(self, n)
      			end
      			function self:y(n)
        				self:vanishpointy(n)
        				return posy(self, n)
      			end
      			function self:xy(x, y)
      				  return self:x(x):y(y)
      			end
      			function self:xyz(x, y, z)
      				  return self:xy(x, y):z(z)
      			end
      			function self:Center()
      				  return self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y)
      			end
      			function self:FullScreen()
      				  return self:Center():zoomto(SCREEN_WIDTH, SCREEN_HEIGHT)
      			end
      			self
        				:x(metricN('ScreenGameplay', 'Player'..ToEnumShortString(v)..plrpos..'X') - SCREEN_CENTER_X)
        				:zoom(SCREEN_HEIGHT / 480)
        			-- help
      			notefield:y(nf.y)
      			notefield:GetPlayerOptions('ModsLevel_Current'):XMod(plrpop:XMod())
    		end,

        InitCommand=function(self)
            self:x(metricN('ScreenGameplay', 'Player'..ToEnumShortString(v)..plrpos..'X') - SCREEN_CENTER_X)
            :zoom(SCREEN_HEIGHT / 480)
        end,

        SpeedChoiceChangedMessageCommand = function(self, param)
      			local poptions = self:GetChild('NoteField'):GetPlayerOptions('ModsLevel_Current')
      			if param.pn ~= v then return end
      			print(param.speed)
      			local speedmod = param.mode:upper()..'Mod'
      			if speedmod == 'XMod' then
        				poptions:XMod(param.speed * 0.01)
      			else
        				poptions[speedmod](poptions, param.speed)
      			end
    		end,
    		PlayerOptionsChangedMessageCommand = function(self, param)
      			PrintTable(param)
    		end,

        Def.NoteField {
            Name = "NotefieldPreview",
            Player = v,
            NoteSkin = GAMESTATE:GetPlayerState(v):GetPlayerOptions('ModsLevel_Preferred'):NoteSkin(),
            DrawDistanceAfterTargetsPixels = def_dsb,
            DrawDistanceBeforeTargetsPixels = def_ds,
            YReverseOffsetPixels = yoffset,
            FieldID=1,
            SetupCommand=function(self)
                self:y(notefieldmid)
      				  self:GetPlayerOptions('ModsLevel_Current')
      					:StealthPastReceptors(true, true)
      			end,
            CurrentStepsP1ChangedMessageCommand=function(self) self:playcommand("Refresh") end,
            CurrentStepsP2ChangedMessageCommand=function(self) self:playcommand("Refresh") end,
            RefreshCommand=function(self)
                self:diffusealpha(0)
                :SetNoteDataFromLua({})
                self:stoptweening():sleep(0.5)
                local song = GAMESTATE:GetCurrentSong()
                if not song then return end -- If there's no song, do nothing
                local chart
                for n, c in ipairs(song:GetAllSteps()) do
                    if c == GAMESTATE:GetCurrentSteps(v) then
                        chart = n
                    end
                end
                if not chart then return end -- If there's no chart, do nothing
                local nd = song:GetNoteData(chart)
                if not nd then return end -- If there's no notedata, you guessed it, do nothing
                self:SetNoteDataFromLua(nd)
                self:linear(0.5):diffusealpha(1)
                -- Hide notefield after preview ends (cannot get this to work pls help)
                -- self:sleep(GAMESTATE:GetCurrentSong():GetSampleLength() * (GAMESTATE:GetSongBPS()):diffusealpha(0)
            end
        }
    }
end

return t
