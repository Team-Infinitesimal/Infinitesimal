--[[
Custom Speed Mods v3 (for StepMania 5)

changelog:

v3 (StepMania 5 b3)
* Complete rewrite to use profile load/save hooks.

--------------------------------------------------------------------------------
v2.3 (StepMania 5 a2/SM5TE) [by AJ]
* If someone has decided to remove 1x from the machine profile's speed mods,
  silently fix it.
* Ignore Cmod and mmod capitalization errors.

v2.2 (StepMania 5 alpha 2) [by FSX]
* Rewrite table management code.
* Add code to make sure that there are speed mods and that they are correct.

v2.1 (StepMania 5 Preview 2)
* Added support for m-Mods.

v2.0 (for sm-ssc)
Giant rewrite of the speed mod parser.
This rewrite comes with the following changes/features:
* Speed mods are now tied to profiles.
  This is arguably the biggest change, as it allows the speed mods to be
  portable, as well as per-profile.
  Thanks to this, we can now support reading SpeedMods from a USB stick or
  other external storage. (I didn't test writing yet, but it should work.)

This version of Custom Speed Mods will only run on StepMania 5 (due to m-mods).
--------------------------------------------------------------------------------
v1.4
* Try to auto-set the speed mod to 1.0 if:
 1) The player hasn't already chosen a speed mod
 2) The player's custom speed mod collection starts with a value under 1x.
 Due to the way the custom speed mods were coded, it will always pick the
 first value, even if it's not 1.0x.

v1.3
* strip whitespace out of file in case people use it.
	(I don't think it really works but SM seems to think the mods are legal)
* fixed an error related to using the fallback return value.

v1.2
* small fixes
* more comments

v1.1
* Cleaned up code some, I think.
]]

local ProfileSpeedMods = {}

local default_speed_increment = 10
local default_speed_inc_large = 100

local function get_speed_increment()
	local increment= default_speed_increment
	if ReadGamePrefFromFile("SpeedIncrement") then
		increment= tonumber(GetGamePref("SpeedIncrement")) or default_speed_increment
	else
		WriteGamePrefToFile("SpeedIncrement", increment)
	end
	return increment
end

local function get_speed_inc_large()
	local inc_large= default_speed_inc_large
	if ReadGamePrefFromFile("SpeedIncLarge") then
		inc_large= tonumber(GetGamePref("SpeedIncLarge")) or default_speed_inc_large
	else
		WriteGamePrefToFile("SpeedIncLarge", inc_large)
	end
	return inc_large
end

function SpeedModIncSize()
	-- An option row for controlling the size of the increment used by
	-- ArbitrarySpeedMods.
	local increment= get_speed_increment()
	local ret= {
		Name= "Speed Increment",
		LayoutType= "ShowAllInRow",
		SelectType= "SelectMultiple",
		OneChoiceForAllPlayers= true,
		LoadSelections= function(self, list, pn)
			-- The first value is the status element, only it should be true.
			list[1]= true
		end,
		SaveSelections= function(self, list, pn)
			WriteGamePrefToFile("SpeedIncrement", increment)
		end,
		NotifyOfSelection= function(self, pn, choice)
			-- return true even though we didn't actually change anything so that
			-- the underlines will stay correct.
			if choice == 1 then return true end
			local incs= {10, 1, -1, -10}
			local new_val= increment + incs[choice-1]
			if new_val > 0 then
				increment= new_val
			end
			self:GenChoices()
			return true
		end,
		GenChoices= function(self)
			self.Choices= {tostring(increment)}
		end
	}
	ret:GenChoices()
	return ret
end

function SpeedModIncLarge()
	-- An option row for controlling the size of the increment used by
	-- ArbitrarySpeedMods.
	local inc_large= get_speed_inc_large()
	local ret= {
		Name= "Speed Increment Large",
		LayoutType= "ShowAllInRow",
		SelectType= "SelectMultiple",
		OneChoiceForAllPlayers= true,
		LoadSelections= function(self, list, pn)
			-- The first value is the status element, only it should be true.
			list[1]= true
		end,
		SaveSelections= function(self, list, pn)
			WriteGamePrefToFile("SpeedIncLarge", inc_large)
		end,
		NotifyOfSelection= function(self, pn, choice)
			-- return true even though we didn't actually change anything so that
			-- the underlines will stay correct.
			if choice == 1 then return true end
			local incs= {10, 1, -1, -10}
			local new_val= inc_large + incs[choice-1]
			if new_val > 0 then
				inc_large= new_val
			end
			self:GenChoices()
			return true
		end,
		GenChoices= function(self)
			self.Choices= {tostring(inc_large)}
		end
	}
	ret:GenChoices()
	return ret
end

