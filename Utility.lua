local json = require( "json" )
local M = {}
M.userdefault_table = {}
M.filename = "userdefault.json"

function M.save(user_default_key, value)
	M.userdefault_table[user_default_key] = value
	print( M.userdefault_table[user_default_key] )
   local path = system.pathForFile( M.filename, system.DocumentsDirectory )
   local file = io.open(path, "w")
   if ( file ) then
      local jsonSaveGame = json.encode(M.userdefault_table)
      file:write( jsonSaveGame )
      io.close( file )
      return true
   else
      print( "Error: could not read ", M.filename, "." )
      return false
   end
end
 
function M.load(user_default_key)
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
      		return nil
      	end
     	local value = jsonRead[user_default_key]
     	print( jsonRead )
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
     	print( jsonRead )
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