function GetLocalProfiles()
	local t = {};

	function GetSongsPlayedString(numSongs)
		return numSongs == 1 and Screen.String("SingularSongPlayed") or Screen.String("SeveralSongsPlayed")
	end

	for p = 0,PROFILEMAN:GetNumLocalProfiles()-1 do
		local profile=PROFILEMAN:GetLocalProfileFromIndex(p);
		local ProfileCard = Def.ActorFrame {
			LoadFont("Montserrat semibold 40px") .. {
				Text=profile:GetDisplayName();
				InitCommand=function(self)self:shadowlength(1):y(-10):zoom(0.5):ztest(true)end;
			};

			LoadFont("Montserrat normal 20px") .. {
				InitCommand=function(self)self:shadowlength(1):y(8):zoom(0.5):vertspacing(-8):ztest(true)end;
				BeginCommand=function(self)
					local numSongsPlayed = profile:GetNumTotalSongsPlayed();
					self:settext( string.format( GetSongsPlayedString( numSongsPlayed ), numSongsPlayed ) )
				end;
			};
		};

		t[#t+1]=ProfileCard;
	end;

	return t;
end;

function LoadCard(cColor)
	local t = Def.ActorFrame {

		InitCommand=function(self)
			self:y(15):diffusealpha(0.75)
		end,

		Def.Sprite {
			Texture=THEME:GetPathG("ScreenSelectProfile","CardBackground"),
			InitCommand=function(self)self:diffuse(cColor)end;
		};

		Def.Sprite {
			Texture=THEME:GetPathG("ScreenSelectProfile","CardFrame"),
			InitCommand=function(self)
				self:y(-15)
				:zoom(0.5)
			end,
		},
	};
	return t
end
function LoadPlayerStuff(Player)
	local t = {};

	local pn = (Player == PLAYER_1) and 1 or 2;

	t[#t+1] = Def.ActorFrame {
		Name = 'JoinFrame';

		LoadCard(Color('Black'));

		LoadActor(THEME:GetPathG("","PressCenterStep"))..{
			InitCommand=function(self)
				self:zoom(0.75,0.75)
			end;
		};
	};

	t[#t+1] = Def.ActorFrame {
		Name = 'BigFrame';
		LoadCard(Color("Black"));
	};
	t[#t+1] = Def.ActorFrame {
		Name = 'SmallFrame';
		InitCommand=function(self)self:y(17)end;
		Def.Quad {
			InitCommand=function(self)
				self:zoomto(178,40)
			end,
			OnCommand=function(self)self:diffuse(Color('Black')):diffusealpha(0.5)end;
		};
		Def.Quad {
			InitCommand=function(self)
				self:zoomto(178,40)
			end,
			OnCommand=function(self)self:diffuse(Color('Black')):fadeleft(0.25):faderight(0.25):glow(color("1,1,1,0.25"))end;
		};
		Def.Quad {
			InitCommand=function(self)
				self:zoomto(178,40)
				:y(-40/2+20)
			end,
			OnCommand=function(self)self:diffuse(Color("Black")):fadebottom(1):diffusealpha(0.35)end;
		};
	};

	t[#t+1] = Def.ActorFrame {
		Name = 'GuestText';
		LoadFont("Montserrat semibold 40px") .. {
			Text="No profile!";
			InitCommand=function(self)self:shadowlength(1):zoom(0.5):ztest(true)end;
		};
	};

	t[#t+1] = Def.ActorScroller{
		Name = 'Scroller';
		NumItemsToDraw=6;
		OnCommand=function(self)self:y(20):SetFastCatchup(true):SetMask(200,69):SetSecondsPerItem(0.1)end;
		TransformFunction=function(self, offset, itemIndex, numItems)
			local focus = scale(math.abs(offset),0,2,1,0);
			self:visible(false);
			self:y(math.floor( offset*40 ));
		end;
		children = GetLocalProfiles();
	};

	t[#t+1] = Def.ActorFrame {
		Name = "EffectFrame";
	};

	return t;
end;

function UpdateInternal3(self, Player)
	local pn = (Player == PLAYER_1) and 1 or 2;
	local frame = self:GetChild(string.format('P%uFrame', pn));
	local scroller = frame:GetChild('Scroller');
	local seltext = frame:GetChild('SelectedProfileText');
	local joinframe = frame:GetChild('JoinFrame');
	local smallframe = frame:GetChild('SmallFrame');
	local bigframe = frame:GetChild('BigFrame');
	local guesttext = frame:GetChild('GuestText');

	if GAMESTATE:IsHumanPlayer(Player) then
		frame:visible(true);
		if MEMCARDMAN:GetCardState(Player) == 'MemoryCardState_none' then
			--using profile if any
			joinframe:visible(false);
			smallframe:visible(true);
			bigframe:visible(true);
			scroller:visible(true);
			guesttext:visible(false);
			local ind = SCREENMAN:GetTopScreen():GetProfileIndex(Player);
			if ind > 0 then
				scroller:SetDestinationItem(ind-1);
			else
				if SCREENMAN:GetTopScreen():SetProfileIndex(Player, 1) then
					scroller:SetDestinationItem(0);
					self:queuecommand('UpdateInternal2');
				else
					joinframe:visible(false);
					smallframe:visible(false);
					bigframe:visible(true);
					scroller:visible(false);
					guesttext:visible(true);
					--seltext:settext('No profile');
				end;
			end;
		else
			--using card
			smallframe:visible(false);
			scroller:visible(false);
			guesttext:visible(false);
			SCREENMAN:GetTopScreen():SetProfileIndex(Player, 0);
		end;
	else
		joinframe:visible(true);
		scroller:visible(false);
		smallframe:visible(false);
		bigframe:visible(false);
		guesttext:visible(false);
	end;
end;

local t = Def.ActorFrame {

	StorageDevicesChangedMessageCommand=function(self, params)
		self:queuecommand('UpdateInternal2');
	end;

	CodeMessageCommand = function(self, params)
		if params.Name == 'Start' or params.Name == 'Center' then
			MESSAGEMAN:Broadcast("StartButton");
			if not GAMESTATE:IsHumanPlayer(params.PlayerNumber) then
				SCREENMAN:GetTopScreen():SetProfileIndex(params.PlayerNumber, -1);
			else
				SCREENMAN:GetTopScreen():Finish();
			end;
		end;
		if params.Name == 'Up' or params.Name == 'Up2' or params.Name == 'DownLeft' then
			if GAMESTATE:IsHumanPlayer(params.PlayerNumber) then
				local ind = SCREENMAN:GetTopScreen():GetProfileIndex(params.PlayerNumber);
				if ind > 1 then
					if SCREENMAN:GetTopScreen():SetProfileIndex(params.PlayerNumber, ind - 1 ) then
						MESSAGEMAN:Broadcast("DirectionButton");
						self:queuecommand('UpdateInternal2');
					end;
				end;
			end;
		end;
		if params.Name == 'Down' or params.Name == 'Down2' or params.Name == 'DownRight' then
			if GAMESTATE:IsHumanPlayer(params.PlayerNumber) then
				local ind = SCREENMAN:GetTopScreen():GetProfileIndex(params.PlayerNumber);
				if ind > 0 then
					if SCREENMAN:GetTopScreen():SetProfileIndex(params.PlayerNumber, ind + 1 ) then
						MESSAGEMAN:Broadcast("DirectionButton");
						self:queuecommand('UpdateInternal2');
					end;
				end;
			end;
		end;
		if params.Name == 'Back' then
			-- Let's simplify things to avoid crashes whenever being utilized out of order
			SCREENMAN:GetTopScreen():Cancel();
		end;
	end;

	PlayerJoinedMessageCommand=function(self, params)
		self:queuecommand('UpdateInternal2');
	end;

	PlayerUnjoinedMessageCommand=function(self, params)
		self:queuecommand('UpdateInternal2');
	end;

	OnCommand=function(self, params)
		self:queuecommand('UpdateInternal2');
	end;

	UpdateInternal2Command=function(self)
		UpdateInternal3(self, PLAYER_1);
		UpdateInternal3(self, PLAYER_2);
	end;

	children = {
		Def.ActorFrame {
			Name = 'P1Frame';
			InitCommand=function(self)self:x(SCREEN_CENTER_X-160):y(SCREEN_CENTER_Y):zoom(0.5):diffusealpha(0)end;
			OnCommand=function(self)self:sleep(0.25):decelerate(0.85):zoom(1):diffusealpha(1)end;
			PlayerJoinedMessageCommand=function(self,param)
				if param.Player == PLAYER_1 then
					(function(self)
						self:zoom(1.15)
						:decelerate(0.25)
						:zoom(1.0)
					end)(self);
				end;
			end;
			children = LoadPlayerStuff(PLAYER_1);
		};
		Def.ActorFrame {
			Name = 'P2Frame';
			InitCommand=function(self)self:x(SCREEN_CENTER_X+160):y(SCREEN_CENTER_Y):zoom(0.5):diffusealpha(0)end;
			OnCommand=function(self)self:sleep(0.25):decelerate(0.85):zoom(1):diffusealpha(1)end;
			PlayerJoinedMessageCommand=function(self,param)
				if param.Player == PLAYER_2 then
					(function(self)
						self:zoom(1.15)
						:decelerate(0.25)
						:zoom(1.0)
					end)(self);
				end;
			end;
			children = LoadPlayerStuff(PLAYER_2);
		};
		-- sounds
		LoadActor( THEME:GetPathS("Common","start") )..{
			StartButtonMessageCommand=function(self)self:play()end;
		};
		LoadActor( THEME:GetPathS("Common","cancel") )..{
			BackButtonMessageCommand=function(self)self:play()end;
		};
		LoadActor( THEME:GetPathS("Common","value") )..{
			DirectionButtonMessageCommand=function(self)self:play()end;
		};
	};
};

return t;
