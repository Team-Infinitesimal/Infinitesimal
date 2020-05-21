return Def.ActorFrame{

		--Song background. ONLY IF THERE IS NO BGA!
		Def.Sprite{
			InitCommand=cmd(x,_screen.cx;y,_screen.cy-30;diffusealpha,0);
			CurrentSongChangedMessageCommand=function(self)
				self:stoptweening():diffusealpha(0);
				if GAMESTATE:GetCurrentSong() then
					if GAMESTATE:GetCurrentSong():GetPreviewVidPath() == nil then
						self:sleep(.4):queuecommand("Load2");
					end;
				end;
			end;
			Load2Command=function(self)
				local bg = GetSongBackground(true)
				if bg then
					--SCREENMAN:SystemMessage(bg)
					self:Load(bg):zoomto(384,232);
				else
					local randomBGAs = FILEMAN:GetDirListing("/RandomMovies/SD/")
					if #randomBGAs > 1 then
						local bga = randomBGAs[math.random(1,#randomBGAs)]
						--SCREENMAN:SystemMessage(bga);
						self:Load("/RandomMovies/SD/"..bga);
					else
						--SCREENMAN:SystemMessage("/RandomMovies/SD/"..randomBGAs[1]);
						self:Load("/RandomMovies/SD/"..randomBGAs[1])
					end;
				end;
				self:zoomto(384,232):linear(.2):diffusealpha(1);
			end;
		};
		Def.Sprite{
			--Name = "BGAPreview";
			InitCommand=cmd(x,_screen.cx;y,_screen.cy-30);
			CurrentSongChangedMessageCommand=cmd(stoptweening;Load,nil;sleep,.4;queuecommand,"PlayVid2");
			PlayVid2Command=function(self)
				--self:Load(nil);
				if streamSafeMode and has_value(STREAM_UNSAFE_AUDIO, GAMESTATE:GetCurrentSong():GetDisplayFullTitle() .. "||" .. GAMESTATE:GetCurrentSong():GetDisplayArtist()) then
					self:diffusealpha(0);
					self:Load(nil);
					return;
				else
					--local song = GAMESTATE:GetCurrentSong()
					path = GetBGAPreviewPath("PREVIEWVID");
					--path = song:GetBannerPath();
					self:Load(path);
				end;
				self:diffusealpha(0);
				self:zoomto(384,232);
				self:linear(0.2);
				if path == "/Backgrounds/Title.mp4" then
					self:diffusealpha(0.5);
				else
					self:diffusealpha(1);
				end
			end;
		};
		--TODO: Remove this when hiding songs works correctly!
		--[[Def.ActorFrame{
			Condition=false;
			InitCommand=cmd(x,_screen.cx;y,_screen.cy-30;visible,false);
			CurrentSongChangedMessageCommand=function(self)
				if streamSafeMode and has_value(STREAM_UNSAFE_AUDIO, GAMESTATE:GetCurrentSong():GetDisplayFullTitle() .. "||" .. GAMESTATE:GetCurrentSong():GetDisplayArtist()) then
					self:visible(true);
					self:sleep(.8):queuecommand("MuteAudio");
				else
					self:visible(false);
				end;
			end;
			MuteAudioCommand=function(self)
				--SOUND:DimMusic(0,65536);
				SOUND:StopMusic();
				--SOUND:PlayOnce(THEME:GetPathS("","ScreenSelectMusic StreamWarning"));
			end;
			LoadActor(THEME:GetPathG("","noise"))..{
				InitCommand=cmd(texcoordvelocity,0,8;customtexturerect,0,0,1,1;cropto,384,232;diffuse,color(".5,.5,.5,1"));
			};
			LoadActor("temp_contentid")..{
				InitCommand=cmd(zoom,.5;diffuse,color(".5,.5,.5,1"));

			};
			LoadFont("Common Normal")..{
				Text=THEME:GetString("ScreenSelectMusic","StreamUnsafe");
				InitCommand=cmd(wrapwidthpixels,300;);
			};
		};]]

		--BPM DISPLAY
		LoadFont("monsterrat semibold/_montserrat semibold 40px")..{
			InitCommand=cmd(horizalign,left;x,_screen.cx-115;y,_screen.cy+55.75;zoom,0.6;skewx,-0.2);
			CurrentSongChangedMessageCommand=function(self)
				self:settext("BPM:");
				(cmd(finishtweening;zoomy,0;zoomx,0.5;decelerate,0.33;zoom,0.2;)) (self)
			end;
		};

		-- CURRENT SONG NAME
		LoadFont("montserrat/_montserrat 40px")..{
			InitCommand=cmd(uppercase,true;x,_screen.cx;y,_screen.cy-171;zoom,0.45;maxwidth,(_screen.w/0.9);skewx,-0.1);
			CurrentSongChangedMessageCommand=function(self)
				local song = GAMESTATE:GetCurrentSong()
				if song then
					self:settext(song:GetDisplayFullTitle());
					self:finishtweening();

					self:diffusealpha(0);
					if isExtraStage then
						if extraStageSong == song then
							self:diffuseshift():effectcolor1(Color("Red")):effectcolor2(Color("White")):effectperiod(1);
						else
							self:effectcolor1(Color("White"))
							--self:diffusebottomedge(color("1,1,1,0"))
						end;
					end;
					self:x(_screen.cx+75);self:sleep(0.25);self:decelerate(0.75);self:x(_screen.cx);self:diffusealpha(1);
				else
					self:stoptweening();self:linear(0.25);self:diffusealpha(0);
				end;
			end;
		};
		-- CURRENT SONG ARTIST
		LoadFont("montserrat semibold/_montserrat semibold 40px")..{
			InitCommand=cmd(uppercase,true;x,_screen.cx;y,_screen.cy-187;zoom,0.2;maxwidth,(_screen.w*2);skewx,-0.1);
			CurrentSongChangedMessageCommand=function(self)
			local song = GAMESTATE:GetCurrentSong();
				if song then
					self:settext(song:GetDisplayArtist());
					self:finishtweening();self:diffusealpha(0);
					self:x(_screen.cx-75);self:sleep(0.25);self:decelerate(0.75);self:x(_screen.cx);self:diffusealpha(1);
				else
					self:stoptweening();self:linear(0.25);self:diffusealpha(0);
				end;
			end;


		};
};
