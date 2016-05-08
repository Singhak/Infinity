-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------
-- Utility
local contentW = display.contentWidth
local contentH = display.contentHeight
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local initUi
local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "widget" library
local widget = require "widget"

--------------------------------------------

-- forward declarations and other locals
local setting_button
local leaderboard_button
local start_button
-- 'onRelease' event listener for playBtn
local function onPlayBtnRelease()
	
	-- go to level1.lua scene
	composer.gotoScene( "level1", "fade", 500 )
	
	return true	-- indicates successful touch
end

function scene:create( event )
	local sceneGroup = self.view

	-- display a background image
	local background = display.newImageRect( "firstScreen.png", display.contentWidth, display.contentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x, background.y = 0, 0
	
	initUi()
	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( setting_button )
	sceneGroup:insert( leaderboard_button )
	sceneGroup:insert( start_button )
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
end

function scene:destroy( event )
	local sceneGroup = self.view
end

function initUi()
	-- setting Button
	setting_button = display.newImageRect("setting_icon.png",60, 60)
	setting_button.y = contentH - setting_button.height * 0.60
	setting_button.x = setting_button.width * 0.60
	setting_button.id = "setting"
	setting_button:addEventListener( "touch", onButtonClick )

	-- LeaderboardButton
	leaderboard_button = display.newImageRect("leaderboard_icon.png",60, 60)
	leaderboard_button.y = contentH - leaderboard_button.height * 0.60
	leaderboard_button.x = contentW - leaderboard_button.width * 0.60
	leaderboard_button.id = "leaderboard"
	leaderboard_button:addEventListener( "touch", onButtonClick )

	-- Play button
	start_button = display.newImageRect("start_icon.png",60, 60)
	start_button.y = contentH * 0.50
	start_button.x = contentW * 0.50
	start_button.id = "play"
	start_button:addEventListener( "touch", onButtonClick )
end

function onButtonClick( event )

	local id = event.target.id
	if (event.phase == "began") then
		event.target.xScale = .8 -- scale the button on touch release 
    	event.target.yScale = .8
		if (id == "setting") then
    		myText.text = id
		elseif (id == "play") then
    		composer.gotoScene( "GamePlay", "fade", 500 )
		elseif (id == "leaderboard") then
    		myText.text = id
		end
		
	elseif (event.phase == "ended" or event.phase == "cancelled") then
    	event.target.xScale = 1 -- Re-scale the button on touch release 
    	event.target.yScale = 1
	end
	
end
---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )


-----------------------------------------------------------------------------------------

return scene