--[[
/////////////////////
ScreenSelectGroup by Rhythm Lunatic
Drop-in usage:
1. Add ScreenSelectGroup overlay (this file) to your theme
2. Copy values from metrics into your theme.
3. If you don't need the secret group code, then don't add it to metrics. It should fall back correctly. (Secret group setting requires ThemePrefs too)
4. Comment out or change header, footer, etc
5. Move background code to ScreenSelectGroup background unless you need it here for some reason.
]]
-- Get screen handle so we can adjust the timer.
local ScreenSelectMusic;

-- SONG GROUPS
-- This is inside the overlay instead of GroupWheelUtil because as it turns out, SONGMAN:GetGroupNames isn't available on init
-- ////////////////////////////
local song_groups = SONGMAN:GetSongGroupNames();
--Remove the BasicModeGroup channel from the array, since we don't want anyone to be able to access it normally.
for k,v in pairs(song_groups) do
	if v == "BasicModeGroup" then
		table.remove(song_groups, k)
	end
end

function getVisibleSongGroups()
	if ReadPrefFromFile("UserPrefHiddenChannels") == "Enabled" then --If this is true, the group select will only display the groups you specify and you can access the hidden channel list.
		if all_channels_unlocked then --After they've entered the hidden channels code.
			return song_groups; --Return all the channels.
		else
			return _G.predefined_group_list; --Return the predefined channels.
		end;
	else
		return song_groups; --If false, all channels are unlocked.
	end;
end

local info_set = getVisibleSongGroups();

-- ITEM SCROLLER
-- /////////////////////////////////
local scroller = setmetatable({disable_wrapping= false}, item_scroller_mt)
local numWheelItems = THEME:GetMetric("ScreenSelectGroup", "NumWheelItems")

--Item scroller starts at 0, duh.
local currentItemIndex = 0;

-- Scroller function thingy
local item_mt= {
  __index= {
	-- create_actors must return an actor.  The name field is a convenience.
	create_actors= function(self, params)
	  self.name= params.name
		return Def.ActorFrame{
			InitCommand= function(subself)
				-- Setting self.container to point to the actor gives a convenient
				-- handle for manipulating the actor.
		  		self.container= subself
		  		subself:SetDrawByZPosition(true);
		  		--subself:zoom(.75);
			end;

			Def.BitmapText{
				Name= "text",
				Font= "Common Normal",
				InitCommand=cmd(addy,100);
			};

			Def.Sprite{
				Name="banner";
			};
		};
	end,
	-- item_index is the index in the list, ranging from 1 to num_items.
	-- is_focus is only useful if the disable_wrapping flag in the scroller is
	-- set to false.
	transform= function(self, item_index, num_items, is_focus)
		local offsetFromCenter = item_index-math.floor(numWheelItems/2)
		--PrimeWheel(self.container,offsetFromCenter,item_index,numWheelItems)
		self.container:stoptweening();
		if math.abs(offsetFromCenter) < 4 then
			self.container:decelerate(.5);
			self.container:visible(true);
		else
			self.container:visible(false);
		end;
		self.container:x(offsetFromCenter*350)
		self.container:rotationy(offsetFromCenter*-45);
		self.container:zoom(math.cos(offsetFromCenter*math.pi/6)*.8)

		--[[if offsetFromCenter == 0 then
			self.container:diffuse(Color("Red"));
		else
			self.container:diffuse(Color("White"));
		end;]]
	end,
	-- info is one entry in the info set that is passed to the scroller.
	set= function(self, info)
		self.container:GetChild("text"):settext(info)
		local banner = SONGMAN:GetSongGroupBannerPath(info);
		if banner == "" then
			self.container:GetChild("banner"):Load(THEME:GetPathG("common","fallback banner.png"));
			self.container:GetChild("text"):visible(true);
  		else
  			self.container:GetChild("banner"):Load(banner);
  			self.container:GetChild("text"):visible(false);
		end;
	end,
	gettext=function(self)
		return self.container:GetChild("text"):gettext()
	end,
}}
--local info_set= {"fin", "tail", "gorg", "lilk", "zos", "mink", "aaa"}


