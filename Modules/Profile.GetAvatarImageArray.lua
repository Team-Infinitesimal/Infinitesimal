-- Function to return all available avatars present on the Appearance/Avatars folder.
return function()
    local result = {} -- Here will be the end result.
    local dir = "/Appearance/Avatars/"
    -- First, retrieve it.
    for item, name in pairs( FILEMAN:GetDirListing(dir, false, false) ) do
        -- Now, organize each item inside of the table.
        -- In this case, we will return the absolute path to the image, to make it easier.
        if name ~= "Put here Avatars with your Profile Name" then
            result[#result+1] = {name, dir..name}
        end
        
    end
    -- Now that we've finished gathering all of the images, return the table.
    return result
end