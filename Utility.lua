local json = require( "json" )
local M = {}
-- M.userdefault_table = {}
M.filename = "userdefault.json"

M.soundTable = {

    num_click_sound = audio.loadSound( "game_button_click.mp3" ),
    button_click_sound = audio.loadSound( "other_button_click.mp3" ),
    wrong_button_click = audio.loadSound( "wrong_answer.mp3" ),
    background_sound = audio.loadSound( "background_music.mp3" )
}

local function saveData( tabel )
   local path = system.pathForFile( M.filename, system.DocumentsDirectory )
   local file = io.open(path, "w")
   if ( file ) then
      local jsonSaveGame = json.encode(tabel)
      file:write( jsonSaveGame )
      io.close( file )
      return true
   else
      print( "Error: could not read ", M.filename, "." )
      return false
   end
end

local function readData( user_default_key,  default_value)
   local path = system.pathForFile( M.filename, system.DocumentsDirectory )
   local contents = ""
   local file = io.open( path, "r" )
   print( "readData path : " .. path )
   if ( file ) then
      -- Read all contents of file into a string
      local contents = file:read( "*a" )
      print( "contents readData: " .. contents )
      if (contents) then
         local jsonRead = json.decode(contents)
         if (jsonRead == nil) then
            print( "Value is nil" )
            io.close(file)
            local tabel = {user_default_key = default_value}
            saveData(tabel)
         else
            jsonRead[user_default_key] = default_value
            io.close( file )
            saveData(jsonRead)
         end
      end
   else
      print( "Error: could not read scores from ", M.filename, "." )
   end
end
 


function M.save(user_default_key, value)
	readData(user_default_key, value)
end

function M.load(user_default_key, default_value)
   local path = system.pathForFile( M.filename, system.DocumentsDirectory )
   local contents = ""
   local file = io.open( path, "r" )
   print( "path : " .. path )
   if ( file ) then
      -- Read all contents of file into a string
      local contents = file:read( "*a" )
      print( "contents : " .. contents )
      if (contents) then
      	local jsonRead = json.decode(contents)
      	if (jsonRead == nil) then
      		print( "Value is nil" )
      		io.close(file)
      		M.save(user_default_key, default_value)
      		return default_value
      	end
     	local value = jsonRead[user_default_key]
      if (value == nil) then
            print( "Value is nil" )
            io.close(file)
            M.save(user_default_key, default_value)
            return default_value
         end
        	print( value )
      	io.close( file )
      	return value
      end
      return nil
   else
      print( "Error: could not read scores from ", M.filename, "." )
   end
   return nil
end

return M