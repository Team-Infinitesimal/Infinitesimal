-- Function to return all available avatars present on the Appearance/Avatars folder.
return function()
    local result = {} -- Here will be the end result.
    local dir = "/Appearance/Avatars/"
    -- First, retrieve it.
    for item, name in pairs( FILEMAN:GetDirListing(dir, false, false) ) do
        -- Now, organize each item inside of the table.
        -- In this case, we will return the absolute path to the image, to make it easier.

        -- Only accept images, anything else should be ignored as we're going to load these
        -- directly as a sprite.
        if ActorUtil.GetFileType(name) == "FileType_Bitmap" then
            result[#result+1] = {name, dir..name}
        end

    end
    -- Now that we've finished gathering all of the images, return the table.
    return result
end
