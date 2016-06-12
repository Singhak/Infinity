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
local toast = require('plugin.toast')
local ads = require ("ads")
local gameNetwork = require( "gameNetwork" )
local scene = composer.newScene()
local utility = require ("Utility")

-- include Corona's "widget" library
local widget = require "widget"

--------------------------------------------

-- forward declarations and other locals
local setting_button
local leaderboard_button
local start_button
local help_button

function scene:create( event )
	local sceneGroup = self.view
	ads.init( "admob", utility.fullScreenad, nil )
	ads.load( "interstitial", { appId = utility.fullScreenad } )
	-- display a background image
	local background = display.newImageRect( "bg1_320.jpg", display.contentWidth, display.contentHeight )
	local logo_img = display.newImageRect( "go_inifinite_logo.png", 250, 130)
	logo_img.x, logo_img.y = (contentW - 250)/2, contentH * .05
	background.anchorX, background.anchorY = 0,0
	logo_img.anchorX, logo_img.anchorY = 0,0
	background.x, background.y = 0, 0
	
	initUi()
	-- all display objects must be inserted into group
	
	sceneGroup:insert( background )
	sceneGroup:insert( logo_img )
	sceneGroup:insert( setting_button )
	sceneGroup:insert( leaderboard_button )
	sceneGroup:insert( start_button )
	-- sceneGroup:insert( help_button )
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	if phase == "will" then
		ads.hide()
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
	setting_button = display.newImageRect("setting_icon.png",48, 48)
	setting_button.y = contentH - setting_button.height * 0.60
	setting_button.x = setting_button.width * 0.60
	setting_button.id = "setting"
	setting_button:addEventListener( "touch", onButtonClick )

	-- LeaderboardButton
	leaderboard_button = display.newImageRect("leader_board_icon.png",48, 48)
	leaderboard_button.y = contentH - leaderboard_button.height * 0.60
	leaderboard_button.x = contentW - leaderboard_button.width * 0.60
	leaderboard_button.id = "leaderboard"
	leaderboard_button:addEventListener( "touch", onButtonClick )

	-- Play button
	start_button = display.newImageRect("play_button.png",60, 60)
	start_button.y = contentH * 0.50
	start_button.x = contentW * 0.50
	start_button.id = "play"
	start_button:addEventListener( "touch", onButtonClick )

	-- help_button = display.newImageRect("help_ic.png",60, 60)
	-- help_button.y = contentH - help_button.height * 0.60
	-- help_button.x = contentW * 0.50
	-- help_button.id = "help"
	-- help_button:addEventListener( "touch", onButtonClick )
end

local function showLeaderboards( )
	gameNetwork.show( "leaderboards" )
	print( "showLeaderboards" )
   -- if ( system.getInfo("platformName") == "Android" ) then
   --    gameNetwork.show( "leaderboards" )
   -- else
   --    gameNetwork.show( "leaderboards", { leaderboard = {timeScope="AllTime"} } )
   -- end
   return true
end

function onButtonClick( event )

	local id = event.target.id
	if (event.phase == "began") then
		event.target.xScale = .8 -- scale the button on touch began 
    	event.target.yScale = .8
		if (id == "setting") then
			-- onPause()
			composer.showOverlay( "Settings")
    		-- myText.text = id
		elseif (id == "play") then
    		composer.gotoScene( "GameMode", "fromRight", 500 )
		elseif (id == "leaderboard") then
    		toast.show('leaderboard is comming soon!')
    		showLeaderboards()
		end
		
	elseif (event.phase == "ended" or event.phase == "cancelled") then
		event.target.xScale = 1 -- Re-scale the button on touch release 
    	event.target.yScale = 1
		if (id == "setting") then
			onPause()
		end
	end
	Runtime:removeEventListener( "key", onKeyEvent )
end

function scene:onResume( )
	-- setting_button
	setting_button:addEventListener( "touch", onButtonClick )
	leaderboard_button:addEventListener( "touch", onButtonClick )
	start_button:addEventListener( "touch", onButtonClick )
end

function onPause( )
	setting_button:removeEventListener( "touch", onButtonClick )
	leaderboard_button:removeEventListener( "touch", onButtonClick )
	start_button:removeEventListener( "touch", onButtonClick )
end

local function showAd(  )
	if (math.random( 10) % 3 == 0) then
		ads.show( "interstitial", { appId = utility.fullScreenad } )
	end
end

-- Called when a key event has been received
local function onKeyEvent( event )
    -- Print which key was pressed down/up
    local message = "Key '" .. event.keyName .. "' was pressed " .. event.phase
    print( message )

   if ( "back" == event.keyName and event.phase == "up" ) then
   	local currScene = composer.getSceneName( "current" )
   	if ( composer.getSceneName( "overlay" ) ) then
        composer.hideOverlay() 
    elseif ( currScene == "menu" ) then
		showAd()
        native.requestExit()
    elseif (currScene == "GameMode") then
    	showAd()
    	composer.removeScene( currScene, false )
      	composer.gotoScene( "menu", "fromLeft", 500 )
    elseif (currScene == "GameOver") then
    	showAd()
    	composer.removeScene( currScene, false )
      	composer.gotoScene( "menu", "fromLeft", 500 )
    elseif (currScene == "GamePlay") then
    	-- ads.show( "interstitial", { appId = utility.fullScreenad } )
    	composer.removeScene( currScene, false )
      	composer.gotoScene( "GameMode", "fromLeft", 500 )
             
    end
        return true
  end
    -- This lets the operating system execute its default handling of the key
    return false
end

-- Add the key event listener
Runtime:addEventListener( "key", onKeyEvent )
---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )


-----------------------------------------------------------------------------------------

return scene