
local aspectRatio = display.pixelHeight / display.pixelWidth
application =
{
	content =
	{
		width = aspectRatio > 1.5 and 320 or math.floor( 480 / aspectRatio ),
      	height = aspectRatio < 1.5 and 480 or math.floor( 320 * aspectRatio ), 
		scale = "letterbox",
		fps = 30,
		
		--[[
		imageSuffix =
		{
			    ["@2x"] = 2,
		},
		--]]
	},

	--[[
	-- Push notifications
	notification =
	{
		iphone =
		{
			types =
			{
				"badge", "sound", "alert", "newsstand"
			}
		}
	},
	--]]    
}
