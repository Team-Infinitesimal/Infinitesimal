return function(Prefs)
	for pn = 1,2 do
		if FILEMAN:DoesFileExist("Save/MachineProfile/OutFoxPrefsForPlayerp"..pn.."/OutFoxPrefs.ini") then 
			local Createfile = RageFileUtil.CreateRageFile()
			Createfile:Open("Save/MachineProfile/OutFoxPrefsForPlayerp"..pn.."/OutFoxPrefs.ini", 2)
			Createfile:Write("")
			Createfile:Close()
			Createfile:destroy()
		end
	end
	for k,v in pairs(Prefs) do
		if not LoadModule("Config.Exists.lua")(k,"Save/OutFoxPrefs.ini") and not v.UserPref then
			for i,v2 in ipairs(v.Values) do
				if tostring(v2) == tostring(v.Default) then LoadModule("Config.save.lua")(k,tostring(v.Values[i]),"Save/OutFoxPrefs.ini") end
			end
		end
		_G[k] = function()
			return {
				Name = k,
				LayoutType = v.OneInRow and "ShowOneInRow" or "ShowAllInRow",
				SelectType = v.SelectMultiple and "SelectMultiple" or "SelectOne",
				OneChoiceForAllPlayers = (not v.UserPref),
				ExportOnChange = false,
				Choices = v.Choices,
				Values = v.Values,
				LoadSelections = function(self, list, pn)
					local reset = false
					if v.LoadFunction then
						v.LoadFunction(self, list, pn)
						return
					end
					if getenv(k.."env"..pn) then reset = true setenv(k.."env"..pn,false) end
					local Location = "Save/OutFoxPrefs.ini"
					if v.UserPref then Location = PROFILEMAN:GetProfileDir(string.sub(pn,-1)-1).."/OutFoxPrefs.ini" end
					if not reset and LoadModule("Config.Exists.lua")(k,Location) then
						local CurPref = LoadModule("Config.Load.lua")(k,Location)
						for i,v2 in ipairs(self.Values) do
							if tostring(v2) == tostring(CurPref) then list[i] = true return end
						end
					elseif not reset and getenv(k.."Machinetemp"..pn) ~= nil then
						local CurPref = getenv(k.."Machinetemp"..pn)
						for i,v2 in ipairs(self.Values) do
							if tostring(v2) == tostring(CurPref) then list[i] = true return end
						end
					else
						-- If multiple items, then go through all options.
						if v.SelectMultiple then
							for i,v2 in ipairs(self.Values) do
								if LoadModule("Config.Load.lua")(self.Values[i],Location) then list[i] = true end
							end
							return
						else
							for i,v2 in ipairs(self.Values) do
								if tostring(v2) == tostring(v.Default) then list[i] = true return end
							end
						end
					end
					list[1] = true
				end,
				NotifyOfSelection= function(self, pn, choice)
					if v.GenForOther then 
						setenv(k,choice)
						local Location = "Save/OutFoxPrefs.ini"
						if v.GenForUserPref then Location = CheckIfUserOrMachineProfile(string.sub(pn,-1)-1).."/OutFoxPrefs.ini" end
						local CurPref = LoadModule("Config.Load.lua")(v.GenForOther[1],Location)
						CurPref = string.gsub(tostring(CurPref), " ", "")
						local Reset = {true,true}
						for i,v2 in ipairs(_G[v.GenForOther[1]]().Choices) do 
							_G[v.GenForOther[1]]().Choices[i] = nil -- first empty table
							_G[v.GenForOther[1]]().Values[i] = nil -- first empty table
						end
						for i,v2 in ipairs(v.GenForOther[2]("Choice")) do
							_G[v.GenForOther[1]]().Choices[i] = v2 -- then fill table
							if v2 == CurPref then Reset[tonumber(string.sub(pn,-1))] = false
						end end 
						for i,v2 in ipairs(v.GenForOther[2]("Value")) do
							_G[v.GenForOther[1]]().Values[i] = v2 -- then fill table
						end
						setenv(v.GenForOther[1].."env"..pn,Reset[tonumber(string.sub(pn,-1))])
						MESSAGEMAN:Broadcast(v.GenForOther[1], {pn=pn,choice=choice})
						setenv(v.GenForOther[1].."env"..pn,Reset[tonumber(string.sub(pn,-1))]) -- need to double this because bug.
					end
					if v.NotifyOfSelection then
						v.NotifyOfSelection(self, pn, choice)
					end
					MESSAGEMAN:Broadcast(k.."Change", {pn=pn,choice=choice,choicename=self.Values[choice]})
				end,
				SaveSelections = function(self, list, pn)
					local Location = "Save/OutFoxPrefs.ini"
					if v.SaveFunction then
						v.SaveFunction(self, list, pn)
						return
					end
					if v.UserPref then 
							Location = CheckIfUserOrMachineProfile(string.sub(pn,-1)-1).."/OutFoxPrefs.ini"
					end
					-- If multiple items, then go through all options.
					if v.SelectMultiple then
						for i,_ in ipairs(self.Values) do
							if list[i] == true then
								LoadModule("Config.save.lua")(self.Values[i],tostring(true),Location)
								setenv(self.Values[i].."Machinetemp"..pn,tostring(true))
							else
								LoadModule("Config.save.lua")(self.Values[i],tostring(false),Location)
								setenv(self.Values[i].."Machinetemp"..pn,tostring(false))
							end
						end
					else
						for i,_ in ipairs(self.Values) do
								if list[i] == true then LoadModule("Config.save.lua")(k,tostring(self.Values[i]),Location) setenv(k.."Machinetemp"..pn,self.Values[i]) end
						end
					end
				end,
				Reload = function() return "ReloadChanged_All" end,
				ReloadRowMessages= {k}
			}
		end
	end
end