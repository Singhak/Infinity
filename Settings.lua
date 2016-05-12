-----------------------------------------------------------------------------------------
--
-- stage.lua
--
-----------------------------------------------------------------------------------------
local composer = require ("composer")
local widget = require ("widget")
local utility = require ("Utility")
---------------------------------------
local scene = composer.newScene()

local close_button
local leaderboard_button
local more_apps_button
local music_button
local effect_button

local contentW = display.contentWidth
local contentH = display.contentHeight

local sound_on_img = {type = "image", filename = "sound_on.png"}
local sound_off_img = {type = "image", filename = "sound_off.png"}
local effect_on_img = {type = "image", filename = "music_on.png"}
local effect_off_img = {type = "image", filename = "sound_off.png"}

local background = display.newRoundedRect(0,0, contentW  * 0.8, contentH * 0.5, 15)
background.strokeWidth = 4
background:setFillColor( 0.1 )
background:setStrokeColor( 1, 0, 1 )
background.x = display.contentWidth * .5
background.y = display.contentHeight *.5

local function onButtonClick(event)
	local id = event.target.id
	if (event.phase == "began") then
		if (id == "close") then
			composer.hideOverlay( "Settings" )
		elseif (id == "moreapps") then

		elseif (id == "leaderboard") then 

		elseif (id == "effect") then
			local isSound = utility.load("effect", true)
			print( isSound )

			if (isSound) then
				utility.save("effect", false)
				effect_button.fill = effect_off_img
			else
				utility.save("effect", true)
				effect_button.fill = effect_on_img
			end
			
		elseif (id == "music") then
			local isMusic = utility.load("music", true)
			if (isMusic) then
				utility.save("music", false)
				music_button.fill = sound_off_img
			else
				utility.save("music", true)
				music_button.fill = sound_on_img
			end
		end
	end
	return true
end

local function initUI( )
	-- setting Button
	more_apps_button = display.newImageRect("setting_icon1.png", 45, 45)
	more_apps_button.x = contentW * .65 + more_apps_button.height
	more_apps_button.y = contentH * .68 - more_apps_button.width
	more_apps_button.id = "moreapps"
	more_apps_button:addEventListener( "touch", onButtonClick )

	-- LeaderboardButton
	leaderboard_button = display.newImageRect("lb_icon.png", 45, 45)
	leaderboard_button.y = contentH * .68 - leaderboard_button.height
	leaderboard_button.x = contentW * .078 + leaderboard_button.width
	leaderboard_button.id = "leaderboard"
	leaderboard_button:addEventListener( "touch", onButtonClick )

	-- Play button
	music_button = display.newRect(0, 0, 45, 45)
	local isMusic = utility.load("music", true)
	if (isMusic) then
		music_button.fill = sound_on_img
	else
		music_button.fill = sound_off_img
	end
	
	music_button.y = contentH * 0.25 + music_button.height
	music_button.x = contentW * 0.65 + music_button.width
	music_button.id = "music"
	music_button:addEventListener( "touch", onButtonClick )

	effect_button = display.newRect(0, 0, 45, 45)
	local isEffect = utility.load("effect", true)
	if (isEffect) then
		effect_button.fill = effect_on_img
	else
		effect_button.fill = effect_off_img
	end
	effect_button.y = contentH * 0.25 + effect_button.height
	effect_button.x = contentW * 0.078 + effect_button.width
	effect_button.id = "effect"
	effect_button:addEventListener( "touch", onButtonClick )

	close_button = widget.newButton(
    {
        label = "Close",
        emboss = true,
        shape = "roundedRect",
        width = 60,
        height = 30,
        cornerRadius = 3,
        fillColor = {default={0.8,0.8,1,1}, over={1,0.4,0,1}},
        strokeColor = { default={1,0,1,1}, over={1,0.1,0.7,0.4} },
        strokeWidth = 4,
        id = "close"
    })
	close_button.x = display.contentWidth*0.5
	close_button.y = display.contentHeight * .7
	close_button:addEventListener( "touch", onButtonClick )
end 

-- Called when the scene's view does not exist:
function scene:create( event )
	local group = self.view

	initUI()
	group:insert( background )
	group:insert( close_button )
	group:insert( leaderboard_button )
	group:insert( more_apps_button )
	group:insert( music_button )
	group:insert( effect_button )
end

-- Called immediately after scene has moved onscreen:
function scene:show( event )
	local group = self.view
	
	-- INSERT code here (e.g. start timers, load audio, start listeners, etc.)
end

function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase
    local parent = event.parent  --reference to the parent scene object

    if ( phase == "will" ) then
        -- Call the "resumeGame()" function in the parent scene
        parent:onResume()
    end
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroy( event )
	local group = self.view
	if PushBtn then
		PushBtn:removeSelf()	-- widgets must be manually removed
		PushBtn = nil
		print( "destroy" )
	end
end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------
return scene


