--[[
Copyright © 2020 Rhythm Lunatic

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

-- Get screen handle so we can adjust the timer.
local ScreenSelectMusic; --Need a handle on the current screen for reasons...
--- since this is a group wheel, we need an array of the groups currently loaded in StepMania. So add an array. This will be used as the 'info set' for the wheel.
local song_groups = {};

-- Iterate through the song groups and check if they have AT LEAST one song with valid charts.
-- If so, add them to the group.
for v in ivalues( SONGMAN:GetSongGroupNames() ) do
	for s in ivalues( SONGMAN:GetSongsInGroup(v) ) do
		local st = SongUtil.GetPlayableSteps(s)
		-- lua.ReportScriptError(#st)
		if #st > 0 then
			song_groups[#song_groups+1] = v
			break
		end
	end
end

-- Next up, we create our wheel.

-- This spawns an item scroller class.
local scroller = setmetatable({disable_wrapping= false}, item_scroller_mt)
local numWheelItems = 15 --Number of rotating items to have in the wheel. This does not have anything to do with the size of the info set.

-- And here is our massive wheel frame.
local item_mt= {
  __index= {
	-- create_actors must return an actor.  The name field is a convenience.
        create_actors= function(self, params)
	  self.name= params.name
                --This is the equivalent to Graphics/MusicWheelItem SectionExpanded NormalPart (or MusicWheelItem Song NormalPart if you're making a song wheel)
		return Def.ActorFrame{
			InitCommand= function(subself)
				-- Setting self.container to point to the actor gives a convenient
				-- handle for manipulating the actor.
		  		self.container= subself
		  		subself:SetDrawByZPosition(true);
			end;
			--A text actor for the group names to be displayed.
			Def.BitmapText{
				Name= "text",
				Font= "Montserrat semibold 40px",
				InitCommand=function(self)self:addy(60):zoom(0.35)end;
			};
			--And probably more important, the banner for the group icons to be displayed.
			Def.Sprite{
				Name="banner";
			};
		};
	end,
        -- This is the equivalent to your ItemTransformFunction, but unlike ItemTransformFunction which updates per frame this one uses tweens.
        -- This particular example function acts like a cover flow wheel.
	-- item_index is the index in the list, ranging from 1 to num_items.
	-- is_focus is only useful if the disable_wrapping flag in the scroller is
	-- set to false.
	transform= function(self, item_index, num_items, is_focus)
		local offsetFromCenter = item_index-math.floor(numWheelItems/2)
		local offsetAbs = math.abs(offsetFromCenter);
		local spacing = math.abs(math.sin(offsetFromCenter/math.pi))
		
		self.container:stoptweening();
		
		if offsetAbs < 4 then
			self.container:decelerate(.25);
			self.container:visible(true);
		else
			self.container:visible(false);
		end;
		
		self.container:zoom(clamp(1-(offsetAbs/3), 0.75, 1));
	
		self.container:x(offsetFromCenter * (225 - spacing * 50));
		
		-- This is for debug testing.
		--[[if offsetFromCenter == 0 then
			self.container:diffuse(Color("Red"));
		else
			self.container:diffuse(Color("White"));
		end;
		]]
	end,
	-- info is one entry in the info set that is passed to the scroller.
        -- So in this example, something from "song_groups" is being passed in as the 'info' argument.
        -- Remember SetMessageCommand when used in Song NormalPart? This is that.
	set= function(self, info)
        self.container:GetChild("text"):settext(info)

		local banner = SONGMAN:GetSongGroupBannerPath(info);
		if banner == "" then
			self.container:GetChild("banner"):Load(THEME:GetPathG("common","fallback banner.png")):scaletofit(-100, -100, 100, 100);
			self.container:GetChild("text"):visible(true);
  		else
  			self.container:GetChild("banner"):Load(banner):scaletofit(-100, -100, 100, 100);
  			self.container:GetChild("text"):visible(false);
		end;
	end,
}}

--This function runs when you press start and changes the current song group. Since this is a group wheel.
--We'll define it here because I said so.
local function CloseWheel()
        --Get the current selected group. get_info_at_focus_pos() gets the current highlighted item in the set, if you couldn't already tell. In this case it's the name of the current group being highlighted.
	local currentGroup = scroller:get_info_at_focus_pos();
        --One of the benefits of a custom wheel is being able to transform a single item in the wheel instead of all of them. This gets the current highlighted item in the wheel.
	local curItem = scroller:get_actor_item_at_focus_pos();
        --This transform function zooms in the item.
	curItem.container:GetChild("banner"):decelerate(0.25):diffusealpha(0);

        --Since this is for a group wheel, this sets the new group.
	ScreenSelectMusic:GetChild('MusicWheel'):SetOpenSection(currentGroup);
        --The built in wheel needs to be told the group has been changed, for whatever reason. This function does it.
	SCREENMAN:GetTopScreen():PostScreenMessage( 'SM_SongChanged', 0 );
	SCREENMAN:set_input_redirected(PLAYER_1, false);
	SCREENMAN:set_input_redirected(PLAYER_2, false);
	MESSAGEMAN:Broadcast("StartSelectingSong");
end;

--And now, our input handler for the wheel we wrote, so we can actually move the wheel.
local isSelectingDifficulty = false; --You'll need this for later if you're using a TwoPartSelect.

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
			CloseWheel()
		elseif button == "DownLeft" or button == "Left" then
			scroller:scroll_by_amount(-1);
			SOUND:PlayOnce(THEME:GetPathS("MusicWheel", "change"), true);
			MESSAGEMAN:Broadcast("PreviousGroup"); --If you have arrows or graphics on the screen and you only want them to respond when left or right is pressed.
		elseif button == "DownRight" or button == "Right" then
			scroller:scroll_by_amount(1);
			SOUND:PlayOnce(THEME:GetPathS("MusicWheel", "change"), true);
			MESSAGEMAN:Broadcast("NextGroup");
		elseif button == "Back" then
			SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToPrevScreen"); --Because we've redirected input, we need to handle the back button ourselves instead of SM handling it. You can do whatever you want here though, like closing the wheel without picking a group.
		else
                        --Inputs not working? Uncomment this to check what they are.
			--SCREENMAN:SystemMessage(button);
		end;
	end;
end;

local t = Def.ActorFrame{
    --Make the wheel invisible by default.
    InitCommand=function(self)
    	self:diffusealpha(0);
    end;

    OnCommand=function(self)
		ScreenSelectMusic = SCREENMAN:GetTopScreen();
        	--Remember when we created the array song_groups? Here we finally use it.
		scroller:set_info_set(song_groups, 1);
	
        	--Scroll the wheel to the correct song group.
		local curGroup = GAMESTATE:GetCurrentSong():GetGroupName();
		for key,value in pairs(song_groups) do
	    	if curGroup == value then
				scroller:scroll_by_amount(key-1)
			end
		end;
        --Add the input callback so our custom inputs() function works.
        SCREENMAN:GetTopScreen():AddInputCallback(inputs);

		--I got sick of input locking when I reloaded the screen, since the wheel isn't open when you reload the screen.
		SCREENMAN:set_input_redirected(PLAYER_1, false);
		SCREENMAN:set_input_redirected(PLAYER_2, false);
		isPickingDifficulty = false;
	end;
	
	 OffCommand=function(self)
		--I got sick of input locking when I reloaded the screen, since the wheel isn't open when you reload the screen.
		SCREENMAN:set_input_redirected(PLAYER_1, false);
		SCREENMAN:set_input_redirected(PLAYER_2, false);
		isPickingDifficulty = false;
	end;

	--TwoPartSelect handlers.
	SongChosenMessageCommand=function(self)
		isPickingDifficulty = true;
	end;
	
	TwoPartConfirmCanceledMessageCommand=function(self)self:queuecommand("PickingSong")end;
	SongUnchosenMessageCommand=function(self)self:queuecommand("PickingSong")end;
	
	PickingSongCommand=function(self)
		isPickingDifficulty = false;
	end;

	--And now, handle opening the wheel.
	CodeMessageCommand=function(self,param)
		local codeName = param.Name -- code name, matches the one in metrics
		if codeName == "GroupSelectPad1" or codeName == "GroupSelectPad2" or codeName == "GroupSelectButton1" or codeName == "GroupSelectButton2" then
			if isPickingDifficulty then return end; --Don't want to open the group select if they're picking the difficulty.
			
			MESSAGEMAN:Broadcast("StartSelectingGroup");
			--No need to check if both players are present.
			SCREENMAN:set_input_redirected(PLAYER_1, true);
			SCREENMAN:set_input_redirected(PLAYER_2, true);
			--Remember how when you close the wheel the item gets zoomed in? This zooms it back out.
			local curItem = scroller:get_actor_item_at_focus_pos();
			curItem.container:GetChild("banner"):stoptweening():diffusealpha(1);

			--Show the ActorFrame that holds the wheel.
			self:stoptweening():diffusealpha(1);
			--Optional. Mute the music currently playing.
			--SOUND:DimMusic(0,65536);

			local musicwheel = SCREENMAN:GetTopScreen():GetChild('MusicWheel');
			musicwheel:Move(0); --Work around a StepMania bug. If the input is redirected while scrolling through the built in music wheel, it will continue to scroll.
		end;
    end;
    
    StartSelectingGroupMessageCommand=function(self,params)
		self:stoptweening():decelerate(0.25):diffusealpha(1);
	end;

	StartSelectingSongMessageCommand=function(self)
		self:stoptweening():decelerate(0.25):diffusealpha(0);
	end;
}

t[#t+1] = Def.Quad {
	InitCommand=function(self)
		self:Center()
		:zoomto(SCREEN_WIDTH,SCREEN_HEIGHT)
		:diffuse(0,0,0,0)
		:fadetop(0.2);
	end;
	
	StartSelectingGroupMessageCommand=function(self)
		self:stoptweening()
		:decelerate(0.25)
		:diffusealpha(0.75);
	end;
	
	StartSelectingSongMessageCommand=function(self)
		self:stoptweening()
		:decelerate(0.25)
		:diffusealpha(0);
	end;
}

t[#t+1] = LoadActor(THEME:GetPathS("","Common Start"))..{
	StartSelectingSongMessageCommand=function(self)
		self:play();
	end;
};

t[#t+1] = scroller:create_actors("foo", numWheelItems, item_mt, SCREEN_CENTER_X, SCREEN_CENTER_Y);

--Don't forget this at the end of your lua file.
return t;
