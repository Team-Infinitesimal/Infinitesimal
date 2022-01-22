local t = Def.ActorFrame {}

-- The column thing
t[#t+1] = Def.Quad {
    InitCommand=function(self)
        self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):valign(0.5)
        :zoomx(255)
        :diffuse(0,0,0,0.75)
        :zoomy(0)
        :decelerate(0.5)
        :zoomy(SCREEN_HEIGHT)
    end,
	OffCommand=function(self)
		self:stoptweening():decelerate(0.5):zoomy(0)
	end
}

for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
    t[#t+1] = Def.ActorFrame {
        LoadActor("../ModIcons", pn) .. {
            InitCommand=function(self)
                self:xy(pn == PLAYER_2 and SCREEN_RIGHT + 40 * 2 or -40 * 2, 160)
                :easeoutexpo(1):x(pn == PLAYER_2 and SCREEN_RIGHT - 40 or 40)
            end,
			OffCommand=function(self)
                self:stoptweening():easeoutexpo(1):x(pn == PLAYER_2 and SCREEN_RIGHT + 40 * 2 or -40 * 2)
            end
        },
		
		Def.ActorFrame {
			InitCommand=function(self)
				self:xy(SCREEN_CENTER_X, -SCREEN_CENTER_Y)
				:easeoutexpo(1):y(SCREEN_CENTER_Y - 10)
			end,
			OffCommand=function(self)
				self:stoptweening():easeoutexpo(1)
				:y(-SCREEN_CENTER_Y - 100)
			end,
			
			StepsChosenMessageCommand=function(self, params)
				if params.Player == pn then
					self:stoptweening():easeoutexpo(0.5)
					:x(SCREEN_CENTER_X + (pn == PLAYER_2 and 300 or -300))
				end
			end,
			StepsUnchosenMessageCommand=function(self)
				self:stoptweening():easeoutexpo(0.5):x(SCREEN_CENTER_X)
			end,
			SongUnchosenMessageCommand=function(self)
				self:stoptweening():easeoutexpo(0.5):x(SCREEN_CENTER_X)
			end,
			
			Def.Quad {
				InitCommand=function(self)
					self:zoomto(128, 32):diffuse(Color.Black)
					
					if pn == PLAYER_2 then
						self:diffuserightedge(0, 0, 0, 0)
					else
						self:diffuseleftedge(0, 0, 0, 0)
					end
				end
			},
			
			Def.Sprite {
				Texture=THEME:GetPathG("", "UI/Ready" .. ToEnumShortString(pn)),
				InitCommand=function(self) self:y(1) end
			}
		}
    }
end

t[#t+1] = Def.ActorFrame {
    Def.ActorFrame {
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X, -SCREEN_CENTER_Y):zoom(0.5)
            :easeoutexpo(1):y(SCREEN_CENTER_Y)
        end,
		OffCommand=function(self)
            self:stoptweening():easeoutexpo(1):y(-SCREEN_CENTER_Y)
        end,
        SongChosenMessageCommand=function(self)
            self:stoptweening():easeoutexpo(0.5):y(SCREEN_CENTER_Y + 95):zoom(1)
        end,
        SongUnchosenMessageCommand=function(self)
            self:stoptweening():easeoutexpo(0.25):y(SCREEN_CENTER_Y):zoom(0.5)
        end,

        Def.Sprite {
            Texture=THEME:GetPathG("", "DifficultyDisplay/InfoPanel"),
            InitCommand=function(self) self:y(85):zoom(0.75) end
        },

        LoadActor("ChartInfo")
    }
}

t[#t+1] = Def.ActorFrame {
    Def.ActorFrame {
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X, -SCREEN_CENTER_Y)
            :easeoutexpo(1):y(SCREEN_CENTER_Y)
        end,
		OffCommand=function(self)
            self:stoptweening():easeoutexpo(1):y(-SCREEN_CENTER_Y)
        end,

        SongChosenMessageCommand=function(self)
            self:stoptweening():easeoutexpo(0.5):y(SCREEN_CENTER_Y-40):zoom(0.9)
        end,
        SongUnchosenMessageCommand=function(self)
            self:stoptweening():easeoutexpo(0.5):y(SCREEN_CENTER_Y):zoom(1)
        end,

        LoadActor("ScoreDisplay") .. {
            InitCommand=function(self) self:y(-100) end
        },

        LoadActor("SongPreview") .. {
            InitCommand=function(self) self:y(-100) end
        },

        Def.ActorFrame {
            InitCommand=function(self) self:y(85) end,

            SongChosenMessageCommand=function(self)
                self:stoptweening():easeoutexpo(0.5):y(94):zoom(1.25)
            end,
            SongUnchosenMessageCommand=function(self)
                self:stoptweening():easeoutexpo(0.5):y(85):zoom(1)
            end,

            Def.Sprite {
                Texture=THEME:GetPathG("", "DifficultyDisplay/Bar"),
                InitCommand=function(self) self:zoom(1.2) end
            },

            LoadActor("ChartDisplay", 12)
        }
    }
}

return t
