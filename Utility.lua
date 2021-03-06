local json = require( "json" )
local M = {}
-- M.userdefault_table = {}
M.filename = "userdefault.json"
M.bannerad = "ca-app-pub-4734999561630998/3143591268"
M.fullScreenad = "ca-app-pub-4734999561630998/7029270465"

M.leaderboardTimeAttack = "CgkIr_qEqbsCEAIQAg"
M.leaderboard15Seconds = "CgkIr_qEqbsCEAIQAA"
M.leaderboardInfinity = "CgkIr_qEqbsCEAIQAQ"

M.soundTable = {

    num_click_sound = audio.loadSound( "answer_click.mp3" ),
    button_click_sound = audio.loadSound( "answer_click.mp3" ),
    wrong_button_click = audio.loadSound( "wrong_click.mp3" ),
    background_sound = audio.loadSound( "background_music.mp3" )
}

local function saveData( tabel )
   local path = system.pathForFile( M.filename, system.DocumentsDirectory )
   local file = io.open(path, "w")
   if ( file ) then
      print( "saveData: " )
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
      print( "readData key: " ..user_default_key )
      local jsonRead = {user_default_key = default_value}
      saveData(jsonRead)
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
      -- print( "contents : " .. contents )
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
      else
         io.close( file )
         M.save(user_default_key, default_value)
         return default_value
      end
      return nil
   else
      print( "load key:" ..user_default_key )
      M.save(user_default_key, default_value)
      return default_value
   end
   return nil
end

return M