-- INPUT HANDLER
-- /////////////////////////
local function GoToNextScreen()
	--Has no effect.
	--MenuTimer:pause()
	--SCREENMAN:SystemMessage(scroller:get_info_at_focus_pos());
	local currentGroup = scroller:get_info_at_focus_pos();
	local curItem = scroller:get_actor_item_at_focus_pos();
	--SCREENMAN:SystemMessage(ListActorChildren(curItem.container));
	curItem.container:GetChild("banner"):accelerate(.3):zoom(2):diffusealpha(0);
	ScreenSelectMusic:GetChild('MusicWheel'):SetOpenSection(currentGroup);
	SCREENMAN:GetTopScreen():PostScreenMessage( 'SM_SongChanged', 0.5 );
	SCREENMAN:set_input_redirected(PLAYER_1, false);
	SCREENMAN:set_input_redirected(PLAYER_2, false);
	MESSAGEMAN:Broadcast("StartSelectingSong");

end;

local isSelectingDifficulty = false;
local password;

local function inputs(event)

	local pn= event.PlayerNumber
	local button = event.button
	-- If the PlayerNumber isn't set, the button isn't mapped.  Ignore it.
	--Also we only want it to activate when they're NOT selecting the difficulty.
	if not pn then return end
	-- If it's a release, ignore it.
	if event.type == "InputEventType_Release" then return end

	if SCREENMAN:get_input_redirected(pn) then
		if button == "Center" or button == "Start" then
			GoToNextScreen()
		elseif button == "DownLeft" or button == "Left" then
			scroller:scroll_by_amount(-1);
			SOUND:PlayOnce(THEME:GetPathS("MusicWheel", "change"), true);
			MESSAGEMAN:Broadcast("PreviousGroup");
		elseif button == "DownRight" or button == "Right" then
			scroller:scroll_by_amount(1);
			SOUND:PlayOnce(THEME:GetPathS("MusicWheel", "change"), true);
			MESSAGEMAN:Broadcast("NextGroup");
		elseif button == "Back" then
			SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToPrevScreen");
		else
			--SCREENMAN:SystemMessage(button);
		end;

		if button == "MenuDown" then
			local groupName = scroller:get_info_at_focus_pos()
			if initialGroup then
				SCREENMAN:SystemMessage(groupName.." | "..initialGroup);
			else
				SCREENMAN:SystemMessage(groupName.." | No initial group.");
			end;
			--SCREENMAN:SystemMessage(groupName.." | "..SONGMAN:GetSongGroupBannerPath(groupName));
		end;

		if button == "MenuUp" then
			SCREENMAN:SystemMessage(tostring(ReadPrefFromFile("UserPrefHiddenChannels") == "Enabled"));
		end;

		if button == "UpLeft" or button == "UpRight" then

		end;
	else
		if button == "UpRight" or button == "UpLeft" then
			if ScreenSelectMusic:CanOpenOptionsList(pn) then --If options list isn't currently open
				if isSelectingDifficulty or inBasicMode then return end; --Don't want to open the group select if they're picking the difficulty.
				MESSAGEMAN:Broadcast("StartSelectingGroup");
				--SCREENMAN:SystemMessage("Group select opened.");
				--No need to check if both players are present... Probably.
				SCREENMAN:set_input_redirected(PLAYER_1, true);
				SCREENMAN:set_input_redirected(PLAYER_2, true);

				local musicwheel = SCREENMAN:GetTopScreen():GetChild('MusicWheel');
				musicwheel:Move(0); --Work around a StepMania bug
			end
		end;
	end;
end;

