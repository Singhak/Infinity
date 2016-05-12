
--Uitility
local contentWidth = display.contentWidth
local contentHeight = display.contentHeight
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local buttongroup = display.newGroup()
local buttonW = 40.0
local stepX = 30.0
local grid_size = 3
local largest_num = (grid_size + 1) * (grid_size + 1)

-- forward declare
local createButton
local initUI
local shuffleTable
local createNumTable
local getRandomNum 
local nextNum 
local num_table = {}

local widget = require "widget"
local composer = require( "composer" )
local scene = composer.newScene()

local game_mode
local quiz_text
local score_text
local timer_clock
local score_counter = 0
local secondsLeft = 00
local next_num
local home_button
local countDownTimer
local function listener1( obj )
    nextNum()
end

-- 
function scene:create( event )
    local sceneGroup = self.view
    local params = event.params
	game_mode = params.mode
    print( game_mode )

    local background = display.newImageRect( "blank.png", display.contentWidth, display.contentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x, background.y = 0, 0

	local score = display.newText( "score: ", contentWidth * 0.12, contentHeight * 0.04, native.systemFont, 20 )
	score:setFillColor( 1,1,0 )
	initUI()
    sceneGroup:insert( background )
    sceneGroup:insert( buttongroup )
    sceneGroup:insert( quiz_text )
    sceneGroup:insert( score_text )
    sceneGroup:insert( timer_clock )
    sceneGroup:insert( score )
    sceneGroup:insert( home_button )
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		next_num = getRandomNum()
		nextNum()
		if (game_mode == "timeAttack") then
			secondsLeft = 30
			timer_clock.text = "00:" ..secondsLeft
			countDownTimer = timer.performWithDelay( 1000, updateTime, secondsLeft )
		elseif (game_mode == "infinite") then
			timer_clock.isVisible = false
		end
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
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

function scene:destroy( event )
	local sceneGroup = self.view
	-- scene:removeSelf( )
end

-- Button creation funtion
function createButton( tag )
	local button = widget.newButton(
    {
        label = tag,
        -- font = native.systemFontBold
        emboss = true,
        shape = "roundedRect",
        width = buttonW,
        height = buttonW,
        cornerRadius = 3,
        fillColor = {default={0.8,0.8,1,1}, over={1,0.4,0,1}},
        -- fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
        strokeColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
        strokeWidth = 4
    })
    return button
end

function createButtonGrid(grid_size)
	local y_change = 0;
	local x_change = 0;
	for i= 0,grid_size do
		y_change = i * buttonW + i * stepX
		x_change = 0
		for j= 0,grid_size do
			x_change = buttonW * j + stepX * j
			local tag = i*(grid_size+1) + j+1
			local table_value = num_table[tag]
			local button = createButton( table_value )
			-- print( "Value: " .. tag )
			button.x = x_change
			button.y = y_change
			button.id = table_value
			buttongroup:insert( button )
			button:addEventListener( "touch", onButtonClick )
		end
	end
	
end

function onButtonClick( event )
	local id = event.target.id
	if (event.phase == "began") then
		-- event.target.id = "anil"
		if (id == next_num) then
			transition.fadeOut( quiz_text, { time=500, onComplete=listener1} )
			score_counter = score_counter + 1
			score_text.text = score_counter
			event.target.id = largest_num
			event.target:setLabel(largest_num)
			next_num = getRandomNum()
			print( id )
		elseif (id == "home") then
			event.target.xScale = .8 -- scale the button on touch release 
    		event.target.yScale = .8
		else 
			print( "Game over" )
		end
	end
	if (event.phase == "ended" or event.phase == "cancelled") then
		if (id == "home") then
			event.target.xScale = 1 -- scale the button on touch release 
    		event.target.yScale = 1
    		composer.removeScene( "GamePlay", false )
    		composer.removeScene( "GameMode", false )
    		composer.gotoScene( "menu", "fade", 500 )
		end
	end

end

function initUI( )
	quiz_text = display.newText( "", contentWidth * 0.5, contentHeight * 0.1, native.systemFontBold, 45 )
	score_text = display.newText( score_counter, contentWidth * 0.24, contentHeight * 0.04, native.systemFont, 20 )
	timer_clock = display.newText( "00:" .. secondsLeft, contentWidth * 0.5, contentHeight * 0.23, native.systemFontBold, 30 )
	timer_clock:setFillColor( 1, 0, 1 )

	home_button = display.newImageRect("home_icon.png",50, 50)
	home_button.y = contentHeight - home_button.height *.5
	home_button.x = home_button.width * .5
	home_button.id = "home"
	home_button:addEventListener( "touch", onButtonClick )

	createNumTable((grid_size+1) * (grid_size+1))
	createButtonGrid(grid_size)
    buttongroup.x = (contentWidth - (grid_size * buttonW + grid_size * stepX))/2
    buttongroup.y = contentHeight * 0.35
end

math.randomseed( os.time() )
 
function shuffleTable( t )
    local rand = math.random 
    assert( t, "shuffleTable() expected a table, got nil" )
    local iterations = #t
    local j
    
    for i = iterations, 2, -1 do
        j = rand(i)
        t[i], t[j] = t[j], t[i]
    end
end

function createNumTable( upto )
	for i=1,upto do
		num_table[i] = i
	end
	shuffleTable(num_table)
end

function getRandomNum( )
	local table_size = (grid_size + 1) * (grid_size + 1)
	local index = math.random( table_size)
	-- print( "index " .. index )
	num_to_display = num_table[index]
	largest_num = largest_num + 1
	num_table[index] = largest_num
	-- print( "largest_num : " .. num_table[index] )
	-- print( "value" .. num_to_display )
	return num_to_display
end

function updateTime()
	-- decrement the number of seconds
	secondsLeft = secondsLeft - 1
	
	-- time is tracked in seconds.  We need to convert it to minutes and seconds
	local minutes = math.floor( secondsLeft / 60 )
	local seconds = secondsLeft % 60
	
	-- make it a string using string format.  
	local timeDisplay = string.format( "%02d:%02d", minutes, seconds )
	timer_clock.text = timeDisplay
	if (seconds == 0 and minutes == 0) then
		print( "game over" )
	end
end

function nextNum(  )
	quiz_text.text = next_num
	transition.fadeIn( quiz_text, {time = 500} )
end
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
return scene