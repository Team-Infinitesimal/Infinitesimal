local t = Def.ActorFrame {
	Def.ActorFrame {
		InitCommand=function(self)
			self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y - 20)
			:queuecommand("ZoomY")
		end,

		OffCommand=function(self)
			self:stoptweening()
			:easeoutexpo(0.5)
			:zoom(1.5):diffusealpha(0)
		end,

		ZoomYCommand=function(self)
			self:accelerate(3.4288)
			:zoom(0.96)
			:decelerate(3.4288)
			:zoom(1)
			:queuecommand("ZoomY")
		end,

		LoadActor(THEME:GetPathG("", "Logo/Parts"))..{
			InitCommand=function(self)
				self:zoom(0.8)
			end
		},

		Def.Sprite {
			Texture=THEME:GetPathG("", "Logo/Logo"),
			InitCommand=function(self)
				self:diffusealpha(0)
				:zoom(0.8)
				:queuecommand("Pulse")
			end,
			PulseCommand=function(self)
				self:sleep(3.4288)
				:diffusealpha(0.5)
				:zoom(0.8)
				:decelerate(1.7144)
				:zoom(1)
				:diffusealpha(0)
				:sleep(1.7144)
				:queuecommand("Pulse")
			end,
		},

		Def.Sprite {
			Texture=THEME:GetPathG("", "Logo/BlurLogo"),
			InitCommand=function(self)
				self:zoom(0.83)
				:diffusealpha(0)
				:queuecommand("Flash")
			end,
			FlashCommand=function(self)
				self:accelerate(3.4288)
				:diffusealpha(0.8)
				:decelerate(3.4288)
				:diffusealpha(0)
				:queuecommand("Flash")
			end,
			OffCommand=function(self)
				self:stoptweening()
				:diffusealpha(1)
				:easeoutexpo(1)
				:zoom(2):diffusealpha(0)
			end,
		}
	},

	Def.ActorFrame {
		InitCommand=function(self)
			self:xy(SCREEN_CENTER_X, 20)
		end,

		OffCommand=function(self)
			self:stoptweening():easeoutexpo(1):xy(SCREEN_CENTER_X, -80)
		end,

		Def.BitmapText {
			Font="Montserrat normal 20px",
			InitCommand=function(self)
				local InstalledSongs, Groups, InstalledCourses = 0
				if SONGMAN:GetRandomSong() then
					InstalledSongs, Groups, InstalledCourses =
						SONGMAN:GetNumSongs() + SONGMAN:GetNumAdditionalSongs() + SONGMAN:GetNumUnlockedSongs(),
						SONGMAN:GetNumSongGroups(),
						SONGMAN:GetNumCourses() + SONGMAN:GetNumAdditionalCourses()
				else
					return
				end

				self:settextf(THEME:GetString("ScreenTitleMenu", "%i Songs (%i Groups), %i Courses"), InstalledSongs, Groups, InstalledCourses)
			end
		},

		Def.BitmapText {
			Font="Montserrat normal 20px",
			Text=string.format("OutFox %s - %s", ProductVersion(), VersionDate()),
			AltText="OutFox",
			InitCommand=function(self) self:y(20) end
		}
	}
}

if not IsHome() then
    t[#t+1] = Def.ActorFrame {
        LoadActor(THEME:GetPathG("", "PressCenterStep")) .. {
            InitCommand=function(self) self:xy(SCREEN_CENTER_X - SCREEN_WIDTH * 0.3, SCREEN_HEIGHT * 0.75) end,
            OffCommand=function(self) self:stoptweening():easeoutexpo(0.25):zoom(2):diffusealpha(0) end,
        },
        
        LoadActor(THEME:GetPathG("", "PressCenterStep")) .. {
            InitCommand=function(self) self:xy(SCREEN_CENTER_X + SCREEN_WIDTH * 0.3, SCREEN_HEIGHT * 0.75) end,
            OffCommand=function(self) self:stoptweening():easeoutexpo(0.25):zoom(2):diffusealpha(0) end,
        }
    }
end

return t