-- ACTORFRAMES FOR BOTH
-- ////////////////////////
local t = Def.ActorFrame{
	InitCommand=cmd(diffusealpha,0);

	OnCommand=function(self)
		ScreenSelectMusic = SCREENMAN:GetTopScreen();
		scroller:set_info_set(info_set, 1);
		local curGroup = GAMESTATE:GetCurrentSong():GetGroupName();
		for key,value in pairs(info_set) do
			if curGroup == value then
				scroller:scroll_by_amount(key-1)
			end
		end;

		SCREENMAN:GetTopScreen():AddInputCallback(inputs);
		--MenuTimer = SCREENMAN:GetTopScreen():GetChild("Timer");
		--SecondsLeft is a global variable hack, brought over from ScreenSelectMusic overlay.
		--MenuTimer:SetSeconds(secondsLeft);
		--SCREENMAN:SystemMessage(math.ceil(numWheelItems/2));
		--self:linear(5);
		--self:queuecommand("CheckTimer");
	end;
	StartSelectingGroupMessageCommand=function(self)
		local curItem = scroller:get_actor_item_at_focus_pos();
		--SCREENMAN:SystemMessage(ListActorChildren(curItem.container));
		curItem.container:GetChild("banner"):stoptweening():zoom(1):diffusealpha(1);
		self:stoptweening():linear(.5):diffusealpha(1);
		SOUND:DimMusic(0,65536);
	end;
	StartSelectingSongMessageCommand=function(self)
		self:stoptweening():linear(.5):diffusealpha(0);
		SOUND:DimMusic(1,1);
	end;
	UpdateSongCommand=function(self)
	end;

	--Needs to sleep because without it, isSelectingDifficulty will be false while they close the difficulty select instead of after.
	TwoPartConfirmCanceledMessageCommand=function(self)
		local MusicWheel = SCREENMAN:GetTopScreen():GetChild('MusicWheel');
		--MusicWheel:accelerate(.2);
		--MusicWheel:addy(-300)

		self:sleep(.05);
		self:queuecommand("DifficultySelectExited");
	end;

	SongChosenMessageCommand=function(self)
		local MusicWheel = SCREENMAN:GetTopScreen():GetChild('MusicWheel');
		--MusicWheel:accelerate(.2);
		--MusicWheel:addy(300);

		isSelectingDifficulty = true;
	end;

	SongUnchosenMessageCommand=function(self)
		local MusicWheel = SCREENMAN:GetTopScreen():GetChild('MusicWheel');
		--MusicWheel:accelerate(.2);
		--MusicWheel:addy(-300)

		self:sleep(.05);
		self:queuecommand("DifficultySelectExited");
	end;

	DifficultySelectExitedCommand=function(self)
		isSelectingDifficulty = false;
	end;

	--I think this is the only way to check the timer
	CheckTimerCommand=function(self)
		--For some reason it ends the timer instantly because it's at 0 (Maybe it's unitialized?) So just stop the timer at 1 second.
		--Someone is going to see this and complain.
		if MenuTimer:GetSeconds() > 0 and MenuTimer:GetSeconds() < 1 then
			MenuTimer:SetSeconds(0.1);
			GoToNextScreen()
		else
			self:linear(1):queuecommand("CheckTimer");
		end;
	end;

	--Handle the hidden channels code
	CodeMessageCommand=function(self, params)
		if params.Name == "SecretGroup" then
			if all_channels_unlocked == true then
				SCREENMAN:SystemMessage("You've already entered the hidden channels code!")
			elseif ReadPrefFromFile("UserPrefHiddenChannels") ~= "Enabled" then
				--SCREENMAN:SystemMessage("The hidden channels option isn't enabled, there's no need!");
			else
				SCREENMAN:GetTopScreen():lockinput(1);
				all_channels_unlocked = true;
				MESSAGEMAN:Broadcast("GoFullMode"); -- GoSecretMode still uses the GoFullMode message because I'm lazy
				self:playcommand("GoFullMode2"); --I don't know why sleep(.5):queuecommand() makes it take too long.
				SOUND:PlayOnce(THEME:GetPathS("", "FULL_SOUND"), true);
				SOUND:PlayOnce(THEME:GetPathS("", "FULL_VOICE"));
			end;
		else
			--SCREENMAN:SystemMessage("WTF? "..params.Name);
		end;
	end;

	GoFullMode2Command=function(self)
		--SCREENMAN:SetNewScreen("ScreenSelectGroup");
		info_set = getVisibleSongGroups()
		initialGroup = scroller:get_info_at_focus_pos()
		scroller:set_info_set(info_set, 1);
		for key,value in pairs(info_set) do
			if initialGroup == value then
				scroller:scroll_by_amount(key-1)
			end
		end;
	end;

	-- BACKGROUND
	--  ScreenSelectGroup background has to be here, because if it's in its original location the diffuse wont be updated when all_channels_unlocked is set to true.
	--  (Probably some kind of attempt to cache the background since it's loading the same screen)
	-- Additionally the Sprite has to be accessible from here so it can be changed when the screen goes to full mode.
	Def.Sprite{
		Name="BackgroundVideo";
		InitCommand=function(self)
			if all_channels_unlocked then
				self:playcommand("GoFullMode2");
			else
				if ReadPrefFromFile("UserPrefBackgroundType") == "Prime" then
					self:Load(THEME:GetPathG("","_VIDEOS/diffuseMusicSelect"))
					self:diffuse(Color("Blue"));
				else
					self:Load(THEME:GetPathG("","_VIDEOS/MusicSelect"));
				end;
			end;
			self:Center():FullScreen();
		end;
		--InitCommand=cmd(Load,THEME:GetPathG("","_VIDEOS/diffuseMusicSelect"));
		GoFullModeMessageCommand=cmd(sleep,.5;queuecommand,"GoFullMode2");
		GoFullMode2Command=function(self)
			self:Load(THEME:GetPathG("","_VIDEOS/diffuseMusicSelect"))
			self:diffuse(Color("Green"))
		end;
	};
};

