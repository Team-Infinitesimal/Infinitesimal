--[[ Screen Filter ]]
local numPlayers = GAMESTATE:GetNumPlayersEnabled()
local center1P = PREFSMAN:GetPreference("Center1Player")

local padding = 8 -- 4px on each side

local filterColor = color("#000000")
local filterAlphas = {
	PlayerNumber_P1 = 1,
	PlayerNumber_P2 = 1,
	Default = 0,
}	

local filterColorsA = {
	color("#000000"), -- Dark (player)
	color("#000000"), -- Dark
	color("#FFFFFF"), -- Light (player)
	color("#FFFFFF"), -- Light
	color("#AAAAAA"), -- Grey
}
	
local t = Def.ActorFrame{};

local style = GAMESTATE:GetCurrentStyle()
local styleType = ToEnumShortString(style:GetStyleType())
local stepsType = style:GetStepsType()

if numPlayers == 1 then
	local player = GAMESTATE:GetMasterPlayerNumber()
	local pNum = (player == PLAYER_1) and 1 or 2
    local filterSize = LoadModule("Config.Load.lua")("ScreenFilterSize",CheckIfUserOrMachineProfile(pNum-1).."/OutFoxPrefs.ini")
	filterAlphas[player] = tonumber(LoadModule("Config.Load.lua")("ScreenFilter",CheckIfUserOrMachineProfile(pNum-1).."/OutFoxPrefs.ini")) or 0
	local pos;
	-- [ScreenGameplay] PlayerP#Player*Side(s)X
	if center1P then
		pos = SCREEN_CENTER_X
	elseif stepsType == "StepsType_Dance_Solo" then
		pos = SCREEN_CENTER_X
	else
		local metricName = string.format("PlayerP%i%sX",pNum,styleType)
		pos = THEME:GetMetric("ScreenGameplay",metricName)
	end
	if filterAlphas[player] > 0 then
		t[#t+1] = Def.Quad {
			Name="SinglePlayerFilter";
			OnCommand=function(self)
				if GAMESTATE:GetIsFieldCentered(pNum-1) or filterSize == "Full" then
					pos = SCREEN_CENTER_X
				end
				local sfcChoice = tonumber(LoadModule("Config.Load.lua")("ScreenFilterColor",CheckIfUserOrMachineProfile(pNum-1).."/OutFoxPrefs.ini")) or 1
				
                self:x(pos):CenterY():zoomto(filterSize == "Lane" and GAMESTATE:GetStyleFieldSize(pNum-1) * 1.5 + padding or SCREEN_WIDTH,SCREEN_HEIGHT)
				:diffusecolor( filterColorsA[sfcChoice] )
					if sfcChoice == 1 then
						self:diffusebottomedge(ColorDarkTone(PlayerColor(player)))
					elseif sfcChoice == 3 then
						self:diffusebottomedge(ColorLightTone(PlayerColor(player)))
					end
				self:diffusealpha(filterAlphas[player])
			end
		}
	end
else
	-- two players... a bit more complex.
	if styleType == "TwoPlayersSharedSides" then
		-- routine, just use one in the center.
		local player = GAMESTATE:GetMasterPlayerNumber()
		local pNum = player == PLAYER_1 and 1 or 2
        local filterSize = LoadModule("Config.Load.lua")("ScreenFilterSize",CheckIfUserOrMachineProfile(pNum-1).."/OutFoxPrefs.ini")
		local sfcChoice = tonumber(LoadModule("Config.Load.lua")("ScreenFilterColor",CheckIfUserOrMachineProfile(pNum-1).."/OutFoxPrefs.ini")) or 1
		local metricName = "PlayerP".. pNum .."TwoPlayersSharedSidesX"
		if filterAlphas[player] > 0 then
			t[#t+1] = Def.Quad{
				Name="RoutineFilter",
				OnCommand=function(self) 
					self:x(THEME:GetMetric("ScreenGameplay",metricName)):CenterY()
                    :zoomto(filterSize == "Lane" and GAMESTATE:GetStyleFieldSize(pNum-1) * 1.5 + padding or SCREEN_WIDTH,SCREEN_HEIGHT)
                    :diffusecolor(filterColorsA[sfcChoice]):diffusealpha(filterAlphas[player])
				end
			}
		end
	else
		-- otherwise we need two separate ones. to the pairsmobile!
		for i, player in ipairs(PlayerNumber) do
			local pNum = (player == PLAYER_1) and 1 or 2
            local filterSize = LoadModule("Config.Load.lua")("ScreenFilterSize",CheckIfUserOrMachineProfile(pNum-1).."/OutFoxPrefs.ini")
			filterAlphas[player] = tonumber(LoadModule("Config.Load.lua")("ScreenFilter",CheckIfUserOrMachineProfile(pNum-1).."/OutFoxPrefs.ini")) or 0;
			local sfcChoice = tonumber(LoadModule("Config.Load.lua")("ScreenFilterColor",CheckIfUserOrMachineProfile(pNum-1).."/OutFoxPrefs.ini")) or 1
			local metricName = string.format("PlayerP%i%sX",pNum,styleType)
			local pos = THEME:GetMetric("ScreenGameplay",metricName)
            if filterSize == "Full" then
                pos = SCREEN_CENTER_X + (SCREEN_CENTER_X / 2) * (pNum == 1 and -1 or 1)
            end
			if filterAlphas[player] > 0 then
				t[#t+1] = Def.Quad{
					Name="Player"..pNum.."Filter";
					OnCommand=function(self)
						self:x(pos):CenterY():zoomto(filterSize == "Lane" and GAMESTATE:GetStyleFieldSize(pNum-1) * 1.5 + padding or SCREEN_WIDTH / 2,SCREEN_HEIGHT)
						:diffusecolor( filterColorsA[sfcChoice] )
							if sfcChoice == 1 then
								self:diffusebottomedge(ColorDarkTone(PlayerColor(player)))
							elseif sfcChoice == 3 then
								self:diffusebottomedge(ColorLightTone(PlayerColor(player)))
							end
						self:diffusealpha(filterAlphas[player])
					end
				}
			end
		end
	end
end

return t;
