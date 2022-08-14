local Songs = {}

for Song in ivalues(SONGMAN:GetPreferredSortSongs()) do
	if SongUtil.GetPlayableSteps(Song) then
		Songs[#Songs+1] = Song
	end
end

local CurrentIndex = math.random(#Songs)
local SongIsChosen = false

local function InputHandler(event)
	local pn = event.PlayerNumber
    if not pn then return end
    
    -- To avoid control from a player that has not joined, filter the inputs out
    if pn == PLAYER_1 and not GAMESTATE:IsPlayerEnabled(PLAYER_1) then return end
    if pn == PLAYER_2 and not GAMESTATE:IsPlayerEnabled(PLAYER_2) then return end
    
    if not SongIsChosen then
        -- Don't want to move when releasing the button
        if event.type == "InputEventType_Release" then return end
        
        local button = event.button
        if button == "Left" or button == "MenuLeft" or button == "DownLeft" then
            CurrentIndex = CurrentIndex - 1
            if CurrentIndex < 1 then CurrentIndex = #Songs end
            GAMESTATE:SetCurrentSong(Songs[CurrentIndex])
            
        elseif button == "Right" or button == "MenuRight" or button == "DownRight" then
            CurrentIndex = CurrentIndex + 1
            if CurrentIndex > #Songs then CurrentIndex = 1 end
            GAMESTATE:SetCurrentSong(Songs[CurrentIndex])
            
        elseif button == "Start" or button == "MenuStart" or button == "Center" then
            MESSAGEMAN:Broadcast("SongChosen")
            SongIsChosen = true
        end
    end
	
	MESSAGEMAN:Broadcast("UpdateMusic")
end

local t = Def.ActorFrame {
    OnCommand=function(self)
        GAMESTATE:SetCurrentSong(Songs[CurrentIndex])
        SCREENMAN:GetTopScreen():AddInputCallback(InputHandler) 
        self:playcommand("Refresh")
    end,
    
    -- Prevent the song list from moving when transitioning
    OffCommand=function(self)
        SongIsChosen = true
    end,
    
    -- Update song list
    CurrentSongChangedMessageCommand=function(self) self:playcommand("Refresh") end,
    
    -- These are to control the functionality of the music wheel
    SongChosenMessageCommand=function(self) SongIsChosen = true self:playcommand("Refresh") end,
    SongUnchosenMessageCommand=function(self) SongIsChosen = false self:playcommand("Refresh") end,
}

return t