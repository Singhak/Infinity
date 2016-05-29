
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
local addNumtoTable
local getQuiz
local ans = 0
local question
local num_table = {}
local click_enable = true

local ads = require "ads"
local widget = require "widget"
local composer = require( "composer" )
local utility = require ("Utility")
local quiz = require ("QuizGenerater")
local scene = composer.newScene()

local is_effect_on = true
local game_mode
local quiz_text
local score_text
local timer_clock
local score_counter = 0
local secondsLeft = 0
local next_num
local home_button
local countDownTimer
local isGameOver = false
local onGameOver
local score_lable
local quiz_counter = 1
local quiz_num = 0

local function listener1( obj )
    nextNum()
end

-- 
local function playSound( )
	if (is_effect_on) then
		audio.play( utility.soundTable ["num_click_sound"] )
	end
end

function scene:create( event )
	ads.init( "admob", utility.bannerad, nil )
    local sceneGroup = self.view
    local params = event.params
	game_mode = params.mode
    print( game_mode )

    is_effect_on = utility.load("effect", true)

    local background = display.newImageRect( "blank.png", display.contentWidth, display.contentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x, background.y = 0, 0

	score_lable = display.newText( "score: ", contentWidth * 0.12, contentHeight * 0.04, native.systemFont, 20 )
	score_lable:setFillColor( 1,1,0 )
	initUI()
    sceneGroup:insert( background )
    sceneGroup:insert( buttongroup )
    sceneGroup:insert( quiz_text )
    sceneGroup:insert( score_text )
    sceneGroup:insert( timer_clock )
    sceneGroup:insert( score_lable )
    sceneGroup:insert( home_button )
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		if (game_mode == "timeAttack" or game_mode == "infinite") then
			next_num = getRandomNum()
			nextNum()
			secondsLeft = 30
		elseif (game_mode == "fifteenSecond") then
			quiz_num = math.random( 4 )
			getQuiz(quiz_num)
			secondsLeft = 15
			print( "second left " ..secondsLeft )
		end
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- e.g. start timers, begin animation, play audio, etc.
		timer_clock.text = "00:" ..secondsLeft
		countDownTimer = timer.performWithDelay( 1000, updateTime, 0)
		ads.show( "banner", { x=0, y=10000 } )
	end	
end

-- "scene:hide()"
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Example: stop timers, stop animation, stop audio, etc.
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen
    end
end

function scene:destroy( event )
	local sceneGroup = self.view
	print( "buttongroup group " .. buttongroup.numChildren)
	buttongroup:removeSelf( )
	buttongroup = nil
	if (home_button) then
		home_button:removeSelf( )
		home_button = nil
	end
	if (countDownTimer) then
		secondsLeft = 0
		timer.cancel( countDownTimer )
	end
	quiz_text:removeSelf( )
	score_text:removeSelf( )
	timer_clock:removeSelf( )
	score_lable:removeSelf( )
end

-- Button creation funtion
function createButton( tag )
	local button = widget.newButton(
    {
        label = tag,
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
	if (click_enable and event.phase == "began") then
		-- event.target.id = "anil"
		if ( not isGameOver and (id == next_num or id == ans)) then
			click_enable = false
			playSound()
			score_counter = score_counter + 1
			score_text.text = score_counter
			if (game_mode == "fifteenSecond") then
				if (quiz_counter == 5) then
					secondsLeft = secondsLeft + 16
					quiz_counter = 0
					local n = math.random( 4 )
					if (n == quiz_num) then
						if (n == 4) then
							quiz_num = n - 1;
						else
							quiz_num = n + 1
						end
					else
						quiz_num = n
					end
				end
				quiz_counter = quiz_counter + 1
				getQuiz(quiz_num)
			else
				transition.fadeOut( quiz_text, { time=500, onComplete=listener1} )
				event.target.id = largest_num
				event.target:setLabel(largest_num)
				next_num = getRandomNum()
				if (game_mode == "infinite") then
					secondsLeft = secondsLeft + 1
				end
			end
			print( id )
		elseif (id == "home") then
			event.target.xScale = .8 -- scale the button on touch release 
    		event.target.yScale = .8
		elseif (not isGameOver) then
			onGameOver()
		end
	end
	if (event.phase == "ended" or event.phase == "cancelled") then
		if (id == "home") then
			if (is_effect_on) then
				audio.play( utility.soundTable ["button_click_sound"] )
			end			
			event.target.xScale = 1 -- scale the button on touch release 
    		event.target.yScale = 1
    		composer.removeScene( "GamePlay", false )
    		composer.removeScene( "GameMode", false )
    		composer.gotoScene( "menu", "fade", 500 )
		end
	end

end

function onGameOver( )
	if (is_effect_on) then
		audio.play( utility.soundTable ["wrong_button_click"] )
	end
	isGameOver = true
	if (home_button) then
		home_button:removeEventListener( "touch", onButtonClick )
	end	
	if (countDownTimer) then
		timer.cancel( countDownTimer )
	end
	local options =
    {
        effect = "fade",
        time = 500,
        params ={
                    mode = game_mode,
                    score = score_counter
                }
    }
    composer.removeScene( "GamePlay", false )
	composer.removeScene( "GameMode", false )
	composer.gotoScene( "GameOver", options )
	print( "Game over" )
end

function initUI( )
	quiz_text = display.newText( "", contentWidth * 0.5, contentHeight * 0.1, native.systemFontBold, 45 )
	score_text = display.newText( score_counter, contentWidth * 0.24, contentHeight * 0.04, native.systemFont, 20 )
	timer_clock = display.newText( "00:0" .. secondsLeft, contentWidth * 0.5, contentHeight * 0.23, native.systemFontBold, 30 )
	timer_clock:setFillColor( 1, 0, 1 )

	home_button = display.newImageRect("home_icon_crop.png",50, 50)
	home_button.y = home_button.height *.55
	home_button.x = contentWidth - home_button.width * .55
	home_button.id = "home"
	home_button:addEventListener( "touch", onButtonClick )

	createNumTable((grid_size+1) * (grid_size+1))
	createButtonGrid(grid_size)
    buttongroup.x = (contentWidth - (grid_size * buttonW + grid_size * stepX))/2
    buttongroup.y = contentHeight * 0.35
end

math.randomseed( os.time() )
 
function shuffleTable( t )
	print( "shuffleTable" )
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

function updateTime( event )
	-- decrement the number of seconds
	secondsLeft = secondsLeft - 1
	
	-- time is tracked in seconds.  We need to convert it to minutes and seconds
	local minutes = math.floor( secondsLeft / 60 )
	local seconds = secondsLeft % 60
	
	-- make it a string using string format.  
	local timeDisplay = string.format( "%02d:%02d", minutes, seconds )
	timer_clock.text = timeDisplay
	if (seconds == 0 and minutes == 0) then
		timer.cancel( event.source )
		print( "game over" )
		onGameOver()
	end
end

function nextNum(  )
	click_enable = true
	quiz_text.text = next_num
	transition.fadeIn( quiz_text, {time = 500} )
end

function updateButton( )
	-- print( "update group " ..#buttongroup)
	for j = 1, buttongroup.numChildren do
		-- print( "update group " ..j)
		local child = buttongroup[j]
		child.id = num_table[j]
		child:setLabel(num_table[j])
	end
end

local function numExist( num )
	for j = 1, #num_table do
		-- print( "exist false" )
		if (num_table[j] == num) then
			-- print( "exist true" )
			return true
		end
	end
	return false
end
function addNumtoTable( num )
	local table_size = (grid_size + 1) * (grid_size + 1)
	local index = math.random( table_size)
	-- print( "index " ..index )
	if (not numExist(num)) then
		num_table[index] = num
	end
	shuffleTable(num_table)
	updateButton()
end

function getQuiz( quiznum )
	-- print( "quiz num " .. quiznum )
	if (quiznum == 1) then
		-- print( "quiz num sum" )
		next_num, ans = quiz.sum()
		addNumtoTable(ans)
	elseif (quiznum == 2) then
		-- print( "quiz num minus " .. quiznum )
		next_num, ans = quiz.minus()
		addNumtoTable(ans)
	elseif (quiznum == 3) then
		-- print( "quiz num mul " .. quiznum )
		next_num, ans = quiz.multiply()
		addNumtoTable(ans)
	elseif (quiznum == 4) then
		-- print( "quiz num divide " .. quiznum )
		next_num, ans = quiz.divide()
		addNumtoTable(ans)
	end
	if (next_num ~= nil) then
		transition.fadeOut( quiz_text, { time=500, onComplete=listener1} )
	end
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
return scene