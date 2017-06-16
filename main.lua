lg = love.graphics

function love.load()
	points = {}

	lineA = {}
	lineB = {}
	lineX = {}

	bezier = {}

	time = 0
	step = 100
	c = 0
end

function love.update(dt)
	if #points < 4 then return end

	if(c == step) then
		return
	else
		if time < 1 / step then
			time = time + dt
		else
			time = 0

			c = c + 1

			if lineB.pointA.x < lineB.pointB.x then
				lineX.pointB.x = lineX.pointB.x - math.abs(lineB.pointA.x - lineB.pointB.x) / step
			else
				lineX.pointB.x = lineX.pointB.x + math.abs(lineB.pointA.x - lineB.pointB.x) / step
			end

			if lineB.pointA.y < lineB.pointB.y then
				lineX.pointB.y = lineX.pointB.y - math.abs(lineB.pointA.y - lineB.pointB.y) / step
			else
				lineX.pointB.y = lineX.pointB.y + math.abs(lineB.pointA.y - lineB.pointB.y) / step
			end

			if lineA.pointA.x < lineA.pointB.x then
				lineX.pointA.x = lineX.pointA.x + math.abs(lineA.pointB.x - lineA.pointA.x) / step
			else
				lineX.pointA.x = lineX.pointA.x - math.abs(lineA.pointB.x - lineA.pointA.x) / step
			end

			if lineA.pointA.y < lineA.pointB.y then
				lineX.pointA.y = lineX.pointA.y + math.abs(lineA.pointB.y - lineA.pointA.y) / step
			else
				lineX.pointA.y = lineX.pointA.y - math.abs(lineA.pointB.y - lineA.pointA.y) / step
			end

			table.insert(bezier, calcLineX(lineX, true))
		end
	end
end

function calcLineX(line)
	point = {x = 0, y = 0}

	if lineX.pointA.x < lineX.pointB.x then
	    point.x = lineX.pointA.x + math.abs(lineX.pointB.x - lineX.pointA.x) / step * c
	else
	    point.x = lineX.pointA.x - math.abs(lineX.pointB.x - lineX.pointA.x) / step * c
	end

	if lineX.pointA.y < lineX.pointB.y then
		point.y = lineX.pointA.y + math.abs(lineX.pointB.y - lineX.pointA.y) / step * c
	else
		point.y = lineX.pointA.y - math.abs(lineX.pointB.y - lineX.pointA.y) / step * c
	end

	return point
end

function love.draw()
	drawLine(lineA, false)
	drawLine(lineB, false)
	drawLine(lineX, true)

	drawBezier()

	lg.print("left mouse click reset\nright mouse click add point", 10, 10)
end

function drawLine(line, isX)
	if #points < 4 then
		for i = 1, #points do
			lg.circle("fill", points[i].x, points[i].y, 5)
		end
	else
		if isX then
			lg.setColor(255, 0, 0)
		end

		lg.circle("fill", line.pointA.x, line.pointA.y, 5)
		lg.circle("fill", line.pointB.x, line.pointB.y, 5)
		
		lg.line(line.pointA.x, line.pointA.y, line.pointB.x, line.pointB.y)

		lg.setColor(255, 255, 255)
	end
end

function drawBezier()
	lg.setColor(0, 255, 0)

	for i = 1, #bezier do
        lg.circle("fill", bezier[i].x, bezier[i].y, 1)
    end

    lg.setColor(255, 255, 255)
end

 
function love.mousepressed(x, y, button, istouch)
	--reset
	if button == 2 then
		love.load()
	elseif button == 1 and #points < 4 then
		table.insert(points, {x = x, y = y})

		if #points == 4 then
			lineA = {
				pointA = {x = points[1].x, y = points[1].y},
				pointB = {x = points[2].x, y = points[2].y}
			}

			lineB = {
				pointA = {x = points[3].x, y = points[3].y},
				pointB = {x = points[4].x, y = points[4].y}
			}

			lineX = {
				pointA = {	x = lineA.pointA.x, 
							y = lineA.pointA.y},
				pointB = {	x = lineB.pointB.x, 
							y = lineB.pointB.y}
			}

			bezier = {x = points[1].x, y = points[1].y}
		end
	end
end