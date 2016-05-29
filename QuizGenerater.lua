local Quiz = {}

function Quiz.sum( )
	local x = math.random(10)
	local y = math.random(10)
	print( x .. " " .. y )
	local ans = x + y
	local question = x .." + " .. y
	return question, ans
end

function Quiz.minus( )
	local x = math.random(10)
	local y = math.random(10)
	if (x < y) then
		local z = x
		x = y
		y = z
	end
	local ans = x - y
	local question = x .." - " .. y
	return question, ans
end

function Quiz.multiply( )
	local x = math.random(10)
	local y = math.random(10)
	local ans = x * y
	local question = x .." * " .. y
	return question, ans
end

function Quiz.divide( )
	local x = math.random(20)
	local y = math.random(10)
	if (x < y) then
		local z = x
		x = y
		y = z
	end
	if (x % y ~= 0) then
		x = x + (y - (x%y))
	end
	local ans = x / y
	local question = x .." / " .. y
	return question, ans
end

return Quiz