function GetSpeedModeAndValueFromPoptions(pn)
	local poptions= GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred")
	local speed= nil
	local mode= nil
	if poptions:AverageScrollBPM() > 0 then
		mode= "a"
		speed= math.round(poptions:AverageScrollBPM())
	elseif poptions:MaxScrollBPM() > 0 then
		mode= "m"
		speed= math.round(poptions:MaxScrollBPM())
	elseif poptions:TimeSpacing() > 0 then
		mode= "C"
		speed= math.round(poptions:ScrollBPM())
	else
		mode= "x"
		speed= math.round(poptions:ScrollSpeed() * 100)
	end
	return speed, mode
end

function ArbitrarySpeedMods()
	-- If players are allowed to join while this option row is active, problems will probably occur.
	local increment= get_speed_increment()
	local inc_large= get_speed_inc_large()
	local ret= {
		Name= "Speed",
		LayoutType= "ShowAllInRow",
		SelectType= "SelectMultiple",
		OneChoiceForAllPlayers= false,
		LoadSelections= function(self, list, pn)
			-- The first values display the current status of the speed mod.
			if pn == PLAYER_1 or self.NumPlayers == 1 then
				list[1]= true
			else
				list[2]= true
			end
		end,
		SaveSelections= function(self, list, pn)
		end,
		NotifyOfSelection= function(self, pn, choice)
			-- Adjust for the status elements
			local real_choice= choice - self.NumPlayers
			-- return true even though we didn't actually change anything so that
			-- the underlines will stay correct.
			if real_choice < 1 then return true end
			local val= self.CurValues[pn]
			if real_choice < 5 then
				local incs= {inc_large, increment, -increment, -inc_large}
				local new_val= val.speed + incs[real_choice]
				if new_val > 0 then
					val.speed= math.round(new_val)
				end
			elseif real_choice >= 5 then
				val.mode= ({"x", "a", "m", "C"})[real_choice - 4]
			end
			self:GenChoices()
			MESSAGEMAN:Broadcast("SpeedChoiceChanged", {pn= pn, mode= val.mode, speed= val.speed})
			
			local poptions= GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred")
			-- modify stage, song and current too so this will work in edit mode.
			local stoptions= GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Stage")
			local soptions= GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Song")
			local coptions= GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Current")
			if val.mode == "x" then
				local speed= val.speed / 100
				poptions:XMod(speed)
				stoptions:XMod(speed)
				soptions:XMod(speed)
				coptions:XMod(speed)
			elseif val.mode == "C" then
				poptions:CMod(val.speed)
				stoptions:CMod(val.speed)
				soptions:CMod(val.speed)
				coptions:CMod(val.speed)
			elseif val.mode == "m" then
				poptions:MMod(val.speed)
				stoptions:MMod(val.speed)
				soptions:MMod(val.speed)
				coptions:MMod(val.speed)
			else
				poptions:AMod(val.speed)
				stoptions:AMod(val.speed)
				soptions:AMod(val.speed)
				coptions:AMod(val.speed)
			end
			
			return true
		end,
		GenChoices= function(self)
			-- We can't show different options to each player, so compromise by
			-- only showing the xmod increments if one player is in that mode.
			local show_x_incs= false
			for pn, val in pairs(self.CurValues) do
				if val.mode == "x" then
					show_x_incs= true
				end
			end
			local big_inc= inc_large
			local small_inc= increment
			if show_x_incs then
				big_inc= tostring(big_inc / 100)
				small_inc= tostring(small_inc / 100)
			else
				big_inc= tostring(big_inc)
				small_inc= tostring(small_inc)
			end
			self.Choices= {
				"+" .. big_inc, "+" .. small_inc, "-" .. small_inc, "-" .. big_inc,
				THEME:GetString("OptionNames", "SpeedX"), 
                THEME:GetString("OptionNames", "SpeedA"),
                THEME:GetString("OptionNames", "SpeedM"),
                THEME:GetString("OptionNames", "SpeedC")}
			-- Insert the status element for P2 first so it will be second
			for i, pn in ipairs({PLAYER_2, PLAYER_1}) do
				local val= self.CurValues[pn]
				if val then
					if val.mode == "x" then
						table.insert(self.Choices, 1, (val.speed/100) .. "x")
					else
						table.insert(self.Choices, 1, val.mode .. val.speed)
					end
				end
			end
		end,
		CurValues= {}, -- for easy tracking of what speed the player wants
		NumPlayers= 0 -- for ease when adjusting for the status elements.
	}
	for i, pn in ipairs(GAMESTATE:GetEnabledPlayers()) do
		if GAMESTATE:IsHumanPlayer(pn) then
			local speed, mode= GetSpeedModeAndValueFromPoptions(pn)
			ret.CurValues[pn]= {mode= mode, speed= speed}
			ret.NumPlayers= ret.NumPlayers + 1
		end
	end
	ret:GenChoices()
	return ret
end

--[[
CustomSpeedMods (c) 2013 StepMania team.

Use freely, so long as this notice and the above documentation remains.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Previous version was copyright © 2008-2012 AJ Kelly/KKI Labs.
]]
