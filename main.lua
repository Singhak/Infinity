-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- include the Corona "composer" module
local composer = require "composer"
local utility = require("Utility")

-- load menu screen
local splashscreen = display.newImageRect( "Default.png", display.contentWidth, display.contentHeight );
splashscreen.x = display.contentCenterX
splashscreen.y = display.contentCenterY

local function removeSplash(event)
	splashscreen:removeSelf()
	splashscreen = nil
	if (utility.load("music", true)) then
		audio.play( utility.soundTable["background_sound"], {loops=-1} )
	end
	composer.gotoScene( "menu", "fade", 500  )
end

transition.fadeOut( splashscreen, {time = 1000, onComplete = removeSplash} )

