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

local home_button
local restart_button
local restart_mode
local current_score
local best_score
local score_label
local best_score_label

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
background.y = display.contentHeight *.55

local function onButtonClick(event)
    local id = event.target.id
    if (event.phase == "began") then
        if (id == "home") then
            composer.removeScene( "GameOver", false )
            composer.removeScene( "GamePlay", false )
            composer.removeScene( "GameMode", false )
            composer.gotoScene( "menu", "fade", 500 )
        elseif (id == "restart") then 
             local options =
            {
                effect = "fade",
                time = 500,
                params ={
                             mode = restart_mode
                        }
            }
            composer.removeScene( "GameOver", false )
            composer.removeScene( "GamePlay", false )
            composer.removeScene( "GameMode", false )
            composer.gotoScene( "GamePlay", options )
        end
    end
    return true
end

local function initUI( )
    -- setting Button
    restart_button = display.newImageRect("replay_icon.png", 45, 45)
    restart_button.x = contentW * .65 + restart_button.height
    restart_button.y = contentH * .80 - restart_button.width
    restart_button.id = "restart"
    restart_button:addEventListener( "touch", onButtonClick )

    -- LeaderboardButton
    home_button = display.newImageRect("home_icon_crop.png", 45, 45)
    home_button.y = contentH * .80 - home_button.height
    home_button.x = contentW * .078 + home_button.width
    home_button.id = "home"
    home_button:addEventListener( "touch", onButtonClick )
end 

-- Called when the scene's view does not exist:
function scene:create( event )
    local group = self.view
    local params = event.params
    restart_mode = params.mode
    local curr_score = params.score

    local best = utility.load(restart_mode, curr_score)
    if (best < curr_score) then
        best = curr_score
        utility.save(restart_mode, best);
    end
    print( best_score )

    local bg = display.newImageRect( "firstScreen.png", display.contentWidth, display.contentHeight )
    bg.anchorX = 0
    bg.anchorY = 0
    bg.x, bg.y = 0, 0

    local score = display.newText( "Game Over", contentW * 0.5, contentH * 0.2, native.systemFont, 30 )
    score:setFillColor( 1,1,0 )
    best_score_label = display.newText( "Best Score", contentW * 0.5, contentH * 0.38, native.systemFont, 20 )
    best_score_label:setFillColor( 1,1,0 )
    score_label = display.newText( "Current Score", contentW * 0.5, contentH * 0.53, native.systemFont, 20 )
    score_label:setFillColor( 1,1,0 )

    best_score = display.newText( best, contentW * 0.5, contentH * 0.43, native.systemFont, 20 )
    best_score:setFillColor( 1,1,0 )
    current_score = display.newText( curr_score, contentW * 0.5, contentH * 0.58, native.systemFont, 20 )
    current_score:setFillColor( 1,1,0 )

    initUI()
    
    group:insert( bg )
    group:insert( score )
    group:insert( background )
    group:insert( score_label )
    group:insert( best_score_label )
    group:insert( home_button )
    group:insert( best_score )
    group:insert( current_score )
    group:insert( restart_button )
end

-- Called immediately after scene has moved onscreen:
function scene:show( event )
    local group = self.view
    
    -- INSERT code here (e.g. start timers, load audio, start listeners, etc.)
end

function scene:hide( event )
    local sceneGroup = self.view
    if ( phase == "will" ) then
        -- Call the "resumeGame()" function in the parent scene
    end
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroy( event )
    local group = self.view
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


