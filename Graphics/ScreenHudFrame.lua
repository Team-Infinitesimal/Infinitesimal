local t = Def.ActorFrame {

    Def.Sprite {
		Texture="ScreenHudTop",
        InitCommand=function(self)
            self:vertalign(top)
			:zoom(0.835)
            :xy(SCREEN_CENTER_X,SCREEN_TOP-100)
        end,
        OnCommand=function(self)
			self:sleep(0.25)
            :decelerate(0.75)
            :y(SCREEN_TOP)
        end
    },

    Def.Sprite {
		Texture="ScreenHudBottom",
        InitCommand=function(self)
            self:vertalign(bottom)
			:zoom(0.835)
            :xy(SCREEN_CENTER_X,SCREEN_BOTTOM+100)
        end,
        OnCommand=function(self)
			self:sleep(0.25)
            :decelerate(0.75)
            :y(SCREEN_BOTTOM)
        end
    }

}

-- Avatars
for pn in ivalues(PlayerNumber) do
	
	t[#t+1] = Def.ActorFrame {
	
		Def.Sprite {
			Texture="EmptyAvatarSlot",
			InitCommand=function(self)
				self:zoom(0.26)
				:x(pn == PLAYER_1 and SCREEN_CENTER_X-138 or SCREEN_CENTER_X+138)
				:y(SCREEN_BOTTOM + 80)
				:rotationy(pn == PLAYER_1 and 0 or 180)
				:queuecommand("On")
				:sleep(0.25)
				:decelerate(0.75)
				:y(SCREEN_BOTTOM-28)
			end,

			PlayerJoinedMessageCommand=function(self)self:queuecommand("On")end,
			PlayerUnjoinedMessageCommand=function(self)self:queuecommand("On")end,
			ReloadedProfilesMessageCommand=function(self)self:queuecommand("On")end,

			OnCommand=function(self)
				self:visible(GAMESTATE:IsHumanPlayer(pn))
			end
		},

		Def.Sprite {
			Texture="AvatarMask",
			InitCommand=function(self)
				self:zoom(0.26)
				:x(pn == PLAYER_1 and (SCREEN_CENTER_X-138) or (SCREEN_CENTER_X+138))
				:y(SCREEN_BOTTOM + 80)
				:rotationy(pn == PLAYER_1 and 0 or 180)
				:MaskSource()
				:queuecommand("On")
				:sleep(0.25)
				:decelerate(0.75)
				:y(SCREEN_BOTTOM-28)
			end,

			PlayerJoinedMessageCommand=function(self)self:queuecommand("On")end,
			PlayerUnjoinedMessageCommand=function(self)self:queuecommand("On")end,
			ReloadedProfilesMessageCommand=function(self)self:queuecommand("On")end,

			OnCommand=function(self)
				self:visible(GAMESTATE:IsHumanPlayer(pn))
			end
		},

		Def.Sprite {
			Texture=GetPlayerAvatar(pn),
			InitCommand=function(self)
				self:scaletofit(0,0,130,130)
				:x(pn == PLAYER_1 and (SCREEN_CENTER_X-138) or (SCREEN_CENTER_X+138))
				:y(SCREEN_BOTTOM + 80)
				:MaskDest()
				:queuecommand("On")
				:sleep(0.25)
				:decelerate(0.75)
				:y(SCREEN_BOTTOM-28)
			end,

			PlayerJoinedMessageCommand=function(self)self:queuecommand("On")end,
			PlayerUnjoinedMessageCommand=function(self)self:queuecommand("On")end,
			ReloadedProfilesMessageCommand=function(self)self:queuecommand("On")end,

			OnCommand=function(self)
				self:Load(GetPlayerAvatar(pn))
				:visible(GAMESTATE:IsHumanPlayer(pn))
			end
		},

		LoadFont("Montserrat normal 40px")..{
			InitCommand=function(self)
				self:y(SCREEN_BOTTOM+80)
				:zoom(0.3)
				:diffuse(color("1,1,1,1"))
				:shadowlength(1)
				:horizalign(pn == PLAYER_1 and right or left)
				:x(pn == PLAYER_1 and SCREEN_CENTER_X-80 or SCREEN_CENTER_X+80)
				:queuecommand("On")
				:sleep(0.25)
				:decelerate(0.75)
				:y(SCREEN_BOTTOM-16)
			end,

			PlayerJoinedMessageCommand=function(self)self:queuecommand("On")end,
			PlayerUnjoinedMessageCommand=function(self)self:queuecommand("On")end,
			ReloadedProfilesMessageCommand=function(self)self:queuecommand("On")end,

			-- Update when a player joins
			OnCommand=function(self)
				if GAMESTATE:IsHumanPlayer(pn) then
					GAMESTATE:LoadProfiles()
					self:settext(PROFILEMAN:GetProfile(pn):GetDisplayName())
				end

				self:visible(GAMESTATE:IsHumanPlayer(pn))
			end
		}
	
	}

end

return t