t[#t+1] = scroller:create_actors("foo", numWheelItems, item_mt, SCREEN_CENTER_X, SCREEN_CENTER_Y);

--HEADER
--[[t[#t+1] = Def.ActorFrame{
	LoadActor(THEME:GetPathG("","header"), false);

	LoadFont("venacti/_venacti 26px bold diffuse")..{
		InitCommand=cmd(rotationx,30;diffuse,0.08,0.08,0.08,1;diffusetopedge,0.2,0.2,0.2,1;shadowlengthy,-1;horizalign,center;x,SCREEN_CENTER_X;y,SCREEN_TOP+37;zoomx,0.7;zoomy,0.725;);
		Text="SELECT GROUP";
	};

	--TIMER
	LoadActor("B0") .. {
		InitCommand=cmd(draworder,101;x,SCREEN_CENTER_X+190;y,SCREEN_TOP+16;zoomy,0.55;zoomx,-0.55);
	};
	LoadActor("B1") .. {
		InitCommand=cmd(draworder,101;x,SCREEN_CENTER_X+160;y,SCREEN_TOP+25;zoomy,0.6;zoomx,-0.6);
	};
	LoadActor("B2") .. {
		InitCommand=cmd(draworder,103;x,SCREEN_CENTER_X+160;y,SCREEN_TOP+25;zoomy,0.6;zoomx,-0.6);
	};
	LoadFont("venacti/_venacti 26px bold diffuse")..{
		InitCommand=cmd(draworder,102;diffuse,0.6,0.6,0.6,0.6;shadowcolor,0,0,0,0.3;shadowlengthx,-0.8;shadowlength,-0.8;horizalign,left;x,SCREEN_CENTER_X+185 ;y,SCREEN_TOP+16;zoom,0.40);
		Text="TIMER"
	};
	--STAGE
	LoadActor("../B0") .. {
		InitCommand=cmd(draworder,101;x,SCREEN_CENTER_X-190;y,SCREEN_TOP+16;zoomy,0.55;zoomx,0.55);
	};
	LoadActor("../B1") .. {
		InitCommand=cmd(draworder,101;x,SCREEN_CENTER_X-160;y,SCREEN_TOP+25;zoomy,0.6;zoomx,0.6);
	};
	LoadActor("../B2") .. {
		InitCommand=cmd(draworder,103;x,SCREEN_CENTER_X-160;y,SCREEN_TOP+25;zoomy,0.6;zoomx,0.6);
	};
	LoadFont("venacti/_venacti 26px bold diffuse")..{
			InitCommand=cmd(draworder,102;diffuse,0.6,0.6,0.6,0.6;shadowcolor,0,0,0,0.3;shadowlengthx,0.8;shadowlengthy,-0.8;horizalign,right;x,SCREEN_CENTER_X-185;y,SCREEN_TOP+16;zoom,0.40);
			Text="STAGE"
	};
	LoadFont("venacti/_venacti_ 26px bold monospace numbers")..{
		InitCommand=cmd(draworder,102;diffuse,0.9,0.9,0.9,0.9;uppercase,true;horizalign,center;x,SCREEN_CENTER_X-160;maxwidth,45;zoomx,0.58;zoomy,0.58;y,SCREEN_TOP+25;shadowlengthx,1;shadowlengthy,-1);
		OnCommand=function(self)
			local stageNum=GAMESTATE:GetCurrentStageIndex()+1
			self:settextf("%02d",stageNum);
		end;
	}
};]]

t[#t+1] = Def.ActorFrame{

	PreviousGroupMessageCommand=cmd(playcommand,"Update");
	NextGroupMessageCommand=cmd(playcommand,"Update");
	UpdateCommand=function(self)
		self:GetChild("AnnouncerSound"):playcommand("PlaySound");
		self:GetChild("Description"):playcommand("UpdateText");
	end;
	--[[TestCommand=function(self)
		SCREENMAN:SystemMessage("passed");
	end;]]

	LoadFont("frutiger/frutiger 24px")..{
		Name="Description";
		--Text="Insert Text Here";
		InitCommand=cmd(Center;addy,150;);
		UpdateTextCommand=function(self)
			local groupName = scroller:get_info_at_focus_pos()
			if groupName then
				local fir = SONGMAN:GetSongGroupBannerPath(groupName);
				if not fir then
					self:settext(THEME:GetString("ScreenSelectGroup","MissingBannerWarning"));
					return;
				end;
				local dir = gisub(fir,'banner.png','info/text.ini');
				--SCREENMAN:SystemMessage(dir);
				if FILEMAN:DoesFileExist(dir) then
					local tt = lua.ReadFile(dir);
					self:settext(tt);
					(cmd(stoptweening;zoom,.7;shadowlength,0;wrapwidthpixels,420/1;))(self);
				else
					self:settext(THEME:GetString("ScreenSelectGroup","MissingInfoWarning"));
				end;
			else
				self:settext("");
			end;
		end;
	};


	Def.Sound{
		Name="AnnouncerSound";
		PlaySoundCommand=function(self)
			local groupName = scroller:get_info_at_focus_pos()
			if groupName then
				local fir = SONGMAN:GetSongGroupBannerPath(groupName);
				if not fir then
					return;
				end;
				local dir = gisub(fir,'banner.png','info/text.ini');
				--TODO: This should be a theme setting for sound priority.
				--Right now it's Announcer -> info folder but some people might like info folder -> announcer
				--Or possibly even info only?
				self:stop();
				local snd = ANNOUNCER_GetSound("Song Category Names", groupName);
				if snd then
					self:load(snd);
					self:play();
					return
				end
				local snd = string.gsub(dir, "text.ini", "sound")
				--SCREENMAN:SystemMessage(snd);
				--GetSound is in AnnouncerUtils for some reason
				snd = GetSound(snd)
				if snd ~= false then
					self:load(snd);
					self:play();
				end;
			end;
		end;
	};
};

--[[t[#t+1] = LoadActor(THEME:GetPathG("","footer"), true)..{
	InitCommand=cmd(draworder,130);
};]]

--Wheel left/right shadow
t[#t+1] = Def.Quad {
	InitCommand=cmd(horizalign,right;draworder,100;faderight,1;;zoomto,120,SCREEN_HEIGHT;y,SCREEN_CENTER_Y;x,SCREEN_CENTER_X-320;diffuse,0,0,0,1);
}
t[#t+1] = Def.Quad {
	InitCommand=cmd(horizalign,left;draworder,100;fadeleft,1;;zoomto,120,SCREEN_HEIGHT;y,SCREEN_CENTER_Y;x,SCREEN_CENTER_X+320;diffuse,0,0,0,1);
}

return t;
