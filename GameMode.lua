local composer = require( "composer" )
local widget = require( "widget" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called
-- -----------------------------------------------------------------------------------------------------------------

-- Local forward references should go here

-- -------------------------------------------------------------------------------
local infiniteMode_btn
local fifteenSec_btn
local timeAttac_btn

-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view
    local background = display.newImageRect( "blank.png", display.contentWidth, display.contentHeight )
    background.anchorX = 0
    background.anchorY = 0
    background.x, background.y = 0, 0
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
        -- setting Button
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

    -- LeaderboardButton
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

    -- Play button
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
        if (id == "fifteenSecond") then
            local options =
            {
                effect = "fade",
                time = 500,
                params ={
                             mode = "fifteenSecond",
                        }
            }
            
            composer.showOverlay( "GamePlay", options )
        elseif (id == "infinite") then
            local options =
            {
                effect = "fade",
                time = 500,
                params ={
                             mode = "infinite",
                        }
            }
            composer.gotoScene( "GamePlay", options )
        elseif (id == "timeAttack") then
            local options =
            {
                effect = "fade",
                time = 500,
                params ={
                             mode = "timeAttack",
                        }
            }
            composer.gotoScene( "GamePlay", options )
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