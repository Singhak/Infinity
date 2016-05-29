local composer = require( "composer" )
local widget = require( "widget" )
local utility = require ("Utility")
local toast = require('plugin.toast')
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called
-- -----------------------------------------------------------------------------------------------------------------

-- Local forward references should go here

-- -------------------------------------------------------------------------------
local infiniteMode_btn
local fifteenSec_btn
local timeAttac_btn
local is_effect_on = true
local options
local function onComplete( event )
    if ( event.action == "clicked" ) then
        local i = event.index
        if ( i == 1 ) then
            composer.gotoScene( "GamePlay", options )
            -- Do nothing; dialog will simply dismiss
        elseif ( i == 2 ) then
            -- Open URL if "Learn More" (second button) was clicked
        end
    end
end

-- Show alert with two buttons
local function alertBox( msg )
    local alert = native.showAlert( "Go Infinite", msg, { "OK" }, onComplete )
end


local function playSound( )
    if (is_effect_on) then
        audio.play( utility.soundTable ["button_click_sound"] )
    end
end

-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view
    local background = display.newImageRect( "blank.png", display.contentWidth, display.contentHeight )
    background.anchorX = 0
    background.anchorY = 0
    background.x, background.y = 0, 0

    is_effect_on = utility.load("effect", true)
    initUI()
    sceneGroup:insert( background )
    sceneGroup:insert( infiniteMode_btn )
    sceneGroup:insert( fifteenSec_btn )
    sceneGroup:insert( timeAttac_btn )
    -- Initialize the scene here
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen)
    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen
        -- Insert code here to make the scene come alive
        -- Example: start timers, begin animation, play audio, etc.
    end
end


-- "scene:hide()"
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is on screen (but is about to go off screen)
        -- Insert code here to "pause" the scene
        -- Example: stop timers, stop animation, stop audio, etc.
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen
    end
end


-- "scene:destroy()"
function scene:destroy( event )

    local sceneGroup = self.view
    -- Called prior to the removal of scene's view
    -- Insert code here to clean up the scene
    -- Example: remove display objects, save state, etc.
end

function initUI( )

    infiniteMode_btn = widget.newButton(
    {
        label = "Infinite",
        emboss = true,
        shape = "roundedRect",
        width = 150,
        height = 50,
        cornerRadius = 3,
        fillColor = {default={0.8,0.8,1,1}, over={1,0.4,0,1}},
        strokeColor = { default={1,0,1,1}, over={1,0.1,0.7,0.4} },
        strokeWidth = 4,
        id = "infinite"
    })
    infiniteMode_btn.x = display.contentWidth*0.5
    infiniteMode_btn.y = display.contentHeight * .25
    infiniteMode_btn:addEventListener( "touch", onButtonClick )

    fifteenSec_btn = widget.newButton(
    {
        label = "15 seconds",
        emboss = true,
        shape = "roundedRect",
        width = 150,
        height = 50,
        cornerRadius = 3,
        fillColor = {default={0.8,0.8,1,1}, over={1,0.4,0,1}},
        strokeColor = { default={1,0,1,1}, over={1,0.1,0.7,0.4} },
        strokeWidth = 4,
        id = "fifteenSecond"
    })
    fifteenSec_btn.x = display.contentWidth*0.5
    fifteenSec_btn.y = display.contentHeight * .5
    fifteenSec_btn:addEventListener( "touch", onButtonClick )

    timeAttac_btn = widget.newButton(
    {
        label = "Time Attack",
        emboss = true,
        shape = "roundedRect",
        width = 150,
        height = 50,
        cornerRadius = 3,
        fillColor = {default={0.8,0.8,1,1}, over={1,0.4,0,1}},
        strokeColor = { default={1,0,1,1}, over={1,0.1,0.7,0.4} },
        strokeWidth = 4,
        id = "timeAttack"
    })
    timeAttac_btn.x = display.contentWidth*0.5
    timeAttac_btn.y = display.contentHeight * .75
    timeAttac_btn:addEventListener( "touch", onButtonClick )
end

function onButtonClick( event )
    local id = event.target.id
    
    if (event.phase == "began") then
        playSound()
        local msg = "In this mode you have 15 second to solve FIVE mathamatical puzzel. After each set ofpuzzel" .." "..
        "next new set of Five puzzel come and add 15 second more in remaining time. For solving each puzzel you will get 1 point"
        if (id == "fifteenSecond") then
            options =
            {
                effect = "fade",
                time = 500,
                params ={
                             mode = "fifteenSecond",
                        }
            }
            -- toast.show("To be announce")
            alertBox(msg)
            -- composer.showOverlay( "GamePlay", options )
        elseif (id == "infinite") then
            local msg = "In this mode by default time is 30 seconds, but time will increase by 1 second when you will give right answer."
            options =
            {
                effect = "fade",
                time = 500,
                params ={
                             mode = "infinite",
                        }
            }
            alertBox(msg)
            -- composer.gotoScene( "GamePlay", options )
        elseif (id == "timeAttack") then
            local msg = "In this mode you have to make maximum score with in given time limit."
            options =
            {
                effect = "fade",
                time = 500,
                params ={
                             mode = "timeAttack",
                        }
            }
            alertBox(msg)
            -- composer.gotoScene( "GamePlay", options )
        end
    end
end
-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene