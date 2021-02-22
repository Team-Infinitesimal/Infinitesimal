function GetPlayerAvatar(player)
  return LoadModule("Options.GetProfileData.lua")(player)["Image"];
end;
