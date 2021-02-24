local superbs, perfects, greats, goods, bads, misses, accuracy, score
local promode = PREFSMAN:GetPreference("AllowW1") == 'AllowW1_Everywhere' and true or false
local lifeState = "Pass"

--[[
if getenv(pname(player).."Failed") == true then
    lifeState = "Fail"
else
    lifeState = "Pass"
end;
]]--

local t = Def.ActorFrame {
	
	LoadActor(THEME:GetPathG("","ScorePanel"))..{
		InitCommand=function(self)
			self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y+55)
			:zoom(0.5)
			:diffusealpha(0)
		end,

		SongChosenMessageCommand=function(self)
			self:stoptweening()
			:decelerate(0.25)
			:y(SCREEN_CENTER_Y+120)
			:zoom(0.65)
			:diffusealpha(1)
		end,

		SongUnchosenMessageCommand=function(self)
			self:stoptweening()
			:decelerate(0.2)
			:y(SCREEN_CENTER_Y+55)
			:zoom(0.5)
			:diffusealpha(0)
		end
	}
}

for pn in ivalues(PlayerNumber) do

	t[#t+1] = Def.ActorFrame {
		Def.Sprite {
			InitCommand=function(self)
				self:xy(SCREEN_CENTER_X+(pn == PLAYER_1 and -150 or 150), SCREEN_CENTER_Y+55)
				:zoom(0.1):diffusealpha(0)
			end,
			
			SongChosenMessageCommand=function(self)
				if GAMESTATE:IsHumanPlayer(pn) then
					self:stoptweening():decelerate(0.25)
					:xy(SCREEN_CENTER_X+(pn==PLAYER_1 and -198 or 200), SCREEN_CENTER_Y+120)
					:zoom(0.2):diffusealpha(1):playcommand("Update")
				end
			end,
			
			SongUnchosenMessageCommand=function(self)
				self:stoptweening():decelerate(0.2)
				:xy(SCREEN_CENTER_X+(pn == PLAYER_1 and -150 or 150), SCREEN_CENTER_Y+55)
				:zoom(0.1):diffusealpha(0)
			end,
			
			CurrentStepsP1ChangedMessageCommand=function(self)self:playcommand("Update")end,
			CurrentStepsP2ChangedMessageCommand=function(self)self:playcommand("Update")end,
			
			UpdateCommand=function(self)
				if GAMESTATE:IsHumanPlayer(pn) and PROFILEMAN:IsPersistentProfile(pn) then
					playercard = PROFILEMAN:GetProfile(pn)
					currentsong = GAMESTATE:GetCurrentSong()
					playersteps = GAMESTATE:GetCurrentSteps(pn)
					
					if playercard and currentsong and playersteps then
						playercardlist = playercard:GetHighScoreList(currentsong,playersteps)
						playerscores = playercardlist:GetHighScores()
						
						if playerscores[1] ~= nil then
							superbs 	=	playerscores[1]:GetTapNoteScore("TapNoteScore_W1")
							perfects 	= 	playerscores[1]:GetTapNoteScore("TapNoteScore_W2")

							if PREFSMAN:GetPreference("AllowW1") == 'AllowW1_Never' then
								perfects = 	perfects + playerscores[1]:GetTapNoteScore("TapNoteScore_CheckpointHit")
							else
								superbs = 	superbs + playerscores[1]:GetTapNoteScore("TapNoteScore_CheckpointHit")
							end;

							greats 		= 	playerscores[1]:GetTapNoteScore("TapNoteScore_W3")
							goods 		= 	playerscores[1]:GetTapNoteScore("TapNoteScore_W4")
							bads 		= 	playerscores[1]:GetTapNoteScore("TapNoteScore_W5")
							misses 		= 	playerscores[1]:GetTapNoteScore("TapNoteScore_Miss") +
											playerscores[1]:GetTapNoteScore("TapNoteScore_CheckpointMiss")

							accuracy 	=	round(playerscores[1]:GetPercentDP()*100, 2)
							
							self:diffusealpha(1)
							
							local gradeletter = "F"
							if misses == 0 then
								if bads == 0 and goods == 0 then
									if greats == 0 then
										gradeletter = promode and (perfects == 0 and "3S" or "2S") or "3S"
									else
										gradeletter = "2S"
									end
								else
									gradeletter = "1S"
								end
							else
								if accuracy >= 80 then
									gradeletter = "A"
								elseif accuracy >= 70 then
									gradeletter = "B"
								elseif accuracy >= 60 then
									gradeletter = "C"
								elseif accuracy >= 50 then
									gradeletter = "D"
								end
							end
							
							self:Load(THEME:GetPathG("","LetterGrades/"..lifeState..gradeletter))
						else
							self:diffusealpha(0)
						end
					end
				else
					self:diffusealpha(0)
				end
			end
		},
		
		LoadFont("montserrat/_montserrat 40px")..{
			InitCommand=function(self)
				self:xy(SCREEN_CENTER_X+(pn==PLAYER_1 and -100 or 100), SCREEN_CENTER_Y+30)
				:horizalign(pn==PLAYER_1 and left or right)
				:zoom(0.2):diffusecolor(0,0,0,0):maxwidth(1000)
			end,
			
			SongChosenMessageCommand=function(self)
				if GAMESTATE:IsHumanPlayer(pn) then
					self:stoptweening():decelerate(0.25)
					:xy(SCREEN_CENTER_X+(pn==PLAYER_1 and -135 or 135), SCREEN_CENTER_Y+95)
					:zoom(0.35):diffusealpha(1):playcommand("Update")
				end
			end,
			
			SongUnchosenMessageCommand=function(self)
				self:stoptweening():decelerate(0.1)
				:xy(SCREEN_CENTER_X+(pn==PLAYER_1 and -100 or 100), SCREEN_CENTER_Y+30)
				:zoom(0.2):diffusealpha(0)
			end,
			
			CurrentStepsP1ChangedMessageCommand=function(self)self:playcommand("Update")end,
			CurrentStepsP2ChangedMessageCommand=function(self)self:playcommand("Update")end,
			
			UpdateCommand=function(self)
				if GAMESTATE:IsHumanPlayer(pn) and PROFILEMAN:IsPersistentProfile(pn) then
					playercard = PROFILEMAN:GetProfile(pn)
					currentsong = GAMESTATE:GetCurrentSong()
					playersteps = GAMESTATE:GetCurrentSteps(pn)
					
					if playercard and currentsong and playersteps then
						playercardlist = playercard:GetHighScoreList(currentsong,playersteps)
						playerscores = playercardlist:GetHighScores()
						
						if playerscores[1] ~= nil then
							accuracy = round(playerscores[1]:GetPercentDP()*100, 2)
							
							if accuracy == nil then
								self:settext("")
							else
								self:settext(accuracy.."%")
							end;
						else
							self:settext("")
						end;
					end;
				else
					self:settext("")
				end
			end
		},
		
		LoadFont("montserrat/_montserrat 40px")..{
			InitCommand=function(self)
				self:xy(SCREEN_CENTER_X+(pn==PLAYER_1 and -100 or 100), SCREEN_CENTER_Y+45)
				:horizalign(pn==PLAYER_1 and left or right)
				:zoom(0.2):diffusecolor(0,0,0,0):maxwidth(1000)
			end,
			
			SongChosenMessageCommand=function(self)
				if GAMESTATE:IsHumanPlayer(pn) then
					self:stoptweening():decelerate(0.25)
					:xy(SCREEN_CENTER_X+(pn==PLAYER_1 and -135 or 135), SCREEN_CENTER_Y+110)
					:zoom(0.35):diffusealpha(1):playcommand("Update")
				end
			end,
			
			SongUnchosenMessageCommand=function(self)
				self:stoptweening():decelerate(0.1)
				:xy(SCREEN_CENTER_X+(pn==PLAYER_1 and -100 or 100), SCREEN_CENTER_Y+45)
				:zoom(0.2):diffusealpha(0)
			end,
			
			CurrentStepsP1ChangedMessageCommand=function(self)self:playcommand("Update")end,
			CurrentStepsP2ChangedMessageCommand=function(self)self:playcommand("Update")end,
			
			UpdateCommand=function(self)
				if GAMESTATE:IsHumanPlayer(pn) and PROFILEMAN:IsPersistentProfile(pn) then
					playercard = PROFILEMAN:GetProfile(pn)
					currentsong = GAMESTATE:GetCurrentSong()
					playersteps = GAMESTATE:GetCurrentSteps(pn)
					
					if playercard and currentsong and playersteps then
						playercardlist = playercard:GetHighScoreList(currentsong,playersteps)
						playerscores = playercardlist:GetHighScores()
						
						if playerscores[1] ~= nil then
							score = playerscores[1]:GetScore()
							
							self:settext(score)
						else
							self:settext("No Score")
						end;
					end;
				else
					self:settext("")
				end
			end
		}
	}
end

